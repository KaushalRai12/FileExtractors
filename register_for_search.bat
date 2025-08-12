@echo off
echo ========================================
echo File Extractor - Register for Windows Search
echo ========================================
echo.

REM Check if virtual environment exists
if not exist "venv\Scripts\file-extractor-gui.exe" (
    echo ERROR: File Extractor not found!
    echo Please run the installer first: install_windows.bat
    pause
    exit /b 1
)

echo This script will make File Extractor appear in Windows Search.
echo The app will be discoverable when you search for "File Extractor".
echo.

REM Get current directory
set INSTALL_DIR=%~dp0
set DESKTOP=%USERPROFILE%\Desktop
set START_MENU=%APPDATA%\Microsoft\Windows\Start Menu\Programs
set STARTUP_FOLDER=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup

echo Installation Directory: %INSTALL_DIR%
echo Desktop Directory: %DESKTOP%
echo Start Menu: %START_MENU%
echo.

REM Create Start Menu shortcut (this makes it searchable)
echo Creating Start Menu shortcut...
if not exist "%START_MENU%\File Extractor" mkdir "%START_MENU%\File Extractor"

set START_MENU_SHORTCUT=%START_MENU%\File Extractor\File Extractor.lnk

REM Create Start Menu shortcut using PowerShell
powershell -Command "$WshShell = New-Object -comObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%START_MENU_SHORTCUT%'); $Shortcut.TargetPath = '%INSTALL_DIR%\venv\Scripts\file-extractor-gui.exe'; $Shortcut.WorkingDirectory = '%INSTALL_DIR%'; $Shortcut.IconLocation = '%INSTALL_DIR%\venv\Scripts\python.exe'; $Shortcut.Description = 'File Extractor - Custom File Types'; $Shortcut.Save()"

REM Create desktop shortcut
echo Creating desktop shortcut...
set DESKTOP_SHORTCUT=%DESKTOP%\File Extractor.lnk

powershell -Command "$WshShell = New-Object -comObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%DESKTOP_SHORTCUT%'); $Shortcut.TargetPath = '%INSTALL_DIR%\venv\Scripts\file-extractor-gui.exe'; $Shortcut.WorkingDirectory = '%INSTALL_DIR%'; $Shortcut.IconLocation = '%INSTALL_DIR%\venv\Scripts\python.exe'; $Shortcut.Description = 'File Extractor - Custom File Types'; $Shortcut.Save()"

REM Create startup shortcut
echo Creating startup shortcut...
set STARTUP_SHORTCUT=%STARTUP_FOLDER%\File Extractor.lnk

powershell -Command "$WshShell = New-Object -comObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%STARTUP_SHORTCUT%'); $Shortcut.TargetPath = '%INSTALL_DIR%\venv\Scripts\file-extractor-gui.exe'; $Shortcut.WorkingDirectory = '%INSTALL_DIR%'; $Shortcut.IconLocation = '%INSTALL_DIR%\venv\Scripts\python.exe'; $Shortcut.Description = 'File Extractor - Custom File Types'; $Shortcut.Save()"

REM Verify shortcuts were created
echo.
echo Verifying shortcuts...
if exist "%START_MENU_SHORTCUT%" (
    echo ✓ Start Menu shortcut created
) else (
    echo ✗ Start Menu shortcut failed
)

if exist "%DESKTOP_SHORTCUT%" (
    echo ✓ Desktop shortcut created
) else (
    echo ✗ Desktop shortcut failed
)

if exist "%STARTUP_SHORTCUT%" (
    echo ✓ Startup shortcut created
) else (
    echo ✗ Startup shortcut failed
)

echo.
echo ========================================
echo Registration Complete!
echo ========================================
echo.
echo File Extractor should now appear in:
echo 1. Windows Search (press Win key, type "File Extractor")
echo 2. Start Menu → All Apps → File Extractor
echo 3. Desktop shortcut
echo 4. Automatic startup when you log in
echo.
echo To test: Press Win key and type "File Extractor"
echo.

REM Test if the app can be found
echo Testing Windows Search registration...
powershell -Command "Get-StartApps | Where-Object {$_.Name -like '*File Extractor*'}" >nul 2>&1
if %errorlevel% equ 0 (
    echo ✓ App registered successfully!
) else (
    echo ⚠ App may take a few minutes to appear in search
    echo Try refreshing the Start Menu or restarting Windows Explorer
)

echo.
echo Press any key to exit...
pause >nul
