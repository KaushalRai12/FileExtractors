@echo off
echo ========================================
echo Launching File Extractor...
echo ========================================
echo.

REM Get current directory
set INSTALL_DIR=%~dp0

REM Change to installation directory
cd /d "%INSTALL_DIR%"

REM Activate virtual environment
echo Activating virtual environment...
call venv\Scripts\activate.bat

REM Launch the application
echo Launching File Extractor GUI...
python file_extractor.py

echo.
echo Application closed.
pause
