# install-intelfortran-action

[![CI](https://github.com/modflowpy/install-intelfortran-action/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/modflowpy/install-intelfortran-action/actions/workflows/ci.yml)

An action to install the [Intel OneAPI](https://www.intel.com/content/www/us/en/developer/tools/oneapi/fortran-compiler.html#gs.bksc2p) Fortran compiler.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [Install location](#install-location)
  - [Linux & Mac](#linux--mac)
  - [Windows](#windows)
- [Usage](#usage)
- [Attribution](#attribution)

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

The action will configure [environment variables](https://www.intel.com/content/www/us/en/develop/documentation/oneapi-programming-guide/top/oneapi-development-environment-setup.html) necessary to invoke `ifort` from subsequent workflow steps. GitHub Actions does not preserve environment variables between steps by default &mdash; this action persists them by [appending to the `GITHUB_ENV` environment file](https://docs.github.com/en/actions/using-workflows/workflow-commands-for-github-actions#setting-an-environment-variable).

**Note:** Micromamba environments can modify the system path on Windows runners and cause the default `link.exe` (located at `C:\Program Files\Git\usr\bin`) to be found instead of the [MSVC linker](https://docs.microsoft.com/en-us/cpp/build/reference/linking?view=msvc-170) required by `ifort`. To prevent this, prepend the MSVC linker's bin directory to the path. For instance, from `bash`:

```shell
export PATH="/C/Program Files/Microsoft Visual Studio/2022/Enterprise/VC/Tools/MSVC/14.33.31629/bin/Hostx64/x64":$PATH
```

Or from a `cmd` shell:

```
set "PATH=C:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Tools\MSVC\14.33.31629\bin\Hostx64\x64;%PATH%"
```

## Attribution

This action is based on examples in the [OneApi repository](https://github.com/oneapi-src/oneapi-ci), which is copyrighted to Intel and distributed under the MIT license:

```
SPDX-FileCopyrightText: 2020 Intel Corporation
SPDX-License-Identifier: MIT
```
