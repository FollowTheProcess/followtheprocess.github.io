"""
Invoke build tasks for local development.

Author: Tom Fleet
Created: 18/02/2021
"""

from invoke import task


@task
def build(c):
    """
    Builds the site contents to ./public with hugo.
    """

    c.run("hugo")


@task(build)
def serve(c, draft=False):
    """
    Builds and serves site content, enforcing full reload on changes.
    """
    if draft:
        c.run("hugo server --disableFastRender -D")
    else:
        c.run("hugo server --disableFastRender")
