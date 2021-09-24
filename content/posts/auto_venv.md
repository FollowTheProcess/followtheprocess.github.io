---
author: "Tom Fleet"
title: "Automate your Virtual Environments... and everything else."
date: 2021-03-01T17:27:07Z
description: "Because why not?"
tags:
- python
- virtual environments
- automation
categories:
- "tips & tricks"
type: post
draft: false
---

We all know virtual environments are important! But they are a bit of a pain if you do them a lot...

```shell
# Make it
python -m venv .venv

# Activate it
source .venv/bin/activate

# Install/upgrade seeds
python -m pip install --upgrade pip setuptools wheel

# Install what you actually wanted
python -m pip install things i actually wanted

python -m pip install this needs to be automated
```

## Automation

I **LOVE** automating things and given that the commands we see above have to be typed *every time* you start a new project, this should scream automation to you!

There are two approaches that I want to point out here:

1) Easy, low-key, takes 5 mins
2) **AUTOMATE ALL THE THINGS**

I of course chose option 2, but we'll start with option 1 :wink:

## Option 1: The quick and easy

Like most things, 80% of the results can be achieved with 20% of the effort :thumbsup:

### Step 1: Create a file to hold all your custom stuff

You don't want to clutter up your `~/.zshrc` too much so it's best to keep this sort of thing separate. I used `.my_commands.sh` for mine but the name is up to you.

```shell
# Go home if you're not there already
cd $HOME

touch .my_commands.sh

# I use VSCode but any editor will do
code ~/.my_commands.sh
```

### Step 2: Write your function

Now in that file, we're going to make a function that you can call from any terminal session. This function will:

* Create a new virtual environment (if there isnt one already in the current directory)
* If there is one, it'll activate it for us

```bash
#!/usr/bin/env bash

function venv() {
    # First check if there already is a venv
    # If so just activate it

    if [[ -d .venv ]]; then

        echo "Activating venv..."
        source .venv/bin/activate
    else
        # Make a new one

        echo "Creating new venv..."
        python3 -m venv .venv
        # Clever recursive call so it now traverses the top branch
        venv
    fi
}
```

### Step 3: Source it in each shell

That's your function done, now we just need to do one more thing to make this available to every terminal session.

Open your `~/.zshrc` (or `~/.bashrc`, the syntax is the same) and type the following:

```bash
# ~/.zshrc

source ~/.my_commands.sh # Or whatever you named it
```

Save and close and you're done! That was easy wasn't it! :grin:

Now this `venv` command is available in every terminal session because your shell runs `~/.zshrc` every time it starts up. This is very handy and infinitely better than typing it out yourself.

This is fine, but it's a bit... plain. We can do better :smirk:

## Option 2: AUTOMATE ALL THE THINGS

If you're happy with what we did above or some of it was confusing and you're not quite sure what we did, then stop here. If you want automation at all costs, come with me!

Why don't we make a function that you can call from anywhere and does the following:

* Go to any project (even get it off GitHub first) and set up its virtual environment
* Set up VSCode to use the environment and open the project for you

This sounds a bit better, but more complicated... and it kind of is, but not too much!

### Find any project by name from anywhere on your computer

I'm assuming here that you keep all your development projects in one place.

The function we're going to write is going to be called `checkout` will take a single argument: the name of a project.

You'll use it like this:

```shell
checkout my_project
```

Now to the writing...

```bash
# Where you keep your projects
PROJECTS_DIR = $HOME/Development

# As in "check out" a project
# Not to be confused with git checkout
function checkout() {
    
    # Now we are in PROJECTS_DIR and can find anything we want
    cd PROJECTS_DIR

    if [[ -d $1 ]]; then

        echo "Project: '$1' found locally" # Helpful to say whats going on
        cd $1 # Go there
        venv # Call your venv function from before
        code . # Open the project in VSCode
    else
        echo "Uh oh, couldn't find '$1'"
    fi
}
```

This is already much better! You can call `checkout my_project` from anywhere in a terminal and it will find the right project, activate a virtual environment, then open up the project in VSCode, all from one command!

### What if the project is on GitHub?

Now we're cooking! Who wants to use their browser to go to the GitHub repo they want, copy the clone link, go back to the terminal, clone it... blah blah blah when you could just automate it! 

To do what we want, we're going to have to install some stuff to make our lives easier:

* [gh] - The official GitHub CLI. Get version >=1.7.0.

This can be installed with [homebrew].

```shell
brew install gh
```

Full disclosure: you don't actually *need* the GitHub CLI you could do this with `jq` and `cURL`, `gh` just makes it so easy, and I use it all the time anyway now it really is great!

What we're going to do with these new tools is:

1) Hit the GitHub API to see what repos you have
2) If we find a match to what you typed in to `checkout`, clone it
3) If not, then you don't have the project. So why not make one?

First you'll need to set up the GitHub CLI and authorise it but they've made this ridiculously easy I think you just fire it up for the first time and it guides you through the auth flow.

Now we can get automating...

```bash
# Where you keep your projects
PROJECTS_DIR = $HOME/Development

# As in "check out" a project
# Not to be confused with git checkout
function checkout() {
    
    # Now we are in PROJECTS_DIR and can find anything we want
    cd PROJECTS_DIR

    if [[ -d $1 ]]; then

        echo "Project: '$1' found locally" # Helpful to say whats going on
        cd $1 # Go there
        venv # Call your venv function from before
        code . # Open the project in VSCode
    
    # Now, instead of just giving up we will search GitHub
    elif gh repo list | grep -qFe $1; then

        echo "Project: '$1' found on GitHub. Cloning..."
        gh repo clone $1 # See, gh makes everything easy

        # Now it will exist locally, so just recurse
        checkout $1
    else
        # No project?
        # Let's make one
        mkdir $1
        touch $1/README.md # You can make whatever files you want here
        checkout $1
    fi
}
```

This is a bit more complicated so I'll walk through what's happening in our new `elif` block:

1) `gh repo list` does exactly what it says on the tin. It will list your (the authorised user's) repos and some info about them. We don't really care about the info for this use case, just the name.

2) `| grep -qFe $1` essentially just means "go through whatever is on the left of the pipe (`|`) and see if `$1` is in it. And don't forget, `$1` is the name of our project. The other flags like `-q`, `-F` and `-e` just tweak the behaviour of `grep`. So in our case, we're asking "In my list of repos, is there one called `my_project`?"

3) If the `grep` bit found a match, we use the GitHub CLI to easily clone it by name (easier than constructing the full clone URL).

4) Once cloned, the project exists locally so now our very top branch `if [[ -d $1 ]]` will now be true and it will do everything it would do if the project had always been local. Recursive calls like this are useful in bash functions because they avoid repetition.

5) Finally, instead of giving up here if we haven't found a project. Let's just make one and again, do the recursive call.

This is cool. But we can go one step further and automatically set up VSCode to use the environment.

### Automatically Set Up VSCode

If you're not familiar with how VSCode manages it's settings. The quick summary is you have two lots of settings:

* User settings - These are global and affect everything

* Workspace settings - Settings for a particular project

Both of these settings are stored under the hood as JSON files, which means we can access and manipulate them just like any normal text file! This is where [jq] comes in.

[jq] lets you pipe json through a query-like language filter. So for instance if we had a JSON file like this:

```json
{
    "name": "you",
    "age": 207,
    "occupation": "Door handle polisher"
}
```

You could do something like this to find your name...

```shell
cat that_file.json | jq '."name"'
```

See how that works? [jq] actually has really great [docs] and interactive sandbox to play with.

I think most people use the JSON view for the settings, but incase you've never seen them they look like this:

![VSCode Settings](/images/posts/vscode_settings_json.png)

And they live here: `.vscode/settings.json` inside your project.

The setting I'm interested in here is:

`python.pythonPath`: This controls which verion of the python executable will be used to run your stuff, i.e. this is how we can tell VSCode to use our virtual environment automatically

#### Setting python.pythonPath

Okay so now we know where these settings are kept, what to do? :thinking:

This is our function so far:

```bash
# Where you keep your projects
PROJECTS_DIR = $HOME/Development

# As in "check out" a project
# Not to be confused with git checkout
function checkout() {
    
    # Now we are in PROJECTS_DIR and can find anything we want
    cd PROJECTS_DIR

    if [[ -d $1 ]]; then

        echo "Project: '$1' found locally" # Helpful to say whats going on
        cd $1 # Go there
        venv # Call your venv function from before
        code . # Open the project in VSCode
    
    # Now, instead of just giving up we will search GitHub
    elif gh repo list | grep -qFe $1; then

        echo "Project: '$1' found on GitHub. Cloning..."
        gh repo clone $1 # See, gh makes everything easy

        # Now it will exist locally, so just recurse
        checkout $1
    else
        # No project?
        # Let's make one
        mkdir $1
        touch $1/README.md # You can make whatever files you want here
        checkout $1
    fi
}
```

What we want to do is after creating the virtual environment, automatically make VSCode use it. To that end...

```bash

function code_set_venv() {

    if [[ -f .vscode/settings.json ]]; then

        echo "Ensuring VSCode is using the correct virtualenv..."
        # Current set value for pythonPath. 'null' if empty or doesn't exist
        ppath="$(cat .vscode/settings.json | jq '."python.pythonPath"')"

        if [[ $ppath != null ]]; then
            # pythonPath is already set
            echo "python.pythonPath already set in workspace settings. Not overwriting."
        else
            ppath_set="$(jq '."python.pythonPath" = ".venv/bin/python"' .vscode/settings.json)"

            echo $ppath_set >.vscode/settings.json

        fi
    
    else
        # No vscode settings currently
        # Make the settings.json and make recursive call to end up in first if branch
        mkdir -p .vscode
        # Create empty JSON for jq to work
        echo "{}" >.vscode/settings.json
        # Recursive call
        code_set_venv
    fi
}
```

This one:

* First asks if there are already VSCode workspace settings: `if [[ -f .vscode/settings.json ]]`
  
* If there are it looks at what is currently set for `python.pythonPath`. The assumption being that if someone already set it explicitly, we should probably leave it alone.
  
* If it's empty or not set at all (represented in JSON by `null`) then we can do what we like! i.e. set it to our virtualenv's python. This bit is done by the `ppath_set` line.

* If there is no workspace settings file yet, we create one, dump a placeholder set of brackets (needed so `jq` knows it's valid JSON) and then just call the function again! Now the settings exist, it will traverse the top branch.

Now we just need to weave this into our main `checkout` function in the right place:

```bash
# Where you keep your projects
PROJECTS_DIR = $HOME/Development

# As in "check out" a project
# Not to be confused with git checkout
function checkout() {
    
    # Now we are in PROJECTS_DIR and can find anything we want
    cd PROJECTS_DIR

    if [[ -d $1 ]]; then

        echo "Project: '$1' found locally" # Helpful to say whats going on
        cd $1
        venv
        code_set_venv # Here is a good place
        code . 
    
    # Now, instead of just giving up we will search GitHub
    elif gh repo list | grep -qFe $1; then

        echo "Project: '$1' found on GitHub. Cloning..."
        gh repo clone $1 # See, gh makes everything easy

        # Now it will exist locally, so just recurse
        checkout $1
    else
        # No project?
        # Let's make one
        mkdir $1
        touch $1/README.md # You can make whatever files you want here
        checkout $1
    fi
}
```

And that's it! Now when we call `checkout`, we'll end up with VSCode open in the root of our project, whether or not we had it on our computer in the first place, and VSCode will be set up to use the right environment!

You can even inject stuff like installing from `requirements.txt` or whatever you want so you can just get to codingTM :grin:

[jq]: https://stedolan.github.io/jq/
[gh]: https://cli.github.com
[homebrew]: https://brew.sh
[docs]: https://stedolan.github.io/jq/
