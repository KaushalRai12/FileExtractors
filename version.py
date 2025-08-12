"""
Version information for File Extractor
"""

__version__ = "2.0.0"
__author__ = "File Extractor Team"
__description__ = "A GUI application for extracting files by type with custom filtering"

def get_version():
    """Get the current version string"""
    return __version__

def get_version_info():
    """Get version information as a dictionary"""
    return {
        'version': __version__,
        'author': __author__,
        'description': __description__
    }
