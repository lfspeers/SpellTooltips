@echo off
setlocal

set "SOURCE=%~dp0"
set "DEST=C:\Program Files (x86)\World of Warcraft\_anniversary_\Interface\AddOns\SpellTooltips"

echo Deploying SpellTooltips to WoW AddOns folder...
echo Source: %SOURCE%
echo Dest: %DEST%

:: Remove existing folder if it exists
if exist "%DEST%" (
    echo Removing existing folder...
    rmdir /S /Q "%DEST%"
)

:: Create destination folder
mkdir "%DEST%"

:: Copy all files using robocopy (better for this use case)
robocopy "%SOURCE%." "%DEST%" /E /XF deploy.bat *.md /XD .git

echo.
echo Deployed SpellTooltips to WoW AddOns folder
endlocal
