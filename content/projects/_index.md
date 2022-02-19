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
* Things useful for myself
* All of the above!

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
* Tag releases itself, it's recursive!

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

## [goignore]

Generate great `.gitignore` files straight from the command line!

Goignore is a super small, super simple project, but one that I find very useful and I use it
more or less every day.

This:

![goignore-demo](/images/projects/goignore/goignore_demo.png)

Gets you this:

![gitignore](/images/projects/goignore/gitignore.png)

PS. Goignore was actually the first proper program I ever wrote in Go!

## [Fatigue Damage Prediction]

This was not so much a developer project but my masters thesis, obviously I'm not working on it any more (I passed 🤓) but I figured I'd include it here because it's actually
pretty cool, and is the last remnants of a previous life in materials science!

*Using machine learning to predict fatigue crack growth under complex thermomechanical loads. Achieved a damage severity predicive accuracy of ±0.25mm and a positional predictive accuracy of ±7.0mm.*

### Background

Repeated cyclic loading of a material will eventually lead to a phenomenon called "fatigue crack growth". I'm not going to explain the details here but I'd point you to [this](https://en.wikipedia.org/wiki/Fatigue_(material)) for more info. Essentially, a crack will start to form and repeated cyclic loading will progressively grow this crack until it is large enough such that the remaining material can no longer handle the stress and the component will break.

Ever since the [comet disasters](https://en.wikipedia.org/wiki/De_Havilland_Comet#Accidents_and_incidents) in the 1950's, understanding exactly how this process works and predicting how long (or more accurately: how many cycles) components can survive for has been a crucial part of the design process. This is done with the so-called Paris Law (although in reality, it's a lot more complicated than this theoretical abstraction).

$$da/dN = C(\Delta K)^m$$

Where da is the increment in crack length, dN is the increment in number of cycles, C and m are material-specific constants and Delta K is the increment in stress intensity factor (effectively a way of accounting for the increased stress around a defect such as a crack).

Pure loading fatigue is very well understood nowadays. However, when you combine fatigue crack growth with other environmental effects such as corrosion, thermal cycling etc. this can result in very unpredictable behaviour.

The aim of this project was to understand how one of these combinations (fatigue and thermal effects) could be better understood with the application of machine learning.

Experimental data on the effect of crack propagation on dynamic response (vibration) was generated in a series of earlier experiments on two different materials and given to me to work with for my MSc Advanced Materials thesis project in Spring 2020.

![Dynamic Response](/images/projects/msc_project/dynamic_response_by_material.png)

Starting notches were machined into test specimens which were then vibrated at their natural frequencies at a variety of temperatures. The cracks were then allowed to grow whilst natural frequency and amplitude measurements were continuously taken in order to determine the effect of crack propagation on dynamic properties.

The objectives of this work were to:

* Build a predictive model capable of accurately predicting damage severity and location from a simple vibration test.

* Use the introspection of the model to attempt to inform the fundamental underlying theory

### Results

After using [mlflow](https://mlflow.org) to record parameters and shortlist promising models, I chose a Ridge-regularised multiple Linear Regression model with a polynomial kernel to enable easy introspection as this was a key objective of the project.

The models were able to predict the depth of the crack with high accuracy (shown below) for both materials.

| Material      | RMSE          | $R^2$   |
|:-------------:|:-------------:|:-----:|
| Aluminium     | 0.176 mm      | 0.95  |
| ABS           | 0.256 mm      | 0.86  |

![Model Accuracy](/images/projects/msc_project/combined_accuracy_altair.png)

Traditionally in engineering, data of this sort is usually fed into something like matlab and subject to curve fitting. This was done on this data as a benchmark against which to judge the ML model's accuracy. Below is a comparison of the RMSE between traditional polynomial curve fitting in matlab, and the ridge-regularised multiple linear regression model used in this project.

![Comparison vs Curve Fitting](/images/projects/msc_project/ml_vs_curve_fitting.png)

As you can see, the ML model significantly outperformed the traditional polynomial curve fitting method, shaving over 0.6mm off the average prediction error.

The predictions for Aluminium were also more accurate than those for ABS, the reduced accuracy for the ABS being explained by the anisotropic structure and stress crazing at the crack tip caused by the method of manufacture of the test specimens (FDM additive manufacturing).

### Feature Importance

A key part of the project was to understand the underlying factors behind these effects, rather than simply generate predictions. Hence the earlier decision to use a linear model as it's coefficients could be easily inspected.

A feature importance study was conducted, results shown below.

![Feature Importance](/images/projects/msc_project/relative_importance_in_crack_depth_prediction.png)

The data show that the natural frequency was the most important predictor for both materials. Temperature and crack position were shown to be comparatively less important - an interesting finding.

In fact, the comparatively low importance of crack position in the prediction of crack depth allowed me to pull crack position out of the feature pool entirely and predict it alongside crack depth and only sacrifice a small amount of accuracy (shown below).

![Multi Output Prediction](/images/projects/msc_project/multi_output_accuracy.png)

The end result was a model that could predict the severity of a thermomechanical fatigue crack to within ±0.22mm and simultaneously predict its position in the component to within ±7.0mm, an incredibly powerful result!

![Multi Output Crack Depth](/images/projects/msc_project/multi_output_crack_depth.png)

### Further Information

This work was submitted for publication in the academic journal [MDPI Sensors](https://www.mdpi.com/journal/sensors) and was accepted and published on 30/11/2020. Full text available [here](https://www.mdpi.com/1424-8220/20/23/6847)

[1] Fleet, T.; Kamei, K.; He, F.; Khan, M.A.; Khan, K.A.; Starr, A. A Machine Learning Approach to Model Interdependencies between Dynamic Response and Crack Propagation. Sensors 2020, 20, 6847. https://doi.org/10.3390/s20236847

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
[goignore]: https://github.com/FollowTheProcess/goignore
[Fatigue Damage Prediction]: https://github.com/FollowTheProcess/msc_project
