@echo off
echo ========================================
echo Making File Extractor Searchable in Windows
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

REM Create Start Menu folder
if not exist "%START_MENU%\File Extractor" mkdir "%START_MENU%\File Extractor"

REM Create Start Menu shortcut (this makes it searchable)
echo Creating Start Menu shortcut...
set START_MENU_SHORTCUT=%START_MENU%\File Extractor\File Extractor.lnk

REM Use PowerShell to create the shortcut
powershell -Command "$WshShell = New-Object -comObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%START_MENU_SHORTCUT%'); $Shortcut.TargetPath = '%INSTALL_DIR%\venv\Scripts\file-extractor-gui.exe'; $Shortcut.WorkingDirectory = '%INSTALL_DIR%'; $Shortcut.IconLocation = '%INSTALL_DIR%\venv\Scripts\python.exe'; $Shortcut.Description = 'File Extractor - Custom File Types'; $Shortcut.Save()"

REM Create a simple batch file in Start Menu as backup
echo @echo off > "%START_MENU%\File Extractor\File Extractor.bat"
echo cd /d "%INSTALL_DIR%" >> "%START_MENU%\File Extractor\File Extractor.bat"
echo venv\Scripts\Activate.ps1 >> "%START_MENU%\File Extractor\File Extractor.bat"
echo file-extractor-gui >> "%START_MENU%\File Extractor\File Extractor.bat"

REM Verify the shortcut was created
if exist "%START_MENU_SHORTCUT%" (
    echo.
    echo SUCCESS: File Extractor is now searchable!
    echo.
    echo You can now find it by:
    echo 1. Press Win key and type "File Extractor"
    echo 2. Go to Start Menu → All Apps → File Extractor
    echo 3. Use the desktop shortcut
    echo.
    echo The app should appear in Windows Search results.
) else (
    echo.
    echo WARNING: Shortcut creation may have failed.
    echo.
    echo You can still run the app by:
    echo 1. Going to: %INSTALL_DIR%
    echo 2. Running: venv\Scripts\Activate.ps1
    echo 3. Running: file-extractor-gui
)

echo.
echo Press any key to exit...
pause >nul
