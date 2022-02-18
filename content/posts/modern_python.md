---
author: "Tom Fleet"
title: "What exactly is 'Modern Python'?"
date: 2022-02-17T17:31:45Z
description: "You may have heard people talking about 'Modern Python' but what really is it?"
tags:
- "python"
draft: true
type: post
---

Python is going through a huge modernisation kick in recent years with things like [PEP 484 Type Hints], [performance improvements] coming in 3.11 and now being able to run on [web assembly], moving away from the hangover of python 2 and fully embracing the new style of "modern" python 3.

The python sphere is full of posts, packages and repos claiming to use or take advantage of "modern python"

So you may be asking... what exactly do people mean when they say "modern python"? Hopefully, by the end of this, you won't need to ask!

## Type Hints

Let's start with my favourite bit... type hints!

[PEP 484] introduced type hints to the language. A system where the programmer can provide the types of function arguments, variables, class variables etc. almost like you would in a statically typed language. You know, the things you see that look like this...

```python
def count(things: list[str]) -> int:
    """
    Counts the number of things in a list of things.
    """
    return len(things)
```

Now [PEP 484] itself is pretty old now, type hints have been around a while. However, what I think makes them part of this new "modern python" is the fact that libraries have been jumping on them and using them in novel ways!

Type hints are exactly that... a hint. They do **absolutely nothing** at runtime. But some libraries like [FastAPI], [Pydantic] and others have been using these annotations at runtime to serialise, deserialise and validate data.

You can also use type checkers such as [mypy] to effectively act as a sort of "compiler" for python that will parse all these hints and statically determine if your code is type safe. In fact with things like [mypyc], you can even compile your python code to C using these type annotations, [mypy] has been compiled with [mypyc] as has [black], resulting in 2 - 4x speed improvements!

However, this isn't why I count type hints as part of "modern python". I count them in the list because of the change they make to the experience of *writing* python!

They make it so. much. better.

It's gotten to the point now where I can't really even write non-typed python anymore and I genuinely view non-typed python as a code smell.

Consider the following example from VSCode:

![no_types](/images/posts/modern_python/no_types.png)

See how it gives you absolutely no help whatsoever? What is a `thing`? The argument `things` seems to suggest some collection of type `thing`. Is it a list? a set? a dictionary? Who knows!

And if we try and call a method on it, we need to know what it is and then google the methods on that type! Madness, it's 2022.

Luckily we can fix all that with the application of a simple type hint:

![types](/images/posts/modern_python/types.png)

And just like that all is well with the world again, we know exactly that our `things` is a list of strings and we have instant access to all the methods that can be applied to a list.

Even better than that, because its a list **of strings**, we get even more help:

![inner_types](/images/posts/modern_python/inner_types.png)

Look! It knows the things inside our list are strings!

I know python is a dynamically typed language and the purists will be very angry with me for saying this but honestly, there is very little excuse for non-typed python these days. It's a no brainer for me :brain:

[PEP 484 Type Hints]: https://www.python.org/dev/peps/pep-0484/
[PEP 484]: https://www.python.org/dev/peps/pep-0484/
[performance improvements]: https://github.com/markshannon/faster-cpython/blob/master/plan.md
[web assembly]: https://twitter.com/ethanhs/status/1464308141105967104
[FastAPI]: https://github.com/tiangolo/fastapi
[Pydantic]: https://github.com/samuelcolvin/pydantic
[mypy]: https://github.com/python/mypy
[mypyc]: https://github.com/mypyc/mypyc
[black]: https://github.com/psf/black
