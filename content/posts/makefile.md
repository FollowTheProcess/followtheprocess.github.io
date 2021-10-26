---
author: "Tom Fleet"
title: "Self Documenting Makefile"
date: 2021-10-26T22:05:11+01:00
description: "Auto document your Makefile with pretty colours!"
tags:
- "tips"
- "automation"
draft: false
type: post
---

If you aren't familiar with [make], it's a command runner and build system capable of quite complicated stuff. It's syntax can get complicated for non-trivial workflows and it has lots of weird quirks (like `.PHONY`).

However, it's ubiquitous on nearly all systems and pretty easy to get going with so it's very widely used in all sorts of projects in just about every language.

In fact, a filename global search on GitHub yields an astonishing 112 million results!

![makefile_search](/images/posts/makefile/makefile_search.png)

Despite this, most Makefiles I've come across in the wild have been poorly documented and not very user friendly! We can fix this with a bit of shell trickery 😉

So here it is, the self-documenting Makefile:

```makefile
.DEFAULT_GOAL := help
.PHONY: help start build clean colors
SHELL=/usr/bin/env zsh

# Define standard colors
ifneq (,$(findstring xterm,${TERM}))
    BLACK        := $(shell tput -Txterm setaf 0)
    RED          := $(shell tput -Txterm setaf 1)
    GREEN        := $(shell tput -Txterm setaf 2)
    YELLOW       := $(shell tput -Txterm setaf 3)
    LIGHTPURPLE  := $(shell tput -Txterm setaf 4)
    PURPLE       := $(shell tput -Txterm setaf 5)
    BLUE         := $(shell tput -Txterm setaf 6)
    WHITE        := $(shell tput -Txterm setaf 7)
    RESET    := $(shell tput -Txterm sgr0)
else
    BLACK        := ""
    RED          := ""
    GREEN        := ""
    YELLOW       := ""
    LIGHTPURPLE  := ""
    PURPLE       := ""
    BLUE         := ""
    WHITE        := ""
    RESET        := ""
endif

# Set target color
TARGET_COLOR := $(BLUE)

colors: ## Show all the colors
    @echo "${BLACK}BLACK${RESET}"
    @echo "${RED}RED${RESET}"
    @echo "${GREEN}GREEN${RESET}"
    @echo "${YELLOW}YELLOW${RESET}"
    @echo "${LIGHTPURPLE}LIGHTPURPLE${RESET}"
    @echo "${PURPLE}PURPLE${RESET}"
    @echo "${BLUE}BLUE${RESET}"
    @echo "${WHITE}WHITE${RESET}"

help: ## Show the list of available tasks
    @echo "${GREEN}Available Tasks: ${RESET}"
    @echo "${WHITE}-----------------------------------------------------------------${RESET}\n"
    @grep -E '^[a-zA-Z_0-9%-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "${TARGET_COLOR}%-10s${RESET} %s\n", $$1, $$2}'


build: ## Build some things
    @echo "building"

start: ## Start some service
    docker compose up

clean: ## Remove unused clutter
    rm -rf ./cache
```

And now because we set `.DEFAULT_GOAL` to `help`, when we run `make` we get a very pretty help message!

![make_help](/images/posts/makefile/make_help.png)

[make]: https://www.gnu.org/software/make/
