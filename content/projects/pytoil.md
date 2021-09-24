+++
author = "Tom Fleet"
title = "pytoil"
date = "2021-03-12"
description = "Handy CLI to manage local and remote development projects."
tags = [
    "python",
    "automation",
    "OSS"
]
draft = false
type = "page"
+++

![logo](/images/projects/pytoil/logo.png)

*pytoil is a small, helpful CLI to help developers manage their local and remote projects with ease!*

* **Source Code**: [https://github.com/FollowTheProcess/pytoil](https://github.com/FollowTheProcess/pytoil)

* **Documentation**: [https://FollowTheProcess.github.io/pytoil/](https://FollowTheProcess.github.io/pytoil/)

## What is it?

`pytoil` is a handy tool that helps you stay on top of all your projects, remote or local. It's primarily aimed at python developers but you could easily use it to manage any project!

pytoil is:

* Easy to use :white_check_mark:
* Easy to configure :white_check_mark:
* Safe (it won't edit your repos at all) :white_check_mark:
* Useful! (I hope :smiley:)

Say goodbye to janky bash scripts :wave:

## Background

Like many developers I suspect, I quickly became bored of typing repeated commands to manage my projects, create virtual environments, install packages, fire off `cURL` snippets to check if I had a certain repo etc.

So I wrote some shell functions to do some of this for me...

And these shell functions grew and grew and grew.

Until one day I saw that the file I kept these functions in was over 1000 lines of bash (a lot of `printf`'s so it wasn't all logic but still). And 1000 lines of bash is *waaaay* too much!

And because I'd basically hacked it all together, it was **very** fragile. If a part of a function failed, it would just carry on and wreak havoc! I'd have to do `rm -rf all_my_projects`... I mean careful forensic investigation to fix it.

So I decided to make a robust CLI with the proper error handling and testability of python, and here it is! :tada:

## Tech Notes

pytoil uses [Typer] under the hood. I wanted to make sure that pytoil was robust and well tested/documented. Currently, pytoil has 100% test coverage and I've tried to be smart with the tests so I'm not just reaching for maximum coverage but the tests actually represent real world situations.

I got quite good at mocking with pytest during this project as most pytoil functions make system calls (to things like `git` and `conda`) so these all have to be mocked out.

The hardest part I found was actually dealing with the parsing of the config file and passing that info around the rest of the program, I rewrote the `config.py` module from scratch about 3 or 4 times!

The part I'm probably most happy with is the way pytoil handles virtual environments internally. I defined an abstract base class in `environments/abstract.py` which the two `VirtualEnv` and `CondaEnv` classes inherited from meaning there was method consistency (like `.install()`, `.create()` etc.) meaning I could easily handle them whichever implementation was actually running.

This showed up best when I was refactoring the `.create()` method to optionally include a list of packages specified in the config file. Because the CLI function dealing with this didn't concern itself with which environment it was dealing with, this was about a 10 line change in the two classes and some tweaks to some unit tests and that was it! Very easy!

[Typer]: https://typer.tiangolo.com
