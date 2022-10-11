bin="$1"  # install location
url="$2"  # download url
cmp="$3"  # components
ver="$4"  # version
dmg=$(basename "$url" .dmg)

curl --output webimage.sh --url "$url" --retry 5 --retry-delay 5
chmod +x webimage.sh
./webimage.sh -x -f webimage_extracted --log extract.log
rm -rf webimage.sh
WEBIMAGE_NAME=$(ls -1 webimage_extracted/)
if [ -z "$cmp" ]; then
  echo "installing version $ver with components $cmp"
  sudo webimage_extracted/"$WEBIMAGE_NAME"/bootstrapper -s --action install --eula=accept --log-dir=. --install-dir "$bin" --product-ver "$ver"
  installer_exit_code=$?
else
  echo "installing version $ver"
  sudo webimage_extracted/"$WEBIMAGE_NAME"/bootstrapper -s --action install --components="$cmp" --eula=accept --log-dir=. --install-dir "$bin" --product-ver "$ver"
  installer_exit_code=$?
fi
rm -rf webimage_extracted
exit $installer_exit_code