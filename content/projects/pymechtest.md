+++
author = "Tom Fleet"
title = "pymechtest"
date = "2021-02-17"
description = "Automate the boring parts of mechanical test analysis with python!"
tags = [
    "python",
    "automation",
    "engineering",
    "OSS"
]
type = "page"
+++

![logo](/images/projects/pymechtest/logo.png)

[![License](https://img.shields.io/github/license/FollowTheProcess/pymechtest)](https://github.com/FollowTheProcess/pymechtest)
[![PyPI](https://img.shields.io/pypi/v/pymechtest.svg)](https://pypi.python.org/pypi/pymechtest)
[![GitHub](https://img.shields.io/github/v/release/FollowTheProcess/pymechtest?logo=github&sort=semver)](https://github.com/FollowTheProcess/pymechtest)
[![Code Style](https://img.shields.io/badge/code%20style-black-black)](https://github.com/FollowTheProcess/pymechtest)
[![CI](https://github.com/FollowTheProcess/pymechtest/workflows/CI/badge.svg)](https://github.com/FollowTheProcess/pymechtest/actions?query=workflow%3ACI)
[![Coverage](/images/projects/pymechtest/coverage.svg)](https://github.com/FollowTheProcess/pymechtest)

*pymechtest is a small, hopefully helpful python package to help engineers collate, process, analyse, and report on mechanical test data. I built pymechtest to help automate the things I did on a near-daily basis as a materials engineer. I hope it can prove some use to you too!*

* **Source Code**: [https://github.com/FollowTheProcess/pymechtest](https://github.com/FollowTheProcess/pymechtest)

* **Documentation**: [https://FollowTheProcess.github.io/pymechtest/](https://FollowTheProcess.github.io/pymechtest/)

## Overview

Have you ever had to process a bunch of csv output from a mechanical test machine, copying and pasting data into a hacky Excel template to calculate things like elastic modulus and yield strength?

Only to then have to make another Excel file where you create a summary table...

And then have to copy and paste that into a report or an email...

And then you have to plot the data in Excel and spend half an hour tweaking the colours to get it to look at least halfway professional...

And then you discover Excel has formatted your strain column as a date for literally no reason so now your plots have broken...

And then next week you have to do all this again! :angry:

**No more!** :boom:

pymechtest has a very simple goal: to reduce the amount of time engineers spend munging data after a batch of mechanical testing.

Here is a quick taste of how easy it is to go from raw data to a gorgeous stress-strain plot:

```python
from pymechtest import Tensile

# header and id_row are related to the structure of your csv files
tens = Tensile(folder = "path/to/raw/data", header = 8, id_row = 3)

# Plot a really nice stress-strain curve with Altair
tens.plot_curves()
```

![plot_curves](/images/projects/pymechtest/plot_curves.png)

The key features are:

* **Intuitive**: The API is very intuitive, with descriptive methods like `plot_curves` and `summarise`
  
* **Column Autodetection**: pymechtest will try to auto-detect which columns correspond to stress and strain, and ask you to clarify if it can't.
  
* **Sensible Defaults**: The API is designed around sensible defaults for things like modulus strain range, whether to expect a yield strength etc.
  
* **Automatic Calculations**: pymechtest will automatically calculate strength, elastic modulus, yield strength etc. for you.
  
* **Elegant Looking Stress Strain Curves**: pymechtest uses [altair] to plot amazing looking stress strain curves.
  
* **Reliable**: pymechtest uses battle-tested libraries like [pandas], [numpy] and [altair] to do most of the work. The API is really a domain-specific convenience wrapper. pymechtest also maintains high test coverage.

## Background

I came up with pymechtest during my day to day work as a materials scientist. I'd often have to do a batch of mechanical testing and for years I'd use the same old clunky, hacky workflow:

* Multiple excel files or tabs
* Fragile and hacky formulas to calculate things
* Lots of copying and pasting
* VERY manual! :rage:

So initially I wrote a bunch of scripts to do each thing independently, and then when I'd finally had enough of that I decided to put it all in one place.

## Tech Notes

pymechtest was my first ever fully fledged python package, albeit quite a simple one. Sticking with the mantra of "standing on the shoulders of giants", it really just provides a domain specific convenience wrapper around [pandas] for loading the data, [numpy] for doing the calculations, and [altair] for doing the plotting.

It was the first thing I wrote where I had to consider how someone might use it and had to think carefully about the (admittedly tiny) public API. I also tried to use Test Driven Development for the first time and learned a lot about automated testing in python.

It was also the first thing I'd ever built docs for, [sphinx] and restructuredtext seemed a bit daunting to me so I went with [mkdocs] and the truly excellent [mkdocs material] theme. And like everything else, as soon as I'd figured out how it worked, I made [nox] automate it for me!

Because a lot of (static) mechanical tests are based on the same principles and often export very similar data, I decided to pull all the logic out into a `BaseMechanicalTest` class and the test specific classes like `Tensile`, `Compression`, `Shear` etc. would just inherit from it and act as convenience classes. This also let me use the `__class__.__qualname__` attribute to fill in things like graph titles, column names etc. which was a cool trick! :nerd_face:.

pymechtest uses [nox] and [github actions] for CI/CD and this proved invaluable testing against multiple python versions, in both pip and conda environments, building docs, automatic releases to both PyPI and GitHub.

I use both nox and github actions for everything now!

All in all it's not a complex project at all but I learned a lot and use it myself regularly!

There is a [roadmap] and I'm still actively developing pymechtest towards these goals around my other projects.

[altair]: https://altair-viz.github.io
[pandas]: https://pandas.pydata.org
[numpy]: https://numpy.org
[sphinx]: https://www.sphinx-doc.org/en/master/
[mkdocs]: https://www.mkdocs.org
[mkdocs material]: https://squidfunk.github.io/mkdocs-material/
[nox]: https://nox.thea.codes/en/stable/
[github actions]: https://github.com/features/actions
[roadmap]: https://followtheprocess.github.io/pymechtest/roadmap.html
