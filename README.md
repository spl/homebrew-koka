# Homebrew Formulae for Koka and Madoko

This repository contains [Homebrew] formulae for the following:

* [Koka] is a function-oriented strongly-typed language that separates pure
  values from side-effecting computations.
* [Madoko] is a markdown processor for academic documents that produces PDF and
  HTML.

[Homebrew]: https://brew.sh/
[Koka]: https://github.com/koka-lang/koka
[Madoko]: https://www.madoko.net/

The reason for the existence of this [Homebrew tap] is to make it easier to
install Koka and, especially, Madoko, which is built with Koka. The current
release of Madoko is very old, and building it from source is not easy and
requires an old version of Koka.

[Homebrew tap]: https://docs.brew.sh/Taps

## Installation and running

### Koka

#### Current

This is the HEAD revision as of the time of writing. This is not a released
version because there have been no releases since v0.7.1.

```
$ brew install spl/koka/koka
$ koka
```

#### v0.7.1

This is the last release on GitHub.

```
$ brew install spl/koka/koka@0.7.1
$ koka-0.7.1
```

#### v0.6.0-dev

This version is required to build Madoko.

```
$ brew install spl/koka/koka@0.6.0-dev
$ koka-0.6.0-dev
```

### Madoko

This is the HEAD revision as of the time of writing. The last release, which is
very old, is available with `npm install -g madoko`.

Note: Madoko is built with `koka-0.6.0-dev`. Installing the `madoko` formula
will also install the `koka@0.6.0-dev` formula.

Note: Building Madoko may consume a large amount of memory. On my system with 16
GB of RAM, it took upwards of 18.3 GB. See [koka-lang/madoko#10] for discussion
of this issue.

[koka-lang/madoko#10]: https://github.com/koka-lang/madoko/issues/10

```
$ brew install spl/koka/madoko
$ madoko
```
