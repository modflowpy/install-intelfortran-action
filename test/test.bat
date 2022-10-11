ifort test/hw.f90 -o hw

FOR /F "tokens=* USEBACKQ" %%F IN (`hw`) DO (
SET output=%%F
)

if /I "%output:hello=%" neq "%output%" (
echo "Compile succeeded"
) else (
echo "Unexpected output: %output%" exit /b 1
)