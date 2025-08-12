@echo off
echo ========================================
echo Testing File Extractor Shortcuts
echo ========================================
echo.

REM Get paths
set INSTALL_DIR=%~dp0
set START_MENU=%APPDATA%\Microsoft\Windows\Start Menu\Programs
set DESKTOP=%USERPROFILE%\OneDrive\Desktop
set STARTUP_FOLDER=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup

echo Testing shortcuts...
echo.

REM Test Start Menu shortcut
if exist "%START_MENU%\File Extractor\File Extractor.bat" (
    echo ✓ Start Menu shortcut exists
) else (
    echo ✗ Start Menu shortcut missing
)

REM Test Desktop shortcut
if exist "%DESKTOP%\File Extractor.bat" (
    echo ✓ Desktop shortcut exists
) else (
    echo ✗ Desktop shortcut missing
)

REM Test Startup shortcut
if exist "%STARTUP_FOLDER%\File Extractor.bat" (
    echo ✓ Startup shortcut exists
) else (
    echo ✗ Startup shortcut missing
)

REM Test executable
if exist "%INSTALL_DIR%venv\Scripts\file-extractor-gui.exe" (
    echo ✓ Executable exists
) else (
    echo ✗ Executable missing
)

echo.
echo ========================================
echo Shortcut Test Results
echo ========================================
echo.
echo To test the shortcuts:
echo.
echo 1. Desktop Shortcut:
echo    - Go to: %DESKTOP%
echo    - Double-click: File Extractor.bat
echo.
echo 2. Start Menu:
echo    - Press Win key
echo    - Type: File Extractor
echo    - Click on the result
echo.
echo 3. Direct Launch:
echo    - Navigate to: %INSTALL_DIR%
echo    - Double-click: venv\Scripts\file-extractor-gui.exe
echo.

echo Press any key to exit...
pause >nul
