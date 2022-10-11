# SPDX-FileCopyrightText: 2020 Intel Corporation
# SPDX-License-Identifier: MIT
curl --output webimage.dmg --url "$1" --retry 5 --retry-delay 5
hdiutil attach webimage.dmg
if [ -z "$2" ]; then
  sudo /Volumes/"$(basename "$1" .dmg)"/bootstrapper.app/Contents/MacOS/bootstrapper -s --action install --eula=accept --continue-with-optional-error=yes --log-dir=.
  installer_exit_code=$?
else
  sudo /Volumes/"$(basename "$1" .dmg)"/bootstrapper.app/Contents/MacOS/bootstrapper -s --action install --components="$2" --eula=accept --log-dir=.
  installer_exit_code=$?
fi
hdiutil detach /Volumes/"$(basename "$1" .dmg)" -quiet
exit $installer_exit_code