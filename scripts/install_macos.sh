bin="$1"  # install location
url="$2"  # download url
cmp="$3"  # components
ver="$4"  # version
dmg=$(basename "$url" .dmg)

curl --output webimage.dmg --url "$url" --retry 5 --retry-delay 5
hdiutil attach webimage.dmg
if [ -z "$cmp" ]; then
  echo "installing version $ver with components $cmp"
  sudo /Volumes/"$dmg"/bootstrapper.app/Contents/MacOS/bootstrapper -s --action install --eula=accept --continue-with-optional-error=yes --log-dir=. --install-dir "$bin" --product-ver "$ver"
  installer_exit_code=$?
else
  echo "installing version $ver"
  sudo /Volumes/"$dmg"/bootstrapper.app/Contents/MacOS/bootstrapper -s --action install --components="$cmp" --eula=accept --log-dir=. --install-dir "$bin" --product-ver "$ver"
  installer_exit_code=$?
fi
hdiutil detach /Volumes/"$dmg" -quiet
exit $installer_exit_code