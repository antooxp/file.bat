@echo off
setlocal EnableDelayedExpansion
title Quick Random File Creator

echo Quick File Creator
echo.
echo 1. Random 10 symbols
echo 2. Specific content
echo 3. Random image
echo.

choice /c 123 /n /m "Choose [1-3]: "

if errorlevel 3 goto IMAGE
if errorlevel 2 goto SPECIFIC
if errorlevel 1 goto RANDOM

:RANDOM
set "chars=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%%^&*()-_=+[]{};:,.?/"
set "content="

for /l %%A in (1,1,10) do (
    set /a "index=!random! %% 84"
    for %%B in (!index!) do set "content=!content!!chars:~%%B,1!"
)

goto TYPE

:SPECIFIC
echo.
set /p "content=Enter the content for the file: "
goto TYPE

:TYPE
echo.
echo Choose a file type:
echo.
echo 1. TXT
echo 2. BAT
echo 3. HTML
echo 4. PY
echo 5. JS
echo 6. Custom extension
echo.

choice /c 123456 /n /m "Choose [1-6]: "

if errorlevel 6 goto CUSTOM
if errorlevel 5 set "ext=js" & goto CREATE
if errorlevel 4 set "ext=py" & goto CREATE
if errorlevel 3 set "ext=html" & goto CREATE
if errorlevel 2 set "ext=bat" & goto CREATE
if errorlevel 1 set "ext=txt" & goto CREATE

:CUSTOM
echo.
set /p "ext=Enter the file extension (without the dot): "
goto CREATE

:CREATE
echo.
set /p "filename=Enter the file name: "

if "%filename%"=="" exit /b

> "%~dp0%filename%.%ext%" echo %content%

echo.
echo Created:
echo %~dp0%filename%.%ext%
echo.
pause
exit /b

:IMAGE
echo.
echo Random Image Generator
echo.
echo Maximum size: 200x200
echo Maximum aspect ratio: 30:1
echo.

set /p "width=Image width in pixels: "
set /p "height=Image height in pixels: "
set /p "filename=Image file name: "

if "%width%"=="" exit /b
if "%height%"=="" exit /b
if "%filename%"=="" exit /b

set /a widthCheck=width
set /a heightCheck=height

if %widthCheck% LSS 1 (
    echo Invalid width.
    pause
    exit /b
)

if %heightCheck% LSS 1 (
    echo Invalid height.
    pause
    exit /b
)

if %widthCheck% GTR 200 (
    echo Maximum width is 200 pixels.
    pause
    exit /b
)

if %heightCheck% GTR 200 (
    echo Maximum height is 200 pixels.
    pause
    exit /b
)

set /a ratio1=widthCheck
set /a ratio2=heightCheck*30

if %ratio1% GTR %ratio2% (
    echo Maximum aspect ratio is 30:1.
    pause
    exit /b
)

set /a ratio1=heightCheck
set /a ratio2=widthCheck*30

if %ratio1% GTR %ratio2% (
    echo Maximum aspect ratio is 1:30.
    pause
    exit /b
)

echo.
echo Generating %width%x%height% random image...
echo.

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
"Add-Type -AssemblyName System.Drawing; $w=%width%; $h=%height%; $bmp=New-Object System.Drawing.Bitmap($w,$h); $r=New-Object System.Random; for($y=0;$y -lt $h;$y++){for($x=0;$x -lt $w;$x++){ $bmp.SetPixel($x,$y,[System.Drawing.Color]::FromArgb($r.Next(256),$r.Next(256),$r.Next(256))) }}; $bmp.Save('%~dp0%filename%.png',[System.Drawing.Imaging.ImageFormat]::Png); $bmp.Dispose()"

echo.
echo Random image created!
echo %~dp0%filename%.png
echo.
pause