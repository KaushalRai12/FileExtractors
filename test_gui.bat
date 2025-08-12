@echo off
echo ========================================
echo Testing File Extractor GUI Launch
echo ========================================
echo.

REM Get current directory
set INSTALL_DIR=%~dp0

echo Testing GUI launch...
echo.
echo This will launch the File Extractor GUI.
echo If you see a window with buttons and options, it's working!
echo.
echo Press any key to launch...
pause >nul

REM Change to installation directory
cd /d "%INSTALL_DIR%"

REM Activate virtual environment and launch
echo Activating virtual environment...
call venv\Scripts\activate.bat

echo Launching File Extractor GUI...
python file_extractor.py

echo.
echo GUI closed. Test complete!
pause
