cmd.exe /c 'scripts/install/build_windows.bat'
ifort scripts/test/hw.f90 -o hw
$output=$(./hw)
if ($output -contains "hello world") {
    echo "Compiled and ran successfully, output: $output"
} else {
    exit 1
}