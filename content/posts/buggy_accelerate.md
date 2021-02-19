+++
author = "Tom Fleet"
title = "Buggy Accelerate Backend"
date = "2021-02-16"
description = "Ever run into this weird error using NumPy on macOS?"
tags = [
    "python",
    "numpy",
    "installation",
    "macos"
]
categories = [
    "tips & tricks",
]
series = ["Tips & Tricks"]
draft = false
+++

If you work on macOS and use [numpy], chances are at some point you may have had some very confusing error message appear about "buggy accelerate backend... something something... polyfit sanity check."

If you've not had the joy of running into this particular error: [https://github.com/numpy/numpy/issues/15947](https://github.com/numpy/numpy/issues/15947) I don't envy you.

There's quite a lot of information on the GitHub issue thread about it and on stack overflow etc and honestly you should look at that for a better explanation, those people know far more than me! There's lots of informed discussion on exactly *why* this error is raised which I'm not going to go into here.

However, when this error happened to me a few months ago I ended up trying multiple solutions before finding that thread and getting to the one that worked, in the process messing with my python installation and causing more headaches. 

So I thought the best thing to do is try and summarise (in jokey caveman speak for fun), and point you *precisely* to what fixed it for me incase it helps you.

## Problem

* NumPy needs C for fast maths
* C binary
* Hard to make pip install with binary
* Need wheels
* NumPy has many wheels
* NumPy maintainers need make many wheels
* Sometimes new pythons are quicker than NumPy wheels to release
* If no wheel, pip tries compile NumPy from source
* macOS default make pip use `buggy accelerate backend` for compile
* bad

## Solution

``` shell
# Make pip forget about numpy
pip cache remove numpy

# Non-buggy wheel backend
brew install openblas

cd <your_numpy_project>

# Remove your old virtualenv and create a new one
rm -rf .venv
python3 -m venv .venv

# Activate it
source .venv/bin/activate

# Point numpy to openblas
OPENBLAS="$(brew --prefix openblas)" pip install numpy
```

Fixed :thumbsup:

P.S. Once you've done this once the NumPy wheel is cached and will be used for all future pip installs until a new version is released, you won't need to do `OPENBLAS=...` again unless you:

* Install a different version of NumPy
* Remove pips cache

In either case, just repeat the steps above!

[numpy]: https://numpy.org
