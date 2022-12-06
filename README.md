# install-intelfortran-action

[![CI](https://github.com/modflowpy/install-intelfortran-action/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/modflowpy/install-intelfortran-action/actions/workflows/ci.yml)
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)

An action to install and cache the [Intel OneAPI](https://www.intel.com/content/www/us/en/developer/tools/oneapi/fortran-compiler.html#gs.bksc2p) Fortran and C/C++ classic compilers via the [HPC Toolkit](https://www.intel.com/content/www/us/en/developer/tools/oneapi/hpc-toolkit.html#gs.g10hgy).

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Overview](#overview)
- [Usage](#usage)
- [Inputs](#inputs)
  - [`path`](#path)
- [Environment variables](#environment-variables)
- [Windows caveats](#windows-caveats)
  - [Bash & MSVC](#bash--msvc)
  - [Install location](#install-location)
  - [Conda `Scripts`](#conda-scripts)
- [License](#license)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Overview

This action installs the [Intel OneAPI](https://www.intel.com/content/www/us/en/developer/tools/oneapi/fortran-compiler.html#gs.bksc2p) Fortran and C/C++ classic compilers via the [HPC Toolkit](https://www.intel.com/content/www/us/en/developer/tools/oneapi/hpc-toolkit.html#gs.g10hgy) offline installer. After installation, the action configures [environment variables](https://www.intel.com/content/www/us/en/develop/documentation/oneapi-programming-guide/top/oneapi-development-environment-setup.html) necessary to invoke the compilers from subsequent workflow steps.

## Usage

To use this action, add a step like the following to your workflow:

```yaml
- name: Setup Intel Fortran
  uses: modflowpy/install-intelfortran-action@v1
```

## Inputs

- `path`

### `path`

The `path` input is the location to install executables. The path may be absolute, relative to the workflow's working directory, or may use `~`-expansion. The path is resolved and stored in the `INTEL_HPCKIT_INSTALL_PATH` environment variable, which is then available to subsequent workflow steps.

The default install location on Linux and Mac is `~/.local/bin/ifort`. The *only* install location currently supported on Windows is `C:\Program Files (x86)\Intel\oneAPI` (see [Windows caveats](#windows-caveats) below).

<!-- ### `version`

The `version` input configures the oneAPI toolkit version to install, defaulting to the latest (currently `2022.3`). 

**Note:** Intel's website does not maintain a programmatically accessible registry of available versions. Moreover, toolkit versioning is distinct from compiler versioning (see [this page] for a mapping between toolkit and compiler versions). For these reasons a list of permitted version numbers are hard-coded into this action. If a new version has been released and this action has not been updated to support it, please feel free to [file an issue](https://github.com/modflowpy/install-intelfortran-action/issues/new).

### `components`

The `components` input allows specifying extra components to install from the HPC kit. -->

## Environment variables

The action runs oneAPI configuration scripts (e.g. `setvars.sh`), which set a number of environment variables, the names of which share substring `ONEAPI`.

A few additional variables are also set:

- `INTEL_HPCKIT_INSTALL_PATH` points to the top-level install path
- `INTEL_HPCKIT_INSTALLER_URL` is the URL of the installer used
- `INTEL_HPCKIT_COMPONENTS` is a `:`-delimited list of compiler components installed (e.g. `intel.oneapi.win.cpp-compiler:intel.oneapi.win.ifort-compiler` for Windows)
- `INTEL_COMPILER_BIN_PATH` is the location of compiler executables (this is equivalent to `$HPCKIT_INSTALL_PATH/compilers/latest/<mac, linux, or windows>/bin/intel64`, substituting the proper OS)
- `INTEL_HPCKIT_VERSION` is the oneAPI HPC toolkit version number used (currently `2022.3`)
- `FC` is set to `ifort`
- `CC` is set to `icc` on Linux and macOS and `icl` on Windows

**Note:** GitHub Actions does not preserve environment variables between steps by default &mdash; this action persists them via the [`GITHUB_ENV` environment file](https://docs.github.com/en/actions/using-workflows/workflow-commands-for-github-actions#setting-an-environment-variable).

## Windows caveats

There are a few things to be aware of when using this action on Windows runners.

### Bash & MSVC

This action uses [`ilammy/msvc-dev-cmd`](https://github.com/ilammy/msvc-dev-cmd) internally to configure the MSVC toolchain. Unfortunately, GitHub Actions automatically prepends GNU bin paths to the system path before running `bash` shell steps. This causes the GNU linker to be found even if the MSVC bin directory is on the path (more info [here](https://github.com/ilammy/msvc-dev-cmd#name-conflicts-with-shell-bash)). To make sure the MSVC toolchain is selected in `bash` steps on Windows, this action hides the GNU linker, moving it from `/usr/bin/link` to `$RUNNER_TEMP/link`.

### Install location

While the HPC toolkit's install location can be selected freely on Linux and Mac, on Windows there is an unresolved issue causing bundled environment configuration scripts [to fail](https://github.com/w-bonelli/install-intelfortran-action/actions/runs/3298296907/jobs/5440222932#step:5:120) when the toolkit is installed to locations other than the default `C:\Program Files (x86)\Intel\oneAPI`. Different values for the `path` input are currently ignored for Windows and this location is configured automatically.

<!-- The Intel oneAPI HPC Toolkit installer defaults to different install locations on Unix and Windows if a path is not explicitly provided with the `--install-dir` option:

- Linux/Mac: `/opt/intel/oneapi`
- Windows: `C:\Program Files (x86)\Intel\oneAPI`

**This action overrides these.** The action's default install location, `~/.local/bin/ifort`, is the same on all three platforms. -->

### Conda `Scripts`

On Windows, this action can stomp on system path configurations set up by `mamba-org/provision-with-micromamba`, causing programs in `<micromamba root>\envs\<your environment name>\Scripts` not to be found when `shell: pwsh` is used. The recommended pattern to avoid this is:

1) use `mamba-org/provision-with-micromamba@main`
2) use `modflowpy/install-intelfortran-action@v1`
3) add a step like the following before any steps expecting to use the Micromamba environment (implemented in Powershell below, but need not be):

```pwsh
# update the path with your environment name
$path = "C:\Users\runneradmin\micromamba-root\envs\<env name>\Scripts"
echo $path | Out-File -FilePath $env:GITHUB_PATH -Encoding utf8 -Append
```

## License

This action is based on examples in the [oneAPI CI samples repository](https://github.com/oneapi-src/oneapi-ci), which are subject to the [oneAPI End User License Agreement](https://www.intel.com/content/www/us/en/developer/articles/license/end-user-license-agreement.html), copyrighted to Intel, and distributed under the MIT license:

```
SPDX-FileCopyrightText: 2020 Intel Corporation
SPDX-License-Identifier: MIT
```
