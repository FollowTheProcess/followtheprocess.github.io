+++
author = "Tom Fleet"
title = "goignore"
date = "2021-03-23"
description = "Tiny go CLI to hit the gitignore.io API and generate a .gitignore file."
tags = [
    "go",
    "automation",
    "cli"
]
draft = false
type = "page"
+++

*An extremely simple go CLI to hit the [gitignore API] with whatever you pass as command line arguments. The list of things you can pass here are documented on [gitignore.io].*

* **Source Code**: [https://github.com/FollowTheProcess/goignore](https://github.com/FollowTheProcess/goignore/)

You'll get back a .gitignore file saved to `$CWD/.gitignore` with the contents generated from the API.

## Installation

```shell
go install github.com/FollowTheProcess/goignore@latest
```

## Usage

Inside the folder you want the `.gitignore` to live in, run:

```shell
goignore macos visualstudiocode go
```

This will get you a `.gitignore` file that looks like...

```plaintext
# Created by https://www.toptal.com/developers/gitignore/api/macos,vscode,go
# Edit at https://www.toptal.com/developers/gitignore?templates=macos,vscode,go

### Go ###
# Binaries for programs and plugins
*.exe
*.exe~
*.dll
*.so
*.dylib

# Test binary, built with `go test -c`
*.test

# Output of the go coverage tool, specifically when used with LiteIDE
*.out

# Dependency directories (remove the comment below to include it)
# vendor/

### Go Patch ###
/vendor/
/Godeps/

### macOS ###
# General
.DS_Store
.AppleDouble
.LSOverride

# Icon must end with two \r
Icon


# Thumbnails
._*

# Files that might appear in the root of a volume
.DocumentRevisions-V100
.fseventsd
.Spotlight-V100
.TemporaryItems
.Trashes
.VolumeIcon.icns
.com.apple.timemachine.donotpresent

# Directories potentially created on remote AFP share
.AppleDB
.AppleDesktop
Network Trash Folder
Temporary Items
.apdisk

### vscode ###
.vscode/*
!.vscode/settings.json
!.vscode/tasks.json
!.vscode/launch.json
!.vscode/extensions.json
*.code-workspace

# End of https://www.toptal.com/developers/gitignore/api/macos,vscode,go
```

## List Options

If you're not sure what you can type in, run:

```shell
goignore --list
```

And you'll see something like...

```shell
1c,1c-bitrix,a-frame,actionscript,ada
adobe,advancedinstaller,adventuregamestudio,agda,al
alteraquartusii,altium,amplify,android,androidstudio
angular,anjuta,ansible,apachecordova,apachehadoop
appbuilder,appceleratortitanium,appcode,appcode+all,appcode+iml

# etc.
```

If you have a particular thing in mind:

```shell
goignore --list list | grep visualstudiocode

virtuoso,visualstudio,visualstudiocode,vivado,vlab
```

## Tech Notes

I've been learning Go and working through [Learn Go with Tests] and I really like it! This is the first thing I've ever written in Go, its pretty simple as programs go but it was tricky stitching this together in a new language. Although go actually makes this sort of thing super easy, the go standard library is really incredible.

The best part coming from python though is no worrying about versions, virtual environments or anything like that. Just run `go install` and you have a binary application ready to run in your `$PATH` just like that!

[gitignore API]: https://www.toptal.com/developers/gitignore
[gitignore.io]: https://www.toptal.com/developers/gitignore
[Learn Go with Tests]: https://quii.gitbook.io/learn-go-with-tests/
