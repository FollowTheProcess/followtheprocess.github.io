+++
author = "Tom Fleet"
title = "Pyenv is Awesome!"
date = "2021-02-19"
description = "Pyenv solves the entire python installation/virtual environment situation."
tags = [
    "python",
    "virtual environments",
    "installation",
]
draft = false
type = "post"
+++

I think everyone who has touched python at some point has seen this picture...

![environment hell](/images/posts/python_environment.png)

It's mainly poking fun at the kinds of ways you can get your installation all screwed up if you're not careful but is often misinterpreted as throwing shade on how python works. 

[Brett Cannon's Blog Post] has an excellent deconstruction of what this xkcd means and how to avoid it.

There's lots you can do to avoid this happening to you. My favourite method is [pyenv].

## What?

Unlike other ways of installing python, or using your system installation (which you should **NEVER** do), [pyenv] actually compiles a version of python direct from source and stores it in it's own special directory far far away from your system python.

So far so good :thumbsup:.

Once it's finished making this **completely separate** python for you. You can set *that* version of python to be your global one. Meaning that even if you open up a terminal and do something like...

``` shell
python
```

And instead of your system's `python3` (or worse it's `python` - meaning python2.7), it will fire up your new, pyenv-managed, python version you just installed.

This all means that if you follow this guide, your installation will **NEVER** end up like the one in the now infamous xkcd above. Your system python (both 3 and 2) will remain a completely hidden layer below where you work and you will never need to touch it.

That's one less thing to worry about whilst you're trying to figure out how to actually do programming:tm:.

## Installation

Now installing it on my mac was pretty straightforward but it can throw errors if you get a step wrong so I'll share the script I used in case its useful to anyone else.

For this to work though, we're going to need to install some compilation dependencies. If you have [homebrew] this is what you'll need to do...

And if you haven't got homebrew... get homebrew. You can thank me later.

### Install xcode command line developer tools

These provide C compilers and other handy things we'll need later.

``` shell
xcode-select --install
```

### Install compiler dependencies from Homebrew

``` shell
# Python build dependencies
brew install zlib
brew install xz
brew install openssl
brew install readline
brew install sqlite3
brew install openblas
```

*Side note: `openblas` isn't strictly required, but it comes in handy if you later want to install python-C libraries like [pandas] or [numpy].*

### Build a Python from Scratch

Now we have pyenv installed, we need to use it to create a python version for us. It does this by literally compiling the python source code to the special pyenv folder rather than any predistributed binaries or wheels etc.

However, the compilers don't necessarily always find the correct dependencies that we just installed so we have to manually point them to the right tools using compiler flags.

This is the step that was tricky, every time I tried a simple `pyenv install 3.9.1` it would only get so far and not compile. It turns out it's best to specify exactly where all the tools are to the compilers.

I found the easiest way to do this was to put it in a small bash script that I called `pyenv_install.sh`, shown in the snippet below. I would just recommend copying and pasting this, this is the exact script that works for me (macOS Big Sur, Intel chip).

Feel free to replace the `3.9.1` with whatever version of python you want (you should probably pick one of the currently supported ones though: 3.6, 3.7, 3.8 and 3.9 at time of writing). You can also run `pyenv install --list` to see all the many different versions of python you could install this way.

``` bash
#!/usr/bin/env bash

# Pointing pyenv to the correct compilers
export LDFLAGS="-L$(brew --prefix zlib)/lib -L$(brew --prefix bzip2)/lib -L$(brew --prefix openssl)/lib -L$(brew --prefix readline)/lib"
export CPPFLAGS="-I$(brew --prefix zlib)/include -I$(brew --prefix bzip2)/include"
export CFLAGS="-I$(brew --prefix openssl)/include -I$(brew --prefix bzip2)/include -I$(brew --prefix readline)/include -I$(xcrun --show-sdk-path)/usr/include"
pyenv install 3.9.1 # Or your version

echo "Don't forget to make this the global python using pyenv global x.x.x"
```

Pyenv will now build that version of python from source. Once it's finished, restart your terminal then run...

``` shell
pyenv global 3.9.1  # Or whatever version you installed
```

And that's it! You know have a python installation **completely** separate from your system python(s)! :tada:

### How to use it

I treat mine almost as if its the system installation, except with comfort in the knowledge that it's not and if all hell breaks loose I can always just `pyenv uninstall 3.9.1` and build it from scratch again.

The only thing I do with my global pyenv installation is install linting stuff and ensure things like `pip` and `setuptools` are always kept up to date. I actually do this with another bash function (keep scrolling...).

### Virtual Environments

I still recommend using virtual environments for basically everything:

``` shell
cd my_project

python -m venv .venv
# This now uses our magic pyenv version! we dont have to worry about saying python3.
```

So my pyenv global python acts as if it were my system one (but far safer) and all my projects have their own virtual environments. If you do this too, it is virtually impossible for you to mess up your python installation and you'll never end up understanding the xkcd comic, and that's a good thing! :thumbsup:.

***

#### Side Note: Bash Functions

By the way if you don't know the trick with bash functions:

* Create a file called `~/.my_commands.sh` (or whatever you want to call it actually, it doesn't matter) in your home directory.
  
* Add the following line in your `~/.zshrc` file:

``` bash
source ~/.my_commands.sh # Or whatever you called it
```

* Inside `.my_commands.sh` (or whatever you called it) write the functions you want in bash (e.g. my `maintenance` function below).

``` bash
# Inside ~/.my_commands.sh
#!/usr/bin/env bash


# Colours for nice terminal output
GREEN='\033[0;32m'
NC='\033[0m'
LBLUE='\033[1;34m'

# Update all the things!
function maintenance() {
    echo -e "${LBLUE}Updating and cleaning homebrew packages...\n${NC}"
    brew update
    brew upgrade
    brew cleanup -s
    echo -e "${LBLUE}Updating Global python3 core dependencies...\n${NC}"
    python -m pip install --quiet --upgrade pip setuptools wheel black mypy isort flake8
    echo -e "${GREEN}All done :)\n${NC}"
}
```

* Restart your terminal.

* And now boom :boom: you have a `maintenance` function you can just call like any other CLI tool from your terminal.

``` shell
maintenance

# Proceeds to do maintenance things...
```

You can write bash functions like this to do all sorts of cool stuff for you automatically!

> **Automation is power!**
>
> &mdash; <cite>*Someone smart... probably*</cite>

[Brett Cannon's Blog Post]: https://snarky.ca/deconstructing-xkcd-com-1987/
[pyenv]: https://github.com/pyenv/pyenv
[homebrew]: https://brew.sh
[pandas]: https://pandas.pydata.org
[numpy]: https://numpy.org
