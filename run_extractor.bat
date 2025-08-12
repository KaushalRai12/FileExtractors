@echo off
echo Starting File Extractor Application...
echo.
echo This application will help you extract multiple file types from directories.
echo Supported: .py, .env, .yml, .yaml, .json, .tsx, .ts, Dockerfile
echo It also creates detailed folder structure reports automatically.
echo Automatically excludes node_modules and other unwanted directories.
echo.
echo Requirements:
echo - Python 3.6 or higher must be installed
echo - Python must be in your system PATH
echo.
echo If you encounter any issues, please check the README.md file.
echo.
pause
python file_extractor.py
if errorlevel 1 (
    echo.
    echo Error: Could not run the application.
    echo Please ensure Python is installed and in your PATH.
    echo.
    pause
)
