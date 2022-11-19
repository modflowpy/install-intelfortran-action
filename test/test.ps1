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

if ((get-command "icpc" -ErrorAction SilentlyContinue) -eq $null) {
    write-output "icpc not available"
    exit 1
} else {
    write-output "icpc found"
    icc /QV
}

if ((get-command "icpx" -ErrorAction SilentlyContinue) -eq $null) {
    write-output "icpx not available"
    exit 1
} else {
    write-output "icpx found"
    icx /QV
}

ifort test/hw.f90 -o hw
$output=$(./hw)
if ($output -match "hello world") {
    write-output "ifort compile succeeded"
    write-output $output
} else {
    write-output "ifort unexpected output: $output"
    exit 1
}

sudo rm -rf hw
icl test/hw.cpp -o hw
$output=$(./hw)
if ($output -match "hello world") {
    write-output "icl compile succeeded"
    write-output $output
} else {
    write-output "icl unexpected output: $output"
    exit 1
}

sudo rm -rf hw
icx test/hw.cpp -o hw
$output=$(./hw)
if ($output -match "hello world") {
    write-output "icx compile succeeded"
    write-output $output
} else {
    write-output "icx unexpected output: $output"
    exit 1
}
