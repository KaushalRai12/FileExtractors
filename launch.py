#!/usr/bin/env python3
"""
File Extractor Launcher
Simple script to launch the File Extractor application
"""

import sys
import os
from pathlib import Path

def main():
    # Get the directory where this script is located
    script_dir = Path(__file__).parent.absolute()
    
    # Add the script directory to Python path
    if str(script_dir) not in sys.path:
        sys.path.insert(0, str(script_dir))
    
    try:
        # Import and run the main application
        from file_extractor import main as app_main
        app_main()
    except ImportError as e:
        print(f"Error importing file_extractor: {e}")
        print("Make sure file_extractor.py is in the same directory as this launcher.")
        input("Press Enter to exit...")
        sys.exit(1)
    except Exception as e:
        print(f"Error running File Extractor: {e}")
        input("Press Enter to exit...")
        sys.exit(1)

if __name__ == "__main__":
    main()
