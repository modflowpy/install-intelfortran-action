ifort test/hw.f90 -o hw

FOR /F "tokens=* USEBACKQ" %%F IN (`hw`) DO (
SET output=%%F
)

if /I "%output:hello=%" neq "%output%" (
echo compile succeeded
) else (
echo "unexpected output: %output%" exit /b 1
)