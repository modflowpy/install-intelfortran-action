# install-intelfortran-action

[![GitHub tag](https://img.shields.io/github/tag/modflowpy/install-intelfortran-action.svg)](https://github.com/modflowpy/install-intelfortran-action/tags/latest)
[![CI](https://github.com/modflowpy/install-intelfortran-action/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/modflowpy/install-intelfortran-action/actions/workflows/ci.yml)
[![Project Status: Inactive – The project has reached a stable, usable state but is no longer being actively developed; support/maintenance will be provided as time allows.](https://www.repostatus.org/badges/latest/inactive.svg)](https://www.repostatus.org/#inactive)

An action to install and cache [Intel OneAPI](https://www.intel.com/content/www/us/en/developer/tools/oneapi/fortran-compiler.html#gs.bksc2p) Fortran and C/C++ compilers via the [HPC Toolkit](https://www.intel.com/content/www/us/en/developer/tools/oneapi/hpc-toolkit.html#gs.g10hgy).

**Note:** Maintenance of this action will cease in 2024. [`fortran-lang/setup-fortran`](https://github.com/fortran-lang/setup-fortran) is recommended instead. This action will disable itself 10% of the time until then (to avoid this, use a previous tag).

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [Overview](#overview)
- [Usage](#usage)
- [Environment variables](#environment-variables)
- [Inputs](#inputs)
  - [`path`](#path)
  - [`setvars`](#setvars)
    - [Setting oneAPI variables on Linux/macOS](#setting-oneapi-variables-on-linuxmacos)
    - [Setting oneAPI variables on Windows](#setting-oneapi-variables-on-windows)
  - [`cache`](#cache)
  - [`ignore`](#ignore)
- [Outputs](#outputs)
  - [`cache-hit`](#cache-hit)
- [Windows caveats](#windows-caveats)
  - [Bash & MSVC](#bash--msvc)
  - [Visual Studio](#visual-studio)
  - [Install location](#install-location)
  - [Conda `Scripts`](#conda-scripts)
- [License](#license)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Overview

This action installs [Intel OneAPI](https://www.intel.com/content/www/us/en/developer/tools/oneapi/fortran-compiler.html#gs.bksc2p) Fortran and C/C++ compilers via the [HPC Toolkit](https://www.intel.com/content/www/us/en/developer/tools/oneapi/hpc-toolkit.html#gs.g10hgy) offline installer. After installation, the action can optionally configure [environment variables](https://www.intel.com/content/www/us/en/develop/documentation/oneapi-programming-guide/top/oneapi-development-environment-setup.html) necessary to invoke the compilers from subsequent workflow steps.

## Usage

To use this action, add a step like the following to your workflow:

```yaml
- name: Setup Intel Fortran
  uses: modflowpy/install-intelfortran-action@v1
```

By default, this action runs oneAPI `setvars` scripts to configure the environment for use. If you would rather run the oneAPI environment configuration scripts yourself, set the `setvars` input to `false`.

## Environment variables

Besides oneAPI environment variables configured by `setvars` scripts (whose names share substring `ONEAPI`), this action sets some additional variables:

- `INTEL_HPCKIT_INSTALL_PATH` points to the top-level install path
- `INTEL_HPCKIT_INSTALLER_URL` is the URL of the installer used
- `INTEL_HPCKIT_COMPONENTS` is a `:`-delimited list of compiler components installed (e.g. `intel.oneapi.win.cpp-compiler:intel.oneapi.win.ifort-compiler` for Windows)
- `INTEL_HPCKIT_VERSION` is the oneAPI HPC toolkit version number used (currently `2022.3`)
- `INTEL_COMPILER_BIN_PATH` is the location of compiler executables (this is equivalent to `$HPCKIT_INSTALL_PATH/compilers/latest/<mac, linux, or windows>/bin/intel64`, substituting the proper OS)
- `INTEL_COMPILER_VERSION` is the version of the installed compilers (this may be different than the version of the oneAPI HPC Toolkit)
- `FC` is set to `ifort`
- `CC` is set to `icc` on Linux and macOS and `icl` on Windows
- `SETVARS_COMPLETED` indicates whether oneAPI environment variables have been configured (will be `1` if input `setvars` is `true` and variables were successfully configured, otherwise `0`)

**Note:** GitHub Actions does not preserve environment variables between steps by default &mdash; this action persists them via the [`GITHUB_ENV` environment file](https://docs.github.com/en/actions/using-workflows/workflow-commands-for-github-actions#setting-an-environment-variable).

## Inputs

- `path`
- `setvars`
- `cache`

### `path`

The `path` input is the location to install executables. The path may be absolute, relative to the workflow's working directory, or may use `~`-expansion. The path is resolved and stored in the `INTEL_HPCKIT_INSTALL_PATH` environment variable, which is then available to subsequent workflow steps.

The default install location on Linux and Mac is `~/.local/bin/ifort`. The *only* install location currently supported on Windows is `C:\Program Files (x86)\Intel\oneAPI` (see [Windows caveats](#windows-caveats) below).

### `setvars`

The `setvars` input is a boolean that controls whether the action runs the oneAPI `setvars` scripts to configure the environment for use. The default is `true`.

If you prefer to run the oneAPI environment configuration scripts manually, set the `setvars` input to `false`. Then, you can run the `setvars` scripts in a subsequent step.

**Note:** if you elect to activate the oneAPI environment manually, you must either do so in the same step as your compiler invocation, or use the `GITHUB_ENV` environment file to persist the environment variables between steps.

#### Setting oneAPI variables on Linux/macOS

On Linux and macOS it is sufficient to source `setvars.sh`, using the `INTEL_HPCKIT_INSTALL_PATH` environment variable to locate it:

```shell
source "$INTEL_HPCKIT_INSTALL_PATH/setvars.sh"
```

#### Setting oneAPI variables on Windows

On Windows, the `vars.bat` script inside the compiler install directory should be used to activate the oneAPI environment. The compiler install directory can be located with the `INTEL_COMPILER_VERSION` variable. For instance, from a `cmd` shell:

```cmd
call "%INTEL_HPCKIT_INSTALL_PATH%\compiler\%INTEL_COMPILER_VERSION%\env\vars.bat"
```

**Note:** to configure environment variables from PowerShell, it is necessary to reopen a new shell after running scripts (e.g. `... && pwsh`) &mdash; refer to the [Intel documentation](https://www.intel.com/content/www/us/en/develop/documentation/oneapi-programming-guide/top/oneapi-development-environment-setup/use-the-setvars-script-with-windows.html) for more info.

### `cache`

The `cache` input is a boolean that controls whether the action caches the oneAPI compiler installation. The default is `true`.

**Note:** installation on Windows can take a long time (~30 minutes) so caching is recommended, however an [outstanding cache reservation bug in `actions/cache`](https://github.com/actions/cache/issues/144) can cause the cache to [fail to restore while simultaneously rejecting new saves](https://github.com/MODFLOW-USGS/modflow6/actions/runs/3624583228/jobs/6111766806#step:6:152). The [GitHub-endorsed workaround for this issue](https://github.com/actions/cache/issues/144#issuecomment-579323937) is currently to change keys, so this action rotates the cache key once daily. You may want to run a job in the early hours of the morning to warm up the cache on your repository's default branch, so PR/feature branches can restore from it throughout the day.

## Outputs

The action has the following outputs:

- `cache-hit`

### `cache-hit`

The `cache-hit` output indicates whether the cache was successfully restored. The output is `true` if the cache was restored, otherwise `false`. The value will always be `false` if the `cache` input is `false`.

Cache keys follow pattern:

```
intelfortran-${{ runner.os }}-${{ env.INTEL_HPCKIT_VERSION }}-${{ env.INTEL_HPCKIT_COMPONENTS }}-${{ %Y%m%d }}
```

## Windows caveats

There are a few things to be aware of when using this action on Windows runners.

### Bash & MSVC

GitHub Actions prepends GNU bin paths to the system path before running `bash` shell steps. This causes the GNU linker to be found even if the MSVC bin directory is on the path (more info [here](https://github.com/ilammy/msvc-dev-cmd#name-conflicts-with-shell-bash)). To make sure the MSVC toolchain is selected in `bash` steps on Windows, this action hides the GNU linker, moving it from `/usr/bin/link` to `$RUNNER_TEMP/link`.

### Visual Studio

GitHub Actions `windows-2022` runner images [have Visual Studio version 17.4](https://github.com/actions/runner-images/blob/main/images/win/Windows2022-Readme.md#visual-studio-enterprise-2022) preinstalled, however Intel oneAPI compilers are [not yet compatible with Visual Studio 17.4](https://community.intel.com/t5/Intel-C-Compiler/error-no-instance-of-overloaded-function-matches-the-argument/m-p/1436043/highlight/true#M40535). This can cause compiler errors, for instance:

```shell
error: no instance of overloaded function <function> matches the argument list
```

To work around this until Intel introduces support for VS 17.4+ it is recommended to use the `windows-2019` runner image, which has Visual Studio 16.

### Install location

While the HPC toolkit's install location can be selected freely on Linux and Mac, on Windows there is an unresolved issue causing bundled environment configuration scripts [to fail](https://github.com/w-bonelli/install-intelfortran-action/actions/runs/3298296907/jobs/5440222932#step:5:120) when the toolkit is installed to locations other than the default `C:\Program Files (x86)\Intel\oneAPI`. Different values for the `path` input are currently ignored for Windows and this location is configured automatically.

<!-- The Intel oneAPI HPC Toolkit installer defaults to different install locations on Unix and Windows if a path is not explicitly provided with the `--install-dir` option:

- Linux/Mac: `/opt/intel/oneapi`
- Windows: `C:\Program Files (x86)\Intel\oneAPI`

**This action overrides these.** The action's default install location, `~/.local/bin/ifort`, is the same on all three platforms. -->

### Conda `Scripts`

On Windows, this action can stomp on system path configurations set up by `mamba-org/provision-with-micromamba` and `setup-micromamba`, causing programs in `<micromamba root>\envs\<your environment name>\Scripts` not to be found when `shell: pwsh` is used. The recommended pattern to avoid this is:

1) Use `mamba-org/provision-with-micromamba@main` or `setup-micromamba@v1`. If the former, the root is `C:\Users\runneradmin\micromamba-root\`. If the latter, specify the root with the `micromamba-root-path` input (e.g., `${{ runner.temp }}/micromamba-root`).
2) Use `modflowpy/install-intelfortran-action@v1`
3) Add a step like the following to add the `Scripts` dir to the path, before any steps expecting to use the Micromamba environment (implemented in Powershell below, but need not be):

```pwsh
# former for provision-with-micromamba, latter for setup-micromamba
$path = "C:\Users\runneradmin\micromamba-root\envs\<env name>\Scripts"
# $path = "${{ runner.temp }}\micromamba-root\envs\<env name>\Scripts"
echo $path | Out-File -FilePath $env:GITHUB_PATH -Encoding utf8 -Append
```

## License

This action is based on examples in the [oneAPI CI samples repository](https://github.com/oneapi-src/oneapi-ci), which are subject to the [oneAPI End User License Agreement](https://www.intel.com/content/www/us/en/developer/articles/license/end-user-license-agreement.html), copyrighted to Intel, and distributed under the MIT license:

```
SPDX-FileCopyrightText: 2020 Intel Corporation
SPDX-License-Identifier: MIT
```
