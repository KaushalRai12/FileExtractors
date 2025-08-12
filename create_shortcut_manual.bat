@echo off
echo ========================================
echo File Extractor - Manual Shortcut Creator
echo ========================================
echo.

REM Check if virtual environment exists
if not exist "venv\Scripts\activate.bat" (
    echo ERROR: Virtual environment not found!
    echo Please run the installer first: install_windows.bat
    pause
    exit /b 1
)

echo Creating desktop shortcut manually...
echo.

REM Get current directory
set INSTALL_DIR=%~dp0
set DESKTOP=%USERPROFILE%\Desktop

echo Installation Directory: %INSTALL_DIR%
echo Desktop Directory: %DESKTOP%
echo.

REM Create batch file shortcut
echo Creating batch file shortcut...
set SHORTCUT_BAT=%DESKTOP%\File Extractor.bat

echo @echo off > "%SHORTCUT_BAT%"
echo cd /d "%INSTALL_DIR%" >> "%SHORTCUT_BAT%"
echo call venv\Scripts\activate.bat >> "%SHORTCUT_BAT%"
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
    echo 1. Opening Command Prompt in this folder
    echo 2. Running: venv\Scripts\activate.bat
    echo 3. Running: file-extractor-gui
)

echo.
echo Press any key to exit...
pause >nul
