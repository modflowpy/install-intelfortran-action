$path=$args[0]
if (!($path)) {
    write-output "must specify path argument"
    exit 1
}

# if (test-path $path)
# {
#     write-output "install location exists: $path"
# } else {
#     write-output "install location doesn't exist: $path"
#     exit 1
# }

if ((get-command "ifort" -ErrorAction SilentlyContinue) -eq $null) {
    write-output "ifort not available"
    exit 1
} else {
    write-output "ifort found"
    ifort /QV
}

ifort test/hw.f90 -o hw
$output=$(./hw)
if ($output -match "hello world") {
    write-output "compile succeeded"
    write-output $output
} else {
    write-output "unexpected output: $output"
    exit 1
}
