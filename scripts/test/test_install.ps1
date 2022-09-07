
$path=$args[0]
if (!($path)) {
    echo "Must specify path argument"
    exit 1
}

echo "Checking install location: $path"
if (!(test-path $path)) {
    echo "Install location does not exist: $path"
    exit 1
}

echo "Checking ifort command"
if ((get-command "ifort" -ErrorAction SilentlyContinue) -eq $null) {
    echo "ifort command is not available"
    exit 1
}

