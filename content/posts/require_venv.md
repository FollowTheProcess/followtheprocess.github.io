---
author: "Tom Fleet"
title: "Prevent Global Pip Installs"
date: 2021-02-23T14:21:11Z
description: "Cool trick to prevent you screwing up your system python."
tags:
- "python"
- "virtual environments"
- "pip"
categories:
- "tips & tricks"
draft: false
---

This is going to be a short one, about something I discovered in the [pip] documentation the other day and never knew about and I wish I did before I broke my python installation a dozen times when I was first starting out!

## Problem

We all know the dangers of breaking your system python installation with package conflicts.

Virtual environments are probably the most common way of avoiding nasty package conflicts. A virtual environment is effectively (but not exactly) a self contained version of python you can install packages into without touching your system python.

Tools like [venv] and [virtualenv] are the standard for this case. Tools like [conda] and [poetry] go even further by basically managing the entire project's dependencies *as well as* the virtual environment.

Another solution is to use [pyenv] which installs a completely separate version of python on top of your system python. If you go down this route, I'd recommend treating the pyenv installation basically as if it was your system (read my [post]({{< ref "/posts/pyenv.md" >}}) about this if you want more info.)

But sometimes, no matter how careful you are, you can slip up and `pip install {something}` into your global python. By itself this isn't too bad, but if you slip up like this enough, you could easily end up with nasty package conflicts.

## Solution

However, like most other things you could worry about, the python developers have got you covered.

It turns out that there is an environment variable `PIP_REQUIRE_VIRTUALENV` that pip will check for before doing anything that might alter your system/environment.

If you set this environment variable to `true` like this...

```bash
# Inside ~/.zshrc or ~/.bashrc or whatever your shells init file is

export PIP_REQUIRE_VIRTUALENV=true
```

Then pip literally won't let you do anything stupid until you're in an activate virtual environment!

See...

![pip without a virtual environment](/images/posts/pip_no_venv.png)

But if I create a virtual environment and repeat (notice the `.venv` in my shell prompt)...

![pip with a virtual environment](/images/posts/pip_venv.png)

Easy :grin:

[pip]: https://pip.pypa.io/en/stable/
[venv]: https://docs.python.org/3/library/venv.html
[virtualenv]: https://virtualenv.pypa.io/en/latest/
[conda]: https://docs.conda.io/en/latest/
[pyenv]: https://github.com/pyenv/pyenv
[poetry]: https://python-poetry.org
