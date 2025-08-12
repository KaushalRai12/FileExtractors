@echo off
echo ========================================
echo File Extractor - Simple Shortcut Creator
echo ========================================
echo.

REM Get current directory and desktop path
set INSTALL_DIR=%~dp0
set DESKTOP=%USERPROFILE%\Desktop

echo Installation Directory: %INSTALL_DIR%
echo Desktop Directory: %DESKTOP%
echo.

REM Create a simple batch file shortcut
echo Creating desktop shortcut...
set SHORTCUT_BAT=%DESKTOP%\File Extractor.bat

echo @echo off > "%SHORTCUT_BAT%"
echo cd /d "%INSTALL_DIR%" >> "%SHORTCUT_BAT%"
echo venv\Scripts\Activate.ps1 >> "%SHORTCUT_BAT%"
echo file-extractor-gui >> "%SHORTCUT_BAT%"
echo pause >> "%SHORTCUT_BAT%"

if exist "%SHORTCUT_BAT%" (
    echo.
    echo SUCCESS: Desktop shortcut created at:
    echo %SHORTCUT_BAT%
    echo.
    echo You can now double-click this file to run File Extractor!
) else (
    echo.
    echo ERROR: Failed to create shortcut.
    echo.
    echo You can still run the application by:
    echo 1. Opening PowerShell in this folder
    echo 2. Running: venv\Scripts\Activate.ps1
    echo 3. Running: file-extractor-gui
)

echo.
echo Press any key to exit...
pause >nul
