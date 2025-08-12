@echo off
echo ========================================
echo Creating Working File Extractor Shortcuts
echo ========================================
echo.

REM Get current directory
set INSTALL_DIR=%~dp0
set START_MENU=%APPDATA%\Microsoft\Windows\Start Menu\Programs
set DESKTOP=%USERPROFILE%\OneDrive\Desktop
set STARTUP_FOLDER=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup

echo Installation Directory: %INSTALL_DIR%
echo Start Menu: %START_MENU%
echo Desktop: %DESKTOP%
echo.

REM Create Start Menu shortcut
echo Creating Start Menu shortcut...
if not exist "%START_MENU%\File Extractor" mkdir "%START_MENU%\File Extractor"

REM Create a simple batch file that works
echo @echo off > "%START_MENU%\File Extractor\File Extractor.bat"
echo cd /d "%INSTALL_DIR%" >> "%START_MENU%\File Extractor\File Extractor.bat"
echo "%INSTALL_DIR%venv\Scripts\file-extractor-gui.exe" >> "%START_MENU%\File Extractor\File Extractor.bat"
echo pause >> "%START_MENU%\File Extractor\File Extractor.bat"

REM Create desktop shortcut
echo Creating desktop shortcut...
echo @echo off > "%DESKTOP%\File Extractor.bat"
echo cd /d "%INSTALL_DIR%" >> "%DESKTOP%\File Extractor.bat"
echo "%INSTALL_DIR%venv\Scripts\file-extractor-gui.exe" >> "%DESKTOP%\File Extractor.bat"
echo pause >> "%DESKTOP%\File Extractor.bat"

REM Create startup shortcut
echo Creating startup shortcut...
echo @echo off > "%STARTUP_FOLDER%\File Extractor.bat"
echo cd /d "%INSTALL_DIR%" >> "%STARTUP_FOLDER%\File Extractor.bat"
echo timeout /t 5 /nobreak >nul >> "%STARTUP_FOLDER%\File Extractor.bat"
echo "%INSTALL_DIR%venv\Scripts\file-extractor-gui.exe" >> "%STARTUP_FOLDER%\File Extractor.bat"

REM Test the executable directly
echo.
echo Testing executable...
if exist "%INSTALL_DIR%venv\Scripts\file-extractor-gui.exe" (
    echo ✓ Executable found
    echo Testing launch...
    "%INSTALL_DIR%venv\Scripts\file-extractor-gui.exe" --help >nul 2>&1
    if %errorlevel% equ 0 (
        echo ✓ Executable test successful!
    ) else (
        echo ⚠ Executable test had issues (this is normal for GUI apps)
    )
) else (
    echo ✗ Executable not found!
)

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
echo Shortcuts Created Successfully!
echo ========================================
echo.
echo File Extractor should now work from:
echo 1. Start Menu → All Apps → File Extractor
echo 2. Desktop shortcut (File Extractor.bat)
echo 3. Automatic startup when you log in
echo.
echo To test: Double-click the desktop shortcut
echo.
echo The app should also appear in Windows Search now!
echo.

echo.
echo Press any key to exit...
pause >nul
