# File Extractor Application

A Python-based GUI application that recursively scans directories for multiple file types and allows you to extract them to a destination folder while automatically excluding `node_modules` and other unwanted directories.

## Features

- **Recursive File Scanning**: Automatically finds multiple file types in subdirectories
- **Modern GUI**: Clean, intuitive interface built with tkinter
- **File Preview**: View all found files with their paths and sizes before extraction
- **Flexible Destination**: Choose any folder to save extracted files
- **Duplicate Handling**: Automatically handles duplicate filenames by adding counters
- **Progress Tracking**: Visual progress indicators during scanning and extraction
- **Error Handling**: Comprehensive error reporting and recovery
- **Threading**: Non-blocking operations for better user experience
- **Structure Reporting**: Automatically creates detailed folder structure reports
- **Text Conversion**: Optional conversion of all files to .txt format for easy reading

## Requirements

- **Python 3.6 or higher**
- **No external packages required** - uses only Python standard library

## Installation

1. **Clone or download** this repository to your local machine
2. **Ensure Python 3.6+** is installed on your system
3. **No additional setup required** - all dependencies are built-in

## Usage

### Running the Application

```bash
python file_extractor.py
```

### Step-by-Step Guide

1. **Launch the Application**
   - Run `python file_extractor.py`
   - The application window will open with a clean interface

2. **Select Source Directory**
   - Click "Browse" next to "Source Directory"
   - Navigate to the folder containing your project files
   - Click "Select Folder"

3. **Select Destination Directory**
   - Click "Browse" next to "Destination"
   - Choose where you want to save the extracted files
   - Click "Select Folder"

4. **Choose Conversion Option (Optional)**
   - Check "Convert all files to .txt format" if you want text-based files
   - Leave unchecked to preserve original file formats

5. **Scan for Files**
   - Click "Scan for Files" button
   - The application will recursively search for multiple file types
   - Progress bar shows scanning activity

6. **Review Found Files**
   - View all discovered files in the results table
   - See file names, relative paths, and sizes
   - Verify the files you want to extract

7. **Extract Files**
   - Click "Extract Files" button
   - Confirm the extraction when prompted
   - Files will be copied to your destination folder
   - A folder structure report will be automatically created

## File Types Supported

- **`.py`** - Python files
- **`.env`** - Environment configuration files
- **`.yml`** / **`.yaml`** - YAML configuration files
- **`.json`** - JSON configuration and data files
- **`.tsx`** - TypeScript React component files
- **`.ts`** - TypeScript files
- **`Dockerfile`** - Docker configuration files

## Excluded Directories

- **`node_modules`** - Automatically skipped to avoid extracting dependency files

## Text Conversion Feature

When the "Convert all files to .txt format" checkbox is enabled:
- **All files are converted** to plain text format (.txt extension)
- **Original file content** is preserved and readable
- **Metadata headers** are added showing original filename and path
- **Universal compatibility** - text files can be opened in any text editor
- **Easy documentation** - perfect for creating readable backups
- **Encoding handling** - automatically detects and converts various text encodings

**Note**: When disabled, files maintain their original formats and extensions.

## Features in Detail

### Recursive Scanning
- Searches through all subdirectories automatically
- Handles nested folder structures of any depth
- Efficient file discovery using Python's `pathlib`

### Smart File Handling
- Preserves original file metadata (timestamps, permissions)
- Automatically handles duplicate filenames
- Creates destination folders if they don't exist
- Generates comprehensive folder structure reports

### User Experience
- Non-blocking operations using threading
- Real-time progress updates
- Clear status messages and error reporting
- Responsive interface during long operations

### Error Handling
- Graceful handling of permission errors
- File access validation
- Comprehensive error reporting
- Continues processing even if individual files fail

## Troubleshooting

### Common Issues

1. **"No matching files found"**
   - Verify your source directory contains the supported file types
   - Check file extensions (case-sensitive on some systems)

2. **Permission Denied Errors**
   - Ensure you have read access to source directory
   - Ensure you have write access to destination directory

3. **Application Not Responding**
   - Large directories may take time to scan
   - Progress bar indicates activity
   - Wait for operation to complete

### Performance Tips

- **Large Projects**: Scanning very large directories may take time
- **Network Drives**: Local directories scan faster than network locations
- **File Count**: Applications with thousands of files may take longer

## Technical Details

### Architecture
- **GUI Framework**: tkinter with ttk widgets
- **File Operations**: pathlib and shutil for cross-platform compatibility
- **Threading**: Separate threads for file operations to prevent UI freezing
- **Error Handling**: Comprehensive exception handling with user feedback

### File Operations
- **Copy Method**: Uses `shutil.copy2()` to preserve metadata
- **Path Handling**: Cross-platform path handling with `pathlib.Path`
- **Duplicate Resolution**: Automatic filename conflict resolution

## Customization

### Adding New File Types
To support additional file extensions, modify the `target_extensions` set in the `_scan_files_thread` method:

```python
target_extensions = {'.py', '.env', '.yml', '.yaml', '.json', '.tsx', '.ts', 'Dockerfile'}  # Add more extensions
```

### Excluding Directories
To exclude additional directories, add them to the exclusion check:

```python
# Skip unwanted directories
if 'node_modules' in file_path.parts or 'dist' in file_path.parts:
    continue
```

### Folder Structure Reports
The application automatically creates detailed reports showing:
- Complete directory structure
- File locations and organization
- File counts by type
- Relative paths for easy navigation
- Timestamped reports for tracking changes

### UI Modifications
The application uses a grid-based layout that's easy to modify:
- Change colors in the style configuration
- Adjust window dimensions
- Modify button text and functionality

## License

This application is provided as-is for educational and personal use.

## Support

For issues or questions:
1. Check the troubleshooting section above
2. Verify Python version compatibility
3. Ensure proper file permissions
4. Check that source and destination paths are valid

## Future Enhancements

Potential improvements could include:
- Support for more file types
- File filtering options
- Batch processing capabilities
- Export/import of file lists
- Advanced search patterns
- File content preview
