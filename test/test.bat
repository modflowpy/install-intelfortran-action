ifort test/hw.f90 -o hw

FOR /F "tokens=* USEBACKQ" %%F IN (`hw`) DO (
SET output=%%F
)

if /I "%output:hello=%" neq "%output%" (
echo fortran compile succeeded
) else (
echo "unexpected output: %output%" exit /b 1
)

del hw
icl test/hw.cpp -o hw

FOR /F "tokens=* USEBACKQ" %%F IN (`hw`) DO (
SET output=%%F
)

if /I "%output:hello=%" neq "%output%" (
echo icl compile succeeded
) else (
echo "icl unexpected output: %output%" exit /b 1
)

del hw
icx test/hw.cpp -o hw

FOR /F "tokens=* USEBACKQ" %%F IN (`hw`) DO (
SET output=%%F
)

if /I "%output:hello=%" neq "%output%" (
echo icx compile succeeded
) else (
echo "icx unexpected output: %output%" exit /b 1
)