---
title: "Gotoil"
type: page
---

![logo](/images/projects/gotoil/logo.png)

Handy CLI to automate the development workflow :robot:

* Free software: Apache Software License 2.0

## Project Description

`gotoil` is a handly CLI tool that helps you stay on top of all your development projects, whether they're on your local machine or on GitHub! It's based on it's sister project [pytoil] but (as you've probably guessed by the name) it's written in Go, not python!

[pytoil] is aimed primarily at python developers, it has some python specific features such as automatically creating and managing virtual environments. Gotoil was written as a much more general tool and just implements the core features everyone is likely to use regardless of tech stack!

However, just like [pytoil], gotoil is:

* Easy to use :white_check_mark:
* Easy to configure :white_check_mark:
* Safe (it won't edit your repos at all) :white_check_mark:
* Useful! (I hope :smiley:)

Say goodbye to janky bash scripts :wave:

## Installation

There are compiled executables for mac, linux and windows in the GitHub releases section, just download the correct one for your system and architecture and put it somewhere on `$PATH`

There is also a [homebrew] tap:

```shell
brew tap FollowTheProcess/homebrew-tap

brew install FollowTheProcess/homebrew-tap/gotoil
```

## Quickstart

`gotoil` is super easy to get started with.

After installation just run

```shell
$ gotoil config show

No config file yet!
Making you a default one...
```

This will create a default config file which can be found at `~/.gotoil.yaml`. See the [docs] for what information you need to put in here.

Don't worry though, there's only a few options to configure! :sleeping:

After that you're good to go! You can do things like:

#### See your local and remote projects

```shell
gotoil show all
```

#### See which ones you have on GitHub, but not on your computer

```shell
gotoil show diff
```

#### Easily grab a project, regardless of where it is

```shell
gotoil checkout my_project
```

#### Create a new project in the right place

```shell
gotoil new my_project

```

#### And even do this from a [cookiecutter] template

```shell
gotoil new my_project --cookie https://github.com/some/cookie.git
```

Check out the [docs] for more :boom:

## Contributing

`gotoil` is an open source project and, as such, welcomes contributions of all kinds :smiley:

Your best bet is to check out the [contributing guide] in the docs!

### Credits

This package was created with [cookiecutter](https://github.com/cookiecutter/cookiecutter) and the [FollowTheProcess/go_cookie](https://github.com/FollowTheProcess/go_cookie) project template.

`gotoil` has been built on top of these fantastic projects:

* [cobra]
* [viper]
* [cookiecutter]
* [color]
* [survey]

[pytoil]: https://github.com/FollowTheProcess/pytoil
[homebrew]: https://brew.sh
[cobra]: https://github.com/spf13/cobra
[viper]: https://github.com/spf13/viper
[cookiecutter]: https://github.com/cookiecutter/cookiecutter
[color]: https://github.com/fatih/color
[survey]: https://github.com/AlecAivazis/survey
