# install-intelfortran-action

[![CI](https://github.com/modflowpy/install-intelfortran-action/actions/workflows/commit.yml/badge.svg?branch=develop)](https://github.com/modflowpy/install-intelfortran-action/actions/workflows/commit.yml)

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
  uses: modflowpy/install-intelfortran-action@v1
```

The action will configure [environment variables](https://www.intel.com/content/www/us/en/develop/documentation/oneapi-programming-guide/top/oneapi-development-environment-setup.html) necessary to invoke `ifort` from subsequent workflow steps. Environment variables are not preserved between steps by default &mdash; here they are persisted by [appending to the `GITHUB_ENV` environment file](https://docs.github.com/en/actions/using-workflows/workflow-commands-for-github-actions#setting-an-environment-variable).
