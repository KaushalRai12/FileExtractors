#!/usr/bin/env python3
"""
Test script to verify File Extractor installation
"""

import sys
import os
from pathlib import Path

def test_imports():
    """Test if all required modules can be imported"""
    print("Testing imports...")
    
    try:
        import tkinter
        print("✓ tkinter imported successfully")
    except ImportError as e:
        print(f"✗ Failed to import tkinter: {e}")
        return False
    
    try:
        from file_extractor import FileExtractorApp
        print("✓ FileExtractorApp imported successfully")
    except ImportError as e:
        print(f"✗ Failed to import FileExtractorApp: {e}")
        return False
    
    try:
        from version import __version__
        print(f"✓ Version imported: {__version__}")
    except ImportError as e:
        print(f"✗ Failed to import version: {e}")
        return False
    
    return True

def test_file_structure():
    """Test if all required files exist"""
    print("\nTesting file structure...")
    
    required_files = [
        'file_extractor.py',
        'version.py',
        'setup.py',
        'README.md',
        'LICENSE',
        'requirements.txt'
    ]
    
    missing_files = []
    for file in required_files:
        if Path(file).exists():
            print(f"✓ {file} found")
        else:
            print(f"✗ {file} missing")
            missing_files.append(file)
    
    return len(missing_files) == 0

def test_python_version():
    """Test Python version compatibility"""
    print("\nTesting Python version...")
    
    version = sys.version_info
    if version.major >= 3 and version.minor >= 6:
        print(f"✓ Python {version.major}.{version.minor} is compatible")
        return True
    else:
        print(f"✗ Python {version.major}.{version.minor} is not compatible (3.6+ required)")
        return False

def main():
    """Run all tests"""
    print("=" * 50)
    print("File Extractor Installation Test")
    print("=" * 50)
    
    tests_passed = 0
    total_tests = 3
    
    # Test Python version
    if test_python_version():
        tests_passed += 1
    
    # Test file structure
    if test_file_structure():
        tests_passed += 1
    
    # Test imports
    if test_imports():
        tests_passed += 1
    
    print("\n" + "=" * 50)
    print(f"Test Results: {tests_passed}/{total_tests} tests passed")
    
    if tests_passed == total_tests:
        print("✓ All tests passed! Installation appears successful.")
        print("\nYou can now run the application using:")
        print("  python file_extractor.py")
        print("  python launch.py")
        print("  file-extractor-gui (after pip install -e .)")
    else:
        print("✗ Some tests failed. Please check the errors above.")
        print("\nTroubleshooting:")
        print("1. Ensure all files are in the same directory")
        print("2. Check Python version (3.6+ required)")
        print("3. Verify file permissions")
        print("4. Try reinstalling the application")
    
    print("=" * 50)

if __name__ == "__main__":
    main()
