#!/bin/bash

echo "Starting File Extractor Application..."
echo ""
echo "This application will help you extract multiple file types from directories."
echo "Supported: .py, .env, .yml, .yaml, .json, .tsx, .ts, Dockerfile"
echo "It also creates detailed folder structure reports automatically."
echo "Automatically excludes node_modules and other unwanted directories."
echo ""
echo "Requirements:"
echo "- Python 3.6 or higher must be installed"
echo "- Python must be in your system PATH"
echo ""
echo "If you encounter any issues, please check the README.md file."
echo ""

# Check if Python is available
if ! command -v python3 &> /dev/null; then
    if ! command -v python &> /dev/null; then
        echo "Error: Python is not installed or not in PATH"
        echo "Please install Python 3.6 or higher and try again"
        exit 1
    else
        PYTHON_CMD="python"
    fi
else
    PYTHON_CMD="python3"
fi

echo "Using Python command: $PYTHON_CMD"
echo ""

# Run the application
$PYTHON_CMD file_extractor.py

# Check exit status
if [ $? -ne 0 ]; then
    echo ""
    echo "Error: Could not run the application."
    echo "Please ensure Python is installed and in your PATH."
    echo ""
    read -p "Press Enter to continue..."
fi
