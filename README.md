# Homebrew Formulae for Koka and Madoko

This repository contains [Homebrew] formulae for the following:

* [Koka] is a function-oriented strongly-typed language that separates pure
  values from side-effecting computations.
* [Madoko] is a markdown processor for academic documents that produces PDF and
  HTML.

[Homebrew]: https://brew.sh/
[Koka]: https://github.com/koka-lang/koka
[Madoko]: https://www.madoko.net/

## Installation and running

### Koka

#### v0.6.0-dev

```
$ brew install spl/koka/koka@0.6.0-dev
$ koka-0.6.0-dev
```

#### v0.7.1

```
$ brew install spl/koka/koka@0.7.1
$ koka-0.7.1
```

### Madoko

Note that Madoko is built with `koka-0.6.0-dev`. Installing the `madoko` formula
will also install the `koka@0.6.0-dev` formula.

```
$ brew install spl/koka/madoko
$ madoko
```
