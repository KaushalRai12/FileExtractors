#!/bin/bash

echo "========================================"
echo "File Extractor - Unix/Linux/macOS Installer"
echo "========================================"
echo

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "ERROR: Python 3 is not installed or not in PATH"
    echo "Please install Python 3.6+ from https://python.org or your package manager"
    exit 1
fi

# Check Python version
python_version=$(python3 -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
required_version="3.6"

if [ "$(printf '%s\n' "$required_version" "$python_version" | sort -V | head -n1)" != "$required_version" ]; then
    echo "ERROR: Python 3.6+ is required"
    echo "Current version: $python_version"
    exit 1
fi

echo "Python version OK: $python_version"
echo

# Create virtual environment
echo "Creating virtual environment..."
python3 -m venv venv
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to create virtual environment"
    exit 1
fi

# Activate virtual environment
echo "Activating virtual environment..."
source venv/bin/activate
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to activate virtual environment"
    exit 1
fi

# Install the package
echo "Installing File Extractor..."
pip install -e .
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to install package"
    exit 1
fi

echo
echo "========================================"
echo "Installation Complete!"
echo "========================================"
echo
echo "You can now run the File Extractor using:"
echo "  file-extractor-gui"
echo
echo "Or from the command line:"
echo "  file-extractor"
echo
echo "The application will be available system-wide."
echo

# Create desktop shortcut for Linux
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Creating desktop shortcut..."
    desktop_dir="$HOME/Desktop"
    
    # Try different desktop directory locations
    if [ ! -d "$desktop_dir" ]; then
        if [ -d "$HOME/Desktop" ]; then
            desktop_dir="$HOME/Desktop"
        elif [ -d "$HOME/桌面" ]; then
            desktop_dir="$HOME/桌面"
        elif [ -d "$HOME/Рабочий стол" ]; then
            desktop_dir="$HOME/Рабочий стол"
        fi
    fi
    
    if [ -d "$desktop_dir" ]; then
        shortcut_file="$desktop_dir/file-extractor.desktop"
        cat > "$shortcut_file" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=File Extractor
Comment=Extract files by type with custom filtering
Exec=$PWD/venv/bin/file-extractor-gui
Icon=$PWD/venv/bin/python
Terminal=false
Categories=Utility;FileManager;
EOF
        
        chmod +x "$shortcut_file"
        echo "Desktop shortcut created at: $shortcut_file"
    else
        echo "Warning: Could not find desktop directory"
    fi
fi

# Create alias in shell profile
echo "Creating shell alias..."
shell_profile=""
if [ -f "$HOME/.bashrc" ]; then
    shell_profile="$HOME/.bashrc"
elif [ -f "$HOME/.zshrc" ]; then
    shell_profile="$HOME/.zshrc"
elif [ -f "$HOME/.profile" ]; then
    shell_profile="$HOME/.profile"
fi

if [ -n "$shell_profile" ]; then
    alias_line="alias file-extractor='$PWD/venv/bin/file-extractor-gui'"
    
    # Check if alias already exists
    if ! grep -q "alias file-extractor=" "$shell_profile"; then
        echo "" >> "$shell_profile"
        echo "# File Extractor alias" >> "$shell_profile"
        echo "$alias_line" >> "$shell_profile"
        echo "Alias added to $shell_profile"
        echo "Please restart your terminal or run: source $shell_profile"
    else
        echo "Alias already exists in $shell_profile"
    fi
else
    echo "Warning: Could not find shell profile to add alias"
fi

echo
echo "Installation completed successfully!"
echo "You can now run 'file-extractor-gui' from anywhere in the virtual environment."
