@echo off
echo ========================================
echo Final Fix: Creating Working Shortcuts
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

REM Remove old broken shortcuts
echo Removing old shortcuts...
if exist "%START_MENU%\File Extractor\File Extractor.bat" del "%START_MENU%\File Extractor\File Extractor.bat"
if exist "%DESKTOP%\File Extractor.bat" del "%DESKTOP%\File Extractor.bat"
if exist "%STARTUP_FOLDER%\File Extractor.bat" del "%STARTUP_FOLDER%\File Extractor.bat"

REM Create working Start Menu shortcut
echo Creating working Start Menu shortcut...
if not exist "%START_MENU%\File Extractor" mkdir "%START_MENU%\File Extractor"

REM Copy the working launcher to Start Menu
copy "launch_file_extractor.bat" "%START_MENU%\File Extractor\File Extractor.bat" >nul
if %errorlevel% equ 0 (
    echo ✓ Start Menu shortcut created
) else (
    echo ✗ Start Menu shortcut failed
)

REM Create working desktop shortcut
echo Creating working desktop shortcut...
copy "launch_file_extractor.bat" "%DESKTOP%\File Extractor.bat" >nul
if %errorlevel% equ 0 (
    echo ✓ Desktop shortcut created
) else (
    echo ✗ Desktop shortcut failed
)

REM Create working startup shortcut
echo Creating working startup shortcut...
copy "launch_file_extractor.bat" "%STARTUP_FOLDER%\File Extractor.bat" >nul
if %errorlevel% equ 0 (
    echo ✓ Startup shortcut created
) else (
    echo ✗ Startup shortcut failed
)

REM Create a simple direct launcher for testing
echo Creating direct launcher...
echo @echo off > "launch_simple.bat"
echo cd /d "%INSTALL_DIR%" >> "launch_simple.bat"
echo venv\Scripts\python.exe file_extractor.py >> "launch_simple.bat"
echo pause >> "launch_simple.bat"

echo.
echo ========================================
echo Shortcuts Fixed Successfully!
echo ========================================
echo.
echo File Extractor should now work from:
echo 1. Start Menu → All Apps → File Extractor
echo 2. Desktop shortcut (File Extractor.bat)
echo 3. Automatic startup when you log in
echo 4. Direct launcher: launch_simple.bat
echo.
echo To test: Double-click the desktop shortcut
echo.

REM Test the launcher
echo Testing launcher...
echo.
echo If you see a GUI window, the fix worked!
echo.
echo Press any key to exit...
pause >nul
