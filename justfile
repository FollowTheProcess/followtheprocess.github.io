# By default print the list of recipes
_default:
    @just --list

# Build the site
build:
    hugo

# Build and serve locally
serve:
    hugo server --disableFastRender -D
