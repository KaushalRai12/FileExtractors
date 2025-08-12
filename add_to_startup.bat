@echo off
echo ========================================
echo File Extractor - Add to Startup
echo ========================================
echo.

REM Check if virtual environment exists
if not exist "venv\Scripts\Activate.ps1" (
    echo ERROR: Virtual environment not found!
    echo Please run the installer first: install_windows.bat
    pause
    exit /b 1
)

echo This script will add File Extractor to Windows startup.
echo The application will launch automatically when you log in.
echo.

REM Get current directory
set INSTALL_DIR=%~dp0
set STARTUP_FOLDER=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup

echo Installation Directory: %INSTALL_DIR%
echo Startup Folder: %STARTUP_FOLDER%
echo.

REM Create startup batch file
echo Creating startup script...
set STARTUP_SCRIPT=%STARTUP_FOLDER%\File Extractor Startup.bat

echo @echo off > "%STARTUP_SCRIPT%"
echo REM File Extractor Startup Script >> "%STARTUP_SCRIPT%"
echo REM Created: %date% %time% >> "%STARTUP_SCRIPT%"
echo. >> "%STARTUP_SCRIPT%"
echo cd /d "%INSTALL_DIR%" >> "%STARTUP_SCRIPT%"
echo venv\Scripts\Activate.ps1 >> "%STARTUP_SCRIPT%"
echo file-extractor-gui >> "%STARTUP_SCRIPT%"

if exist "%STARTUP_SCRIPT%" (
    echo.
    echo SUCCESS: File Extractor added to startup!
    echo.
    echo The application will now launch automatically when you log in.
    echo Startup script location: %STARTUP_SCRIPT%
    echo.
    echo To remove from startup, delete the file above.
) else (
    echo.
    echo ERROR: Failed to create startup script.
    echo.
    echo You can manually add to startup by:
    echo 1. Press Win+R, type: shell:startup
    echo 2. Create a shortcut to: %INSTALL_DIR%\venv\Scripts\file-extractor-gui.exe
)

echo.
echo Press any key to exit...
pause >nul
