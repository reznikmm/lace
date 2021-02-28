Lace
====

[![Build](https://github.com/reznikmm/lace/workflows/Build/badge.svg)](https://github.com/reznikmm/lace/actions)
[![REUSE status](https://api.reuse.software/badge/github.com/reznikmm/lace)](https://api.reuse.software/info/github.com/reznikmm/lace)

> An Ada to LLVM translator

NOTE: Nothing works yet! 🚫

## Install

Run
```
make all install PREFIX=/path/to/install
```

### Dependencies
It depends on
* [Matreshka](https://forge.ada-ru.org/matreshka) library
* [gela](https://github.com/reznikmm/gela) - Ada code analyzer

## Usage

To run with

    .objs/lace-run

To use this as aa library just add `with "lace";` to your project file.

## Maintainer

[Max Reznik](https://github.com/reznikmm).

## Contribute

Feel free to dive in!
[Open an issue](https://github.com/reznikmm/lace/issues/new)
or submit PRs.

## License

[MIT](LICENSE) © Maxim Reznik

