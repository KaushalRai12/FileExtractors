# File Extractor - Installation Guide

## 🚀 Quick Start

### For Windows Users
1. **Download** the FileExtractors folder to your computer
2. **Double-click** `install_windows.bat`
3. **Follow** the installation prompts
4. **Launch** from desktop shortcut or command line

### For Linux/macOS Users
1. **Download** the FileExtractors folder to your computer
2. **Open terminal** in the FileExtractors folder
3. **Run**: `chmod +x install_unix.sh && ./install_unix.sh`
4. **Follow** the installation prompts
5. **Launch** from desktop shortcut or command line

## 📋 Prerequisites

- **Python 3.6 or higher** (check with `python --version`)
- **No external packages required** - uses only Python standard library
- **Administrator privileges** (Windows) or **sudo** (Linux/macOS) for installation

## 🔧 Installation Methods

### Method 1: Automated Installer (Recommended)

#### Windows
```batch
# Simply double-click install_windows.bat
# Or run from command prompt:
install_windows.bat
```

#### Linux/macOS
```bash
# Make executable and run
chmod +x install_unix.sh
./install_unix.sh
```

### Method 2: Manual Installation

```bash
# Navigate to FileExtractors folder
cd FileExtractors

# Create virtual environment
python -m venv venv

# Activate virtual environment
# Windows:
venv\Scripts\activate
# Linux/macOS:
source venv/bin/activate

# Install in development mode
pip install -e .

# Run the application
file-extractor-gui
```

### Method 3: Direct Execution

```bash
# Navigate to FileExtractors folder
cd FileExtractors

# Run directly (requires Python in PATH)
python file_extractor.py
# or
python launch.py
```

## ✅ Verification

After installation, test with:

```bash
# Test installation
python test_installation.py

# Check if command is available
file-extractor-gui --help
```

## 🎯 What Gets Installed

- **Virtual Environment**: Isolated Python environment in `venv/` folder
- **System Commands**: `file-extractor` and `file-extractor-gui` available globally
- **Desktop Shortcut**: Quick access icon (Windows/Linux)
- **Shell Alias**: `file-extractor` command (Linux/macOS)
- **Configuration**: Settings saved to `~/.file_extractor_config.json`

## 🚪 Running the Application

### After Installation
```bash
# GUI version (recommended)
file-extractor-gui

# Command line version
file-extractor
```

### From Source
```bash
# Direct execution
python file_extractor.py
python launch.py
```

## 🔄 Updating

To update the application:

1. **Download** new version
2. **Replace** old files
3. **Reinstall**: Run installer again or `pip install -e .`
4. **Restart** application

## 🗑️ Uninstalling

### Windows
1. **Delete** the FileExtractors folder
2. **Remove** desktop shortcut manually
3. **Delete** virtual environment: `rmdir /s venv`

### Linux/macOS
1. **Delete** the FileExtractors folder
2. **Remove** desktop shortcut: `rm ~/Desktop/file-extractor.desktop`
3. **Remove** alias from shell profile
4. **Delete** virtual environment: `rm -rf venv`

## 🐛 Troubleshooting

### Common Issues

#### Python Not Found
```bash
# Check Python installation
python --version
python3 --version

# Install Python from https://python.org
```

#### Permission Denied
```bash
# Windows: Run as Administrator
# Linux/macOS: Use sudo
sudo ./install_unix.sh
```

#### Virtual Environment Issues
```bash
# Delete and recreate
rm -rf venv
python -m venv venv
source venv/bin/activate  # or venv\Scripts\activate on Windows
pip install -e .
```

#### Import Errors
```bash
# Test imports
python test_installation.py

# Check file structure
ls -la
```

### Getting Help

1. **Run diagnostics**: `python test_installation.py`
2. **Check Python version**: `python --version`
3. **Verify virtual environment**: `source venv/bin/activate`
4. **Test installation**: `file-extractor-gui --help`

## 📁 File Locations

### Application Files
- **Main Application**: `file_extractor.py`
- **Version Info**: `version.py`
- **Launcher**: `launch.py`
- **Test Script**: `test_installation.py`

### Configuration
- **User Settings**: `~/.file_extractor_config.json`
- **Virtual Environment**: `venv/` folder
- **Desktop Shortcut**: Desktop folder
- **Shell Alias**: `~/.bashrc`, `~/.zshrc`, or `~/.profile`

### Package Files
- **Setup Configuration**: `setup.py`
- **Package Manifest**: `MANIFEST.in`
- **Dependencies**: `requirements.txt`
- **License**: `LICENSE`
- **Documentation**: `README.md`

## 🔗 System Integration

### Windows
- **Start Menu**: Available as "File Extractor"
- **Desktop Shortcut**: Automatically created
- **PATH**: Virtual environment added to system PATH

### Linux/macOS
- **Applications Menu**: Available in system applications
- **Desktop Shortcut**: `.desktop` file created
- **Shell Integration**: Alias added to shell profile

## 📊 System Requirements

### Minimum
- **OS**: Windows 7+, macOS 10.12+, Ubuntu 16.04+
- **Python**: 3.6 or higher
- **RAM**: 512 MB
- **Storage**: 100 MB free space

### Recommended
- **OS**: Windows 10+, macOS 11+, Ubuntu 18.04+
- **Python**: 3.8 or higher
- **RAM**: 2 GB
- **Storage**: 500 MB free space

## 🎉 Success Indicators

Installation is successful when:
- ✅ `python test_installation.py` shows all tests passed
- ✅ `file-extractor-gui` command is available
- ✅ Desktop shortcut works (Windows/Linux)
- ✅ Application launches without errors
- ✅ Configuration file is created

## 📞 Support

If you encounter issues:
1. **Check** this installation guide
2. **Run** the test script: `python test_installation.py`
3. **Verify** Python version and file structure
4. **Check** system requirements and permissions
5. **Review** error messages for specific issues

---

**Happy File Extracting! 🎯📁✨**
