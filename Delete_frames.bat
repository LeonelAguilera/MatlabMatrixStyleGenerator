@echo off
echo This program will DELETE all files with syntax Frame_*.png

echo Would you like to continue [Y/N]?

set /p cont=
if "%cont%"=="y" goto proceed
if "%cont%"=="Y" goto proceed
if "%cont%"=="n" goto ini
if "%cont%"=="N" goto ini
goto close

:proceed
@echo on
del Frame_*.png
echo Finished
pause
goto close

:close
@cls&exit

