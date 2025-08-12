@echo off
echo ========================================
echo Fixing File Extractor Shortcuts
echo ========================================
echo.

REM Get current directory
set INSTALL_DIR=%~dp0
set START_MENU=%APPDATA%\Microsoft\Windows\Start Menu\Programs
set DESKTOP=%USERPROFILE%\OneDrive\Desktop

echo Installation Directory: %INSTALL_DIR%
echo Start Menu: %START_MENU%
echo Desktop: %DESKTOP%
echo.

REM Remove old broken shortcuts
echo Removing old shortcuts...
if exist "%START_MENU%\File Extractor\File Extractor.lnk" del "%START_MENU%\File Extractor\File Extractor.lnk"
if exist "%DESKTOP%\File Extractor.lnk" del "%DESKTOP%\File Extractor.lnk"

REM Create working Start Menu shortcut (batch file)
echo Creating working Start Menu shortcut...
if not exist "%START_MENU%\File Extractor" mkdir "%START_MENU%\File Extractor"

echo @echo off > "%START_MENU%\File Extractor\File Extractor.bat"
echo REM File Extractor Launcher >> "%START_MENU%\File Extractor\File Extractor.bat"
echo cd /d "%INSTALL_DIR%" >> "%START_MENU%\File Extractor\File Extractor.bat"
echo venv\Scripts\Activate.ps1 >> "%START_MENU%\File Extractor\File Extractor.bat"
echo file-extractor-gui >> "%START_MENU%\File Extractor\File Extractor.bat"
echo pause >> "%START_MENU%\File Extractor\File Extractor.bat"

REM Create working desktop shortcut (batch file)
echo Creating working desktop shortcut...
echo @echo off > "%DESKTOP%\File Extractor.bat"
echo REM File Extractor Launcher >> "%DESKTOP%\File Extractor.bat"
echo cd /d "%INSTALL_DIR%" >> "%DESKTOP%\File Extractor.bat"
echo venv\Scripts\Activate.ps1 >> "%DESKTOP%\File Extractor.bat"
echo file-extractor-gui >> "%DESKTOP%\File Extractor.bat"
echo pause >> "%DESKTOP%\File Extractor.bat"

REM Create startup shortcut
echo Creating startup shortcut...
set STARTUP_FOLDER=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup
echo @echo off > "%STARTUP_FOLDER%\File Extractor.bat"
echo REM File Extractor Startup >> "%STARTUP_FOLDER%\File Extractor.bat"
echo cd /d "%INSTALL_DIR%" >> "%STARTUP_FOLDER%\File Extractor.bat"
echo timeout /t 5 /nobreak >nul >> "%STARTUP_FOLDER%\File Extractor.bat"
echo venv\Scripts\Activate.ps1 >> "%STARTUP_FOLDER%\File Extractor.bat"
echo file-extractor-gui >> "%STARTUP_FOLDER%\File Extractor.bat"

REM Verify shortcuts were created
echo.
echo Verifying shortcuts...
if exist "%START_MENU%\File Extractor\File Extractor.bat" (
    echo ✓ Start Menu shortcut created
) else (
    echo ✗ Start Menu shortcut failed
)

if exist "%DESKTOP%\File Extractor.bat" (
    echo ✓ Desktop shortcut created
) else (
    echo ✗ Desktop shortcut failed
)

if exist "%STARTUP_FOLDER%\File Extractor.bat" (
    echo ✓ Startup shortcut created
) else (
    echo ✗ Startup shortcut failed
)

echo.
echo ========================================
echo Shortcuts Fixed!
echo ========================================
echo.
echo File Extractor should now work from:
echo 1. Start Menu → All Apps → File Extractor
echo 2. Desktop shortcut (File Extractor.bat)
echo 3. Automatic startup when you log in
echo.
echo To test: Double-click the desktop shortcut
echo.

REM Test if the app can run
echo Testing application launch...
cd /d "%INSTALL_DIR%"
venv\Scripts\Activate.ps1
echo Testing file-extractor-gui command...
file-extractor-gui --help >nul 2>&1
if %errorlevel% equ 0 (
    echo ✓ Application test successful!
    echo The shortcuts should now work properly.
) else (
    echo ✗ Application test failed.
    echo Please check the virtual environment installation.
)

echo.
echo Press any key to exit...
pause >nul
