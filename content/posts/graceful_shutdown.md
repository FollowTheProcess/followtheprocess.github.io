---
author: "Tom Fleet"
title: "Shut Down a Go HTTP Server Gracefully"
date: 2021-10-25T19:04:46+01:00
description: "Gracefully shutting down a web server in Go"
tags:
- "Go"
- "HTTP"
draft: false
type: post
---

When developing HTTP services in Go, you will start and stop your server hundreds of times, think of the whole `go run main.go` `ctrl + c` loop!

When you hit `ctrl + c`, (on UNIX systems) your program is passed the `SIGINT` Unix signal. The go runtime handles this and will stop your program relatively safely, but it's not **great** practice!

What if you have database connection pools open or forgot to close a file etc.?

This is where graceful shutdown comes in :tada:

This is going to be a super short post just showing a good example of imnplementing graceful shutdown of a Go HTTP server.

## The Bad Way

A simple web server that connects to a SQL database without graceful shutdown might look something like this:

```go
package main

import (
    "context"
    "database/sql"
    "flag"
    "net/http"
    "os"
    "time"

    _ "github.com/go-sql-driver/mysql"
    "github.com/sirupsen/logrus"
)

const (
    defaultPort = ":8000"
    defaultDSN  = ""
)

type application struct {
    logger        *logrus.Logger
}

func main() {
    // Accept command line flags for configuration and secrets
    port := flag.String("port", defaultPort, "HTTP network address")
    dsn := flag.String("dsn", defaultDSN, "DB Connection string")
    flag.Parse()

    // Set up logger
    log := logrus.New()
    log.Out = os.Stdout

    if *dsn == "" {
        log.Fatalln("dsn must not be empty")
    }

    log.Infoln("Establishing db connection")
    db, err := openDB(*dsn)
    if err != nil {
        log.WithError(err).Fatalln("Error connecting to DB")
    }
    defer func() {
        log.Infoln("Closing DB connection")
        db.Close()
    }()


    app := &application{
        logger:        log,
    }

    srv := &http.Server{
        Addr:         *port,
        Handler:      app.routes(),
        ReadTimeout:  5 * time.Second,  // max time to read request from the client
        WriteTimeout: 10 * time.Second, // max time to write response to the client
        IdleTimeout:  60 * time.Second, // max time for connections using TCP Keep-Alive
    }


    log.WithField("port", *port).Infoln("Starting server on port")

    err := srv.ListenAndServe()
    if err != nil && err != http.ErrServerClosed {
        log.WithError(err).Errorln("Error starting server")
    }
}

func openDB(dsn string) (*sql.DB, error) {
    db, err := sql.Open("mysql", dsn)
    if err != nil {
        return nil, err
    }
    if err = db.Ping(); err != nil {
        return nil, err
    }
    return db, nil
}

```

Notice how we just start the server and log the error here:

```go
err := srv.ListenAndServe()
    if err != nil && err != http.ErrServerClosed {
        log.WithError(err).Errorln("Error starting server")
    }
```

Notice also how we close our database connection in a `defer` function:

```go
db, err := openDB(*dsn)
    if err != nil {
        log.WithError(err).Fatalln("Error connecting to DB")
    }
    defer func() {
        log.Infoln("Closing DB connection")
        db.Close()
    }()
```

In go, when your program is interrupted with `SIGINT` deferred functions aren't run, so we're **relying** on the garbage collector to close our database connection. The Go garbage collector is a work of art and is very good, but **relying** on it when we could handle this better is just bad practice!

## A Better Way

Let's handle the `SIGINT` and gracefully close down the server!

All we need to do is add the following block to our `main` function:

```go
    // start the server in a goroutine so it runs off doing it's own thing
    go func() {
        log.WithField("port", *port).Infoln("Starting server on port")

        err := srv.ListenAndServe()
        if err != nil && err != http.ErrServerClosed {
            log.WithError(err).Errorln("Error starting server")
    }
    }()

    // trap sigterm or interrupt and gracefully shutdown the server
    c := make(chan os.Signal, 1)
    signal.Notify(c, os.Interrupt)
    signal.Notify(c, os.Kill)

    // Block the rest of the code until a signal is received.
    sig := <-c
    log.WithField("sig", sig).Infoln("Got signal")
    log.Infoln("Shutting everything down gracefully")

    // gracefully shutdown the server, waiting max 30 seconds for current operations to complete
    ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
    defer cancel()
    if err := srv.Shutdown(ctx); err != nil {
        log.WithError(err).Fatalln("Graceful shutdown failed")
    }
    log.Infoln("Server shutdown successfully")
```

So here we:

* Replace the call to `ListenAndServe` with one running inside an anonymous goroutine so it goes off and runs without blocking our `main`
* Make a channel on which to pass `SIGINT` and `SIGTERM`
* Register the signals using `signal.Notify`
* Then we try and pull the signal off the channel. Receiving from a channel in go is a blocking operation, meaning the code will not progress past this point unless something (in this case either `SIGINT` or `SIGTERM`) is sent on the channel. Remember, the whole time our `main` is blocked here, our server is off in it's own goroutine happily serving HTTP!
* If we do get a signal, `main` unblocks and we then use `context` to gracefully shutdown the server.
* Now because we've "trapped" the signal sent by `ctrl + c`, our main will exit normally, meaning all the `defer` functions will run, and our DB connection pool will be cleaned up nicely!
