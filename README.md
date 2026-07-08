### Inspired by

- [balsoft](https://github.com/balsoft/nixos-config)
- [shlypa](https://github.com/ilya-fedin/nixos-configuration)
- [cab404](https://github.com/cab404/home)
- [kanashimia](https://github.com/kanashimia/nixos-config)

### Install

```sh
sh <(curl -L https://github.com/name-snrl/nixos-configuration/raw/master/install) <configuration-name>
```

### Design Principles

This repository is built around a few simple principles and ideas from Nixpkgs:

- [KISS](https://en.wikipedia.org/wiki/KISS_principle), which means:
  - no frameworks with complex abstractions, like
    [std](https://github.com/divnix/std), [den](https://github.com/denful/den),
    etc
  - no custom library
  - no complex nix code
  - no unnecessary glue code (e.g. modules for roles, types, etc. whose only
    purpose is to create a single option that enables multiple others)
- the capabilities of the
  [Nixpkgs module system](https://nixos.org/manual/nixpkgs/unstable/#module-system)
  are sufficient
- splitting the configuration into
  [profiles](https://nixos.org/manual/nixos/unstable/#ch-profiles) with a proper
  file structure is all that is needed to build configurations with different
  roles, types, etc
- profiles are separated by type: nixos, home-manager, nix-darwin, etc
- each configuration has a single entry point that explicitly lists all imports,
  making it easy to understand at a glance

These principles are implemented using only the standard nixpkgs library and
[flake-parts](https://github.com/hercules-ci/flake-parts):

- `lib.fileset` for managing configuration imports
- `flake-parts` brings the nixpkgs module system to flake. This makes it
  possible to:
  - split `flake.nix` into modules
  - use third-party modules such as
    [treefmt-nix](https://github.com/numtide/treefmt-nix)
  - build abstractions with higher-level options for defining complex flake
    outputs

### Features

TODO
