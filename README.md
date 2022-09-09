# install-intelfortran-action

[![CI](https://github.com/modflowpy/install-intelfortran-action/actions/workflows/commit.yml/badge.svg?branch=develop)](https://github.com/modflowpy/install-intelfortran-action/actions/workflows/commit.yml)
![Status](https://img.shields.io/badge/-under%20development-yellow?style=flat-square)

An action to install the [Intel OneAPI](https://www.intel.com/content/www/us/en/developer/tools/oneapi/fortran-compiler.html#gs.bksc2p) Fortran compiler.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Install location](#install-location)
  - [Linux & Mac](#linux--mac)
  - [Windows](#windows)
- [Usage](#usage)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Install location

### Linux & Mac

On Linux and MacOS, the compiler is installed to `/opt/intel/oneapi`.

### Windows

On Windows the install location is `C:\Program Files (x86)\Intel\oneAPI`.

## Usage

To use this action, add a step like the following to your workflow:

```yaml
- name: Install Intel Fortran
  uses: modflowpy/install-intelfortran-action@v0.0.1
```

Environment variables must be set before the compiler can be used. On Linux or MacOS runners, run `source /opt/intel/oneapi/setvars.sh`. On Windows, run `call "scripts/install/build_windows.bat"` from a step with `shell: cmd`.

**Note:** Environment variables are not preserved between steps, so the above must occur in the same step in which the `ifort` command is used.
