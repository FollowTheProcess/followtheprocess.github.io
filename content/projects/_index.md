---
title: "Projects"
type: page
---

Below you'll find some of the top things stealing lots of time from my social life 🤓. There's loads more than what's here, both my projects and other open source stuff I help maintain, but I didn't want to bore! 😴

Check out my [GitHub] if you're interested.

My favourite things to work on are:

* CLIs
* Developer tooling
* Automation
* All 3 combined!

## [pytoil]

pytoil is a helpful CLI to take the toil out of software development!

It seamlessly lets you work with your development projects whether they are on your local machine,
or on GitHub.

In a nutshell you can:

* Open up a project regardless of where it is with a single command
* Fuzzy text search your repos to find matching projects
* Sync your local development directory with your GitHub in seconds
* Automatically detect appropriate python virtual environments on clone and set them up in the background
* And loads more, check out the [docs]

![help](https://github.com/FollowTheProcess/pytoil/raw/main/docs/img/help.svg)

**Highlights:**

* Asynchronous from the ground up, as much as possible is done concurrently
* Beautiful CLI powered by [click] and [rich]
* Optimised performance and memory use, on my machine the CLI starts up in about 200ms (pretty good for a python interpreter!)
* Interacts with the GitHub GraphQL API to fetch only the data it needs
* API requests are cached with a configurable timeout for maximum responsiveness
* Glues together various python development tools (virtualenv, conda, poetry, flit, git, VSCode etc.)
* High test coverage and great [docs]

## [spok]

⚠️ This one is still a work in progress but check back soon 👀

Spok is a modern, concurrent task runner/build system written in Go.

It has it's own, original custom lexed and parsed syntax with the overall (ambitious) objective of being
the modern equivalent to make.

Improvements over make include:

* Much cleaner, more developer friendly syntax
* Tasks (make: targets) are run concurrently by default (unless dependencies preclude)
* Built in support for glob patterns
* Full cross-compatibility, tested on mac, linux and windows
* Incremental runs based on file dependency hashing not OS timestamps

An example of spok's syntax:

```python
# Comments are preceded by a hash

# You can store global variables like this (caps are optional)
GLOBAL_VARIABLE := "hello"
BIN := "./bin/main"

# You can store the output of a shell command as a variable
# leading and trailing whitespace will always be trimmed off when doing this
GIT_COMMIT := exec("git rev-parse HEAD")

# Use a global variable like this
task hello() {
    echo GLOBAL_VARIABLE
}

# Run the go tests (depends on all go source files)
task test("**/*.go") {
    go test ./...
}

# Format the project source code (depends on all go source files)
# if the go source files have not changed, this becomes a no op
task fmt("**/*.go") {
    go fmt ./...
}

# Compile the program (depends on fmt, fmt will run first)
# also outputs a build binary
task build(fmt) -> "./bin/main" {
    go build
}

# Can also use global variables as outputs
task build2(fmt) -> BIN {
    go build
}

# Tasks can generate multiple things
task many("**/*.go") -> ("output1.go", "output2.go") {
    go do many things
}

# Can also do glob outputs
# e.g. tasks that populate entire directories like building documentation
task glob("docs/src/*.md") -> "docs/build/*.html" {
    build docs
}

# Can register a default task (by default spok will list all tasks)
task default() {
    echo "default"
}

# Can register a custom clean task
# By default `spok --clean` will remove all declared outputs
# if a task called "clean" is present in the spokfile
# this task will be run instead when `--clean` is used
task clean() {
    rm -rf somedir
}
```

I'm currently working towards the MVP stage with just the features it immediately needs but future planned features include:

* Automatic loading of `.env` files
* Passing command line arguments/flags to tasks
* A VSCode extension providing syntax highlighting, task exploration etc.

## [tag]

tag is a CLI to help automate semantic version releases and GitOps.

With tag you can easily create, delete, sort and push git semver tags. It's written in Go including a
hand-rolled, robust semantic version parser.

![demo](https://github.com/FollowTheProcess/tag/raw/main/img/push.png)

**Highlights:**

* Simple, intuitive CLI
* Understands semantic versioning, `tag minor` bumps the minor version etc.
* Can push tags with a single flag: `tag patch --push` will push a new patch tag to the origin repo
* Supports the full range of semantic versions, including build tags and post releases

PS. If someone knows how to use asciicinema or equivalent to record great terminal gifs get in touch, I've tried a few times
but can never get it to work properly! 😂

## [msg]

Continuing the theme of CLIs targeted at developers... msg is a lightweight console printing toolkit for authors
of CLI programs written in Go.

It enables very easy, very pretty output with a very familiar Go `printf` interface.

This:

```go
package main

import "github.com/FollowTheProcess/msg"

func main() {
    msg.Title("Your Title here")
    // Do some stuff

    // Give the user an update
    msg.Info("Getting your files")

    // Report success
    msg.Good("It worked!")

    // Uh oh, an error
    msg.Fail("Oh no!, file not found")

    // Warn a user about something
    msg.Warn("This action is irreversible")
}
```

Gets you this:

![msg-demo](https://github.com/FollowTheProcess/msg/raw/main/img/demo2.png)

I've dogfooded msg into most of my other Go CLIs and it works great!

**Highlights**

* Simple top level interface if you don't want to customise
* Exposes a `Printer` object that lets you configure colors and symbols if you want to
* Has all the go printf verbs for all the constructs (e.g. `Infof` for a formatted info message)
* No fuss, just works!

## [py]

A port of Brett Cannon's excellent [python-launcher] to Go, with some experimentation thrown in for good measure.

Does all the things the original does i.e. all you have to do is run `py` and it will find the 
python interpreter you almost certainly want to use:

![py-demo](https://github.com/FollowTheProcess/py/raw/main/docs/img/demo.png)

The few experimental tweaks I've made:

* This one also finds virtual environments named `venv` not just `.venv` (even though I prefer the latter)
* This one won't let you do anything with python2, it completely ignores any python 2 interpreter it finds
* It won't climb the file tree searching for `.venv` it just looks in `$CWD`

I was actually quite impressed that it gets very close to the performance of the original (written in rust), especially
considering I've made no real effort to optimise it!

![py-benchmark](https://raw.githubusercontent.com/FollowTheProcess/py/main/docs/img/comp.png)

* **Left:** My version, written in Go
* **Right:** The original, written in Rust

I've also kept the nice support for ancillary dev tools like shell prompts etc:

![py-starship](https://github.com/FollowTheProcess/py/raw/main/docs/img/starship_demo.png)

[GitHub]: https://github.com/FollowTheProcess
[pytoil]: https://github.com/FollowTheProcess/pytoil
[click]: https://click.palletsprojects.com/en/8.0.x/
[rich]: https://rich.readthedocs.io/en/stable/introduction.html
[docs]: https://followtheprocess.github.io/pytoil/
[spok]: https://github.com/FollowTheProcess/spok
[tag]: https://github.com/FollowTheProcess/tag
[msg]: https://github.com/FollowTheProcess/msg
[py]: https://github.com/FollowTheProcess/py
[python-launcher]: https://github.com/brettcannon/python-launcher
