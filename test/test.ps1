$path=$args[0]
if (!($path)) {
    write-output "Must specify path argument"
    exit 1
}

if (test-path $path)
{
    write-output "Found install location: $path"
} else {
    write-output "Install location doesn't exist: $path"
    exit 1
}

if ((get-command "ifort" -ErrorAction SilentlyContinue) -eq $null) {
    write-output "Command ifort not available"
    exit 1
} else {
    write-output "Command ifort found"
}

ifort test/hw.f90 -o hw
write-output "Compile succeeded"

$output=$(./hw)
if ($output -match "hello world") {
    write-output $output
} else {
    write-output "Unexpected output: $output"
    exit 1
}