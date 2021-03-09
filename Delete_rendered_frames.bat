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
cd Rendered_imgs
del Frame_*.png
echo Finished
timeout /T 1
goto close

:close
@cls&exit

