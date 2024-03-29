# By default print the list of recipes
_default:
    @just --list

# Build the site
build:
    hugo -D

# Build and serve locally
serve: build
    open "http://localhost:1313/"
    hugo server --disableFastRender -D

# Create a new post
post title:
    hugo new -k post content/posts/{{ title }}.md

# Create a new project
project title:
    hugo new -k project content/projects/{{ title }}.md

# Spellcheck
check:
    codespell ./content -L ines,sur
