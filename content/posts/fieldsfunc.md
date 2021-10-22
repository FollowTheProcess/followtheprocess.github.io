---
author: "Tom Fleet"
title: "Using FieldsFunc in Go"
date: 2021-10-22T20:34:50+01:00
description: "Example of how strings.FieldsFunc is useful!"
tags:
- "go"
- "tips"
draft: false
type: post
---

I've been playing with Go a lot recently, and one thing it lends itself **really** well to is CLIs (Command Line Interfaces):

* Runs very fast, feels snappy to use
* Standalone, statically linked binary - easy to distribute
* Easy cross-compilation for multiple platforms, OS's and processor architectures
* Excellent libraries for creating CLIs e.g. [cobra]

The excellent [GitHub CLI] is written in Go 👏🏻

So needless to say, I've been writing more than a few CLIs: [gotoil], [tag], [goignore] etc...

As part of this I've found that a very common workflow in many CLI functions is:

1) Shell out to an external program (e.g. git)
2) Capture the output from it (typically a newline separated list)
3) Use that output in your CLI

An example for this might be in [tag] where I parse the output from commands like `git tag --sort='-v:refname'` to get
lists of semver git tags etc.

You could also imagine potentially parsing the output of `ls` or `ps` to get directory or running process info for example.

It's here where I've found `strings.FieldsFunc` incredibly useful!

## The Problem

Basically, we want to capture output from an external tool that looks something like this:

```shell
item1
item2
item3
item4
```

I.e. a newline '/n' separated list of stuff.

## Initial Solution

A first step in Go might be something like this:

```go
// GetData invokes "external command" and returns it's output as
// a string slice
func GetData() ([]string, error) {
    cmd := exec.Command("some", "external", "command")

    out, err := cmd.CombinedOutput()
    if err != nil {
        // Handle the error like good little programmers
        return nil, fmt.Errorf("command error: %s: %w", string(out), err)
    }

    elements := strings.Split(string(out), "\n")

    return elements, nil
}
```

This is fine, it gets us what we want, something like:

```go
func main() {
    elements, err := GetData()
    if err != nil {
        fmt.Fprintf(os.Stderr, "error getting command data: %s", err)
        os.Exit(1)
    }

    fmt.Printf("%v\n", elements)
}
// Output: [item1 item2 item3 item4]
```

This seems fine right? We've split up out output by newlines and we have a string slice of the elements we wanted. Job done 🎉

## Uh oh

Sadly not quite... What if our output has a trailing newline:

```go
func main() {
    elements, err := GetData()
    if err != nil {
        fmt.Fprintf(os.Stderr, "error getting command data: %s", err)
        os.Exit(1)
    }

    fmt.Printf("%v\n", elements)
}
// Output: [item1 item2 item3 item4 ]
```

Did you see that? There's a tiny space at the end of the slice that's very difficult to spot, especially in tests! 

```go
// Before: [item1 item2 item3 item4]
// After: [item1 item2 item3 item4 ]
```

To get a clearer picture we can use the `%#v` `Printf` verb which gives you a more "goish" representation:

```go
func main() {
    elements, err := GetData()
    if err != nil {
        fmt.Fprintf(os.Stderr, "error getting command data: %s", err)
        os.Exit(1)
    }

    fmt.Printf("%#v\n", elements)
}
// Output: []string{"item1", "item2", "item3", "item4", ""}
```

Look! A pesky empty string at the end of the slice caused by the trailing newline.

Now we could write some quick code to check for this trailing empty string in the slice and remove it but there is a better way!

## FieldsFunc

Enter `strings.FieldsFunc`, see the [docs]

We can get exactly what we want by changing our `GetData` function like this:

```go
// GetData invokes "external command" and returns it's output as
// a string slice
func GetData() ([]string, error) {
    cmd := exec.Command("some", "external", "command")

    out, err := cmd.CombinedOutput()
    if err != nil {
        // Handle the error like good little programmers
        return nil, fmt.Errorf("command error: %s: %w", string(out), err)
    }

    // Anonymous function that returns true on newlines
    // this is what does the splitting for us
    f := func(c rune) bool {
        return c == '\n'
    }

    elements := strings.FieldsFunc(string(out), f)

    return elements, nil
}
```

Now, like magic our slice is the same regardless of whether or not there is a trailing newline in the output!

```go
func main() {
    elements, err := GetData()
    if err != nil {
        fmt.Fprintf(os.Stderr, "error getting command data: %s", err)
        os.Exit(1)
    }

    fmt.Printf("%#v\n", elements)
}
// Output: []string{"item1", "item2", "item3", "item4"}
// We win!
```

[GitHub CLI]: https://github.com/cli/cli
[gotoil]: https://github.com/FollowTheProcess/gotoil
[tag]: https://github.com/FollowTheProcess/tag
[goignore]: https://github.com/FollowTheProcess/goignore
[docs]: https://pkg.go.dev/strings#FieldsFunc
[cobra]: https://github.com/spf13/cobra
