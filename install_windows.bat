@echo off
echo ========================================
echo File Extractor - Windows Installer
echo ========================================
echo.

REM Check if Python is installed
python --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Python is not installed or not in PATH
    echo Please install Python 3.6+ from https://python.org
    pause
    exit /b 1
)

echo Python found. Checking version...
python -c "import sys; exit(0 if sys.version_info >= (3, 6) else 1)"
if errorlevel 1 (
    echo ERROR: Python 3.6+ is required
    echo Current version:
    python --version
    pause
    exit /b 1
)

echo Python version OK.
echo.

REM Create virtual environment
echo Creating virtual environment...
python -m venv venv
if errorlevel 1 (
    echo ERROR: Failed to create virtual environment
    pause
    exit /b 1
)

REM Activate virtual environment
echo Activating virtual environment...
call venv\Scripts\activate.bat
if errorlevel 1 (
    echo ERROR: Failed to activate virtual environment
    pause
    exit /b 1
)

REM Install the package
echo Installing File Extractor...
pip install -e .
if errorlevel 1 (
    echo ERROR: Failed to install package
    pause
    exit /b 1
)

echo.
echo ========================================
echo Installation Complete!
echo ========================================
echo.
echo You can now run the File Extractor using:
echo   file-extractor-gui
echo.
echo Or from the command line:
echo   file-extractor
echo.
echo The application will be available system-wide.
echo.

REM Create desktop shortcut
echo Creating desktop shortcut...
set DESKTOP=%USERPROFILE%\Desktop
if exist "%DESKTOP%\File Extractor.lnk" (
    echo Desktop shortcut already exists.
) else (
    REM Use PowerShell script for more reliable shortcut creation
    powershell -ExecutionPolicy Bypass -File "%~dp0\create_shortcut.ps1" -InstallDir "%~dp0" -DesktopPath "%DESKTOP%"
    
    if exist "%DESKTOP%\File Extractor.lnk" (
        echo Desktop shortcut created successfully!
    ) else (
        echo Warning: Could not create desktop shortcut.
        echo You can still run the application using: file-extractor-gui
    )
)

echo.
echo Press any key to exit...
pause >nul
