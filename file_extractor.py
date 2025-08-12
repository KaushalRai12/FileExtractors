import tkinter as tk
from tkinter import ttk, filedialog, messagebox
import os
import shutil
from pathlib import Path
import threading
import json
from version import __version__

class FileExtractorApp:
    def __init__(self, root):
        self.root = root
        self.root.title(f"File Extractor - Custom File Types v{__version__}")
        self.root.geometry("900x700")
        self.root.configure(bg='#f0f0f0')
        
        # Variables
        self.source_path = tk.StringVar()
        self.destination_path = tk.StringVar()
        self.convert_to_txt = tk.BooleanVar()
        self.found_files = []
        self.extraction_running = False
        
        # File type configuration
        self.file_types = {
            'Python': ['.py', '.pyw', '.pyx', '.pxd'],
            'Environment': ['.env', '.env.local', '.env.production', '.env.development'],
            'YAML': ['.yml', '.yaml'],
            'JSON': ['.json', '.jsonc'],
            'TypeScript': ['.ts', '.tsx'],
            'JavaScript': ['.js', '.jsx', '.mjs'],
            'HTML/CSS': ['.html', '.htm', '.css', '.scss', '.sass'],
            'Markdown': ['.md', '.markdown'],
            'Docker': ['Dockerfile', '.dockerignore'],
            'Shell': ['.sh', '.bash', '.zsh', '.fish'],
            'Config': ['.ini', '.cfg', '.conf', '.config'],
            'XML': ['.xml', '.xsd', '.xsl'],
            'SQL': ['.sql', '.db', '.sqlite'],
            'Logs': ['.log', '.txt'],
            'Custom': []
        }
        
        # Load saved configuration
        self.load_config()
        
        self.setup_ui()
        
    def setup_ui(self):
        # Main frame
        main_frame = ttk.Frame(self.root, padding="20")
        main_frame.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
        
        # Configure grid weights
        self.root.columnconfigure(0, weight=1)
        self.root.rowconfigure(0, weight=1)
        main_frame.columnconfigure(1, weight=1)
        
        # Title
        title_label = ttk.Label(main_frame, text="File Extractor - Custom File Types", 
                               font=('Arial', 24, 'bold'))
        title_label.grid(row=0, column=0, columnspan=3, pady=(0, 20))
        
        # Source directory selection
        ttk.Label(main_frame, text="Source Directory:", 
                 font=('Arial', 12, 'bold')).grid(row=1, column=0, sticky=tk.W, pady=5)
        
        source_frame = ttk.Frame(main_frame)
        source_frame.grid(row=1, column=1, columnspan=2, sticky=(tk.W, tk.E), pady=5)
        source_frame.columnconfigure(0, weight=1)
        
        self.source_entry = ttk.Entry(source_frame, textvariable=self.source_path, 
                                     font=('Arial', 10))
        self.source_entry.grid(row=0, column=0, sticky=(tk.W, tk.E), padx=(0, 10))
        
        browse_btn = ttk.Button(source_frame, text="Browse", 
                               command=self.browse_source, style='Accent.TButton')
        browse_btn.grid(row=0, column=1)
        
        # Destination directory selection
        ttk.Label(main_frame, text="Destination:", 
                 font=('Arial', 12, 'bold')).grid(row=2, column=0, sticky=tk.W, pady=5)
        
        dest_frame = ttk.Frame(main_frame)
        dest_frame.grid(row=2, column=1, columnspan=2, sticky=(tk.W, tk.E), pady=5)
        dest_frame.columnconfigure(0, weight=1)
        
        self.dest_entry = ttk.Entry(dest_frame, textvariable=self.destination_path, 
                                    font=('Arial', 10))
        self.dest_entry.grid(row=0, column=0, sticky=(tk.W, tk.E), padx=(0, 10))
        
        dest_browse_btn = ttk.Button(dest_frame, text="Browse", 
                                     command=self.browse_destination, style='Accent.TButton')
        dest_browse_btn.grid(row=0, column=1)
        
        # File Type Selection Frame
        file_types_frame = ttk.LabelFrame(main_frame, text="Select File Types to Extract", padding="10")
        file_types_frame.grid(row=3, column=0, columnspan=3, sticky=(tk.W, tk.E), pady=10)
        file_types_frame.columnconfigure(0, weight=1)
        
        # Create checkboxes for file types
        self.file_type_vars = {}
        row = 0
        col = 0
        max_cols = 3
        
        for file_type, extensions in self.file_types.items():
            if file_type == 'Custom':
                continue
                
            var = tk.BooleanVar(value=True)  # Default to checked
            self.file_type_vars[file_type] = var
            
            cb = ttk.Checkbutton(file_types_frame, 
                                text=f"{file_type} ({', '.join(extensions)})", 
                                variable=var)
            cb.grid(row=row, column=col, sticky=tk.W, padx=5, pady=2)
            
            col += 1
            if col >= max_cols:
                col = 0
                row += 1
        
        # Custom file types input
        custom_frame = ttk.Frame(file_types_frame)
        custom_frame.grid(row=row+1, column=0, columnspan=max_cols, sticky=(tk.W, tk.E), pady=10)
        custom_frame.columnconfigure(0, weight=1)
        
        ttk.Label(custom_frame, text="Custom Extensions (comma-separated):", 
                 font=('Arial', 10, 'bold')).grid(row=0, column=0, sticky=tk.W, pady=5)
        
        self.custom_extensions = tk.StringVar(value=".csv,.xml,.sql,.conf")
        custom_entry = ttk.Entry(custom_frame, textvariable=self.custom_extensions, 
                                font=('Arial', 10))
        custom_entry.grid(row=1, column=0, sticky=(tk.W, tk.E), padx=(0, 10))
        
        # Convert to TXT checkbox
        convert_frame = ttk.Frame(main_frame)
        convert_frame.grid(row=4, column=0, columnspan=3, sticky=(tk.W, tk.E), pady=10)
        
        self.convert_checkbox = ttk.Checkbutton(convert_frame, 
                                               text="Convert all files to .txt format", 
                                               variable=self.convert_to_txt,
                                               style='Accent.TCheckbutton')
        self.convert_checkbox.grid(row=0, column=0, sticky=tk.W)
        
        # Scan button
        scan_btn = ttk.Button(main_frame, text="Scan for Files", 
                             command=self.scan_files, style='Accent.TButton')
        scan_btn.grid(row=5, column=0, columnspan=3, pady=20)
        
        # Progress bar
        self.progress = ttk.Progressbar(main_frame, mode='indeterminate')
        self.progress.grid(row=6, column=0, columnspan=3, sticky=(tk.W, tk.E), pady=10)
        
        # Results frame
        results_frame = ttk.LabelFrame(main_frame, text="Found Files", padding="10")
        results_frame.grid(row=7, column=0, columnspan=3, sticky=(tk.W, tk.E, tk.N, tk.S), pady=10)
        results_frame.columnconfigure(0, weight=1)
        results_frame.rowconfigure(0, weight=1)
        
        # Treeview for files
        columns = ('File Name', 'Path', 'Size', 'Type')
        self.tree = ttk.Treeview(results_frame, columns=columns, show='headings', height=10)
        
        # Configure columns
        self.tree.heading('File Name', text='File Name')
        self.tree.heading('Path', text='Relative Path')
        self.tree.heading('Size', text='Size (KB)')
        self.tree.heading('Type', text='File Type')
        
        self.tree.column('File Name', width=200)
        self.tree.column('Path', width=300)
        self.tree.column('Size', width=80)
        self.tree.column('Type', width=100)
        
        # Scrollbar for treeview
        tree_scrollbar = ttk.Scrollbar(results_frame, orient=tk.VERTICAL, command=self.tree.yview)
        self.tree.configure(yscrollcommand=tree_scrollbar.set)
        
        self.tree.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
        tree_scrollbar.grid(row=0, column=1, sticky=(tk.N, tk.S))
        
        # Status label
        self.status_label = ttk.Label(main_frame, text="Ready to scan", 
                                     font=('Arial', 10))
        self.status_label.grid(row=8, column=0, columnspan=3, pady=10)
        
        # Extract button
        self.extract_btn = ttk.Button(main_frame, text="Extract Files", 
                                     command=self.extract_files, style='Accent.TButton', state='disabled')
        self.extract_btn.grid(row=9, column=0, columnspan=3, pady=10)
        
        # Configure grid weights for main frame
        main_frame.rowconfigure(7, weight=1)
        
    def get_selected_extensions(self):
        """Get all selected file extensions based on checkboxes and custom input"""
        extensions = set()
        
        # Add extensions from checked file types
        for file_type, var in self.file_type_vars.items():
            if var.get():
                extensions.update(self.file_types[file_type])
        
        # Add custom extensions
        custom_text = self.custom_extensions.get().strip()
        if custom_text:
            custom_exts = [ext.strip() for ext in custom_text.split(',') if ext.strip()]
            extensions.update(custom_exts)
        
        return extensions
        
    def load_config(self):
        """Load saved configuration from file"""
        config_file = Path.home() / '.file_extractor_config.json'
        if config_file.exists():
            try:
                with open(config_file, 'r') as f:
                    config = json.load(f)
                    
                # Load saved paths
                if 'source_path' in config:
                    self.source_path.set(config['source_path'])
                if 'destination_path' in config:
                    self.destination_path.set(config['destination_path'])
                    
                # Load saved file type selections
                if 'file_type_selections' in config:
                    for file_type, selected in config['file_type_selections'].items():
                        if file_type in self.file_type_vars:
                            self.file_type_vars[file_type].set(selected)
                            
                # Load custom extensions
                if 'custom_extensions' in config:
                    self.custom_extensions.set(config['custom_extensions'])
                    
            except Exception as e:
                print(f"Warning: Could not load configuration: {e}")
                
    def save_config(self):
        """Save current configuration to file"""
        config_file = Path.home() / '.file_extractor_config.json'
        try:
            config = {
                'source_path': self.source_path.get(),
                'destination_path': self.destination_path.get(),
                'file_type_selections': {ft: var.get() for ft, var in self.file_type_vars.items()},
                'custom_extensions': self.custom_extensions.get()
            }
            
            with open(config_file, 'w') as f:
                json.dump(config, f, indent=2)
                
        except Exception as e:
            print(f"Warning: Could not save configuration: {e}")
            
    def browse_source(self):
        directory = filedialog.askdirectory(title="Select Source Directory")
        if directory:
            self.source_path.set(directory)
            self.save_config()
            
    def browse_destination(self):
        directory = filedialog.askdirectory(title="Select Destination Directory")
        if directory:
            self.destination_path.set(directory)
            self.save_config()
            
    def scan_files(self):
        source = self.source_path.get().strip()
        if not source:
            messagebox.showerror("Error", "Please select a source directory")
            return
            
        if not os.path.exists(source):
            messagebox.showerror("Error", "Source directory does not exist")
            return
            
        # Get selected extensions
        target_extensions = self.get_selected_extensions()
        if not target_extensions:
            messagebox.showerror("Error", "Please select at least one file type to extract")
            return
            
        # Clear previous results
        self.tree.delete(*self.tree.get_children())
        self.found_files = []
        
        # Start scanning in a separate thread
        self.extraction_running = True
        self.progress.start()
        self.status_label.config(text=f"Scanning for {len(target_extensions)} file types...")
        self.extract_btn.config(state='disabled')
        
        scan_thread = threading.Thread(target=self._scan_files_thread, args=(source, target_extensions))
        scan_thread.daemon = True
        scan_thread.start()
        
    def _scan_files_thread(self, source, target_extensions):
        try:
            source_path = Path(source)
            
            for file_path in source_path.rglob('*'):
                # Skip node_modules folders and other common exclusions
                if any(exclude in file_path.parts for exclude in ['node_modules', '.git', '__pycache__', '.pytest_cache']):
                    continue
                    
                if file_path.is_file():
                    # Check if file matches our target extensions
                    file_suffix = file_path.suffix.lower()
                    file_name = file_path.name
                    
                    # Check if file matches any target extension or filename
                    matches = False
                    file_type = "Unknown"
                    
                    for ext in target_extensions:
                        if ext.startswith('.'):
                            # Extension match
                            if file_suffix == ext.lower():
                                matches = True
                                file_type = ext
                                break
                        else:
                            # Filename match (e.g., Dockerfile)
                            if file_name == ext:
                                matches = True
                                file_type = ext
                                break
                    
                    if matches:
                        relative_path = file_path.relative_to(source_path)
                        size_kb = file_path.stat().st_size / 1024
                        
                        self.found_files.append({
                            'source': str(file_path),
                            'relative': str(relative_path),
                            'name': file_path.name,
                            'size': size_kb,
                            'type': file_type
                        })
            
            # Update UI in main thread
            self.root.after(0, self._update_scan_results)
            
        except Exception as e:
            self.root.after(0, lambda: self._show_error(f"Error during scanning: {str(e)}"))
        finally:
            self.root.after(0, self._finish_scan)
            
    def _update_scan_results(self):
        for file_info in self.found_files:
            self.tree.insert('', 'end', values=(
                file_info['name'],
                file_info['relative'],
                f"{file_info['size']:.1f}",
                file_info['type']
            ))
            
    def _finish_scan(self):
        self.progress.stop()
        self.extraction_running = False
        
        if self.found_files:
            self.status_label.config(text=f"Found {len(self.found_files)} files")
            self.extract_btn.config(state='normal')
        else:
            self.status_label.config(text="No matching files found")
            self.extract_btn.config(state='disabled')
            
    def _show_error(self, message):
        self.progress.stop()
        self.extraction_running = False
        self.status_label.config(text="Error occurred")
        messagebox.showerror("Error", message)
        
    def extract_files(self):
        destination = self.destination_path.get().strip()
        if not destination:
            messagebox.showerror("Error", "Please select a destination directory")
            return
            
        if not self.found_files:
            messagebox.showerror("Error", "No files to extract")
            return
            
        # Confirm extraction
        result = messagebox.askyesno("Confirm Extraction", 
                                   f"Extract {len(self.found_files)} files to {destination}?")
        if not result:
            return
            
        # Start extraction in a separate thread
        self.extraction_running = True
        self.progress.start()
        self.status_label.config(text="Extracting files...")
        self.extract_btn.config(state='disabled')
        
        extract_thread = threading.Thread(target=self._extract_files_thread, args=(destination,))
        extract_thread.daemon = True
        extract_thread.start()
        
    def _extract_files_thread(self, destination):
        try:
            dest_path = Path(destination)
            dest_path.mkdir(parents=True, exist_ok=True)
            
            extracted_count = 0
            errors = []
            convert_to_txt = self.convert_to_txt.get()
            
            # Create folder structure report
            structure_report = self._create_folder_structure_report()
            report_filename = f"folder-structure-{self._get_timestamp()}.txt"
            report_path = dest_path / report_filename
            
            try:
                with open(report_path, 'w', encoding='utf-8') as f:
                    f.write(structure_report)
                print(f"Created structure report: {report_filename}")
            except Exception as e:
                print(f"Warning: Could not create structure report: {e}")
            
            for file_info in self.found_files:
                try:
                    source_file = Path(file_info['source'])
                    
                    if convert_to_txt:
                        # Convert to .txt format
                        dest_file = dest_path / f"{source_file.stem}.txt"
                    else:
                        # Keep original format
                        dest_file = dest_path / file_info['name']
                    
                    # Handle duplicate filenames
                    counter = 1
                    original_dest = dest_file
                    while dest_file.exists():
                        stem = original_dest.stem
                        suffix = original_dest.suffix
                        dest_file = dest_path / f"{stem}_{counter}{suffix}"
                        counter += 1
                    
                    if convert_to_txt:
                        # Convert file content to text
                        self._convert_file_to_txt(source_file, dest_file)
                    else:
                        # Copy file as-is
                        shutil.copy2(source_file, dest_file)
                    
                    extracted_count += 1
                    
                except Exception as e:
                    errors.append(f"{file_info['name']}: {str(e)}")
                    
            # Update UI in main thread
            self.root.after(0, lambda: self._finish_extraction(extracted_count, errors))
            
        except Exception as e:
            self.root.after(0, lambda: self._show_error(f"Error during extraction: {str(e)}"))
            
    def _finish_extraction(self, extracted_count, errors):
        self.progress.stop()
        self.extraction_running = False
        self.extract_btn.config(state='normal')
        
        if errors:
            error_message = f"Extracted {extracted_count} files successfully.\n\nErrors:\n" + "\n".join(errors[:10])
            if len(errors) > 10:
                error_message += f"\n... and {len(errors) - 10} more errors"
            messagebox.showwarning("Extraction Complete with Errors", error_message)
        else:
            conversion_status = " (converted to .txt format)" if self.convert_to_txt.get() else ""
            messagebox.showinfo("Success", f"Successfully extracted {extracted_count} files{conversion_status} to destination folder!\n\nA folder structure report has been created as 'folder-structure-[timestamp].txt'")
            
        self.status_label.config(text=f"Extracted {extracted_count} files")
    
    def _convert_file_to_txt(self, source_file, dest_file):
        """Convert a file to text format"""
        try:
            # Try to read the file as text with different encodings
            encodings = ['utf-8', 'latin-1', 'cp1252', 'iso-8859-1']
            content = None
            
            for encoding in encodings:
                try:
                    with open(source_file, 'r', encoding=encoding) as f:
                        content = f.read()
                    break
                except UnicodeDecodeError:
                    continue
            
            if content is None:
                # If all text encodings fail, try to read as binary and convert
                with open(source_file, 'rb') as f:
                    binary_content = f.read()
                    # Try to decode as text, replace invalid characters
                    content = binary_content.decode('utf-8', errors='replace')
            
            # Write the content as text
            with open(dest_file, 'w', encoding='utf-8') as f:
                f.write(f"# Converted from: {source_file.name}\n")
                f.write(f"# Original path: {source_file}\n")
                f.write(f"# Conversion time: {self._get_timestamp()}\n")
                f.write("=" * 80 + "\n\n")
                f.write(content)
                
        except Exception as e:
            # If conversion fails, create a text file with error information
            with open(dest_file, 'w', encoding='utf-8') as f:
                f.write(f"# Error converting file: {source_file.name}\n")
                f.write(f"# Error: {str(e)}\n")
                f.write(f"# Original path: {source_file}\n")
                f.write(f"# Conversion time: {self._get_timestamp()}\n")
                f.write("=" * 80 + "\n\n")
                f.write(f"Could not convert {source_file.name} to text format.\n")
                f.write(f"Error: {str(e)}\n")
    
    def _create_folder_structure_report(self):
        """Create a detailed folder structure report"""
        if not self.found_files:
            return "No files found to report."
        
        # Get source directory from first file
        source_dir = Path(self.found_files[0]['source']).parent
        for file_info in self.found_files:
            file_path = Path(file_info['source'])
            if file_path.parent != source_dir:
                source_dir = file_path.parents[-1]  # Get the root source directory
                break
        
        report_lines = []
        report_lines.append("=" * 80)
        report_lines.append("FOLDER STRUCTURE REPORT")
        report_lines.append("=" * 80)
        report_lines.append(f"Generated: {self._get_timestamp()}")
        report_lines.append(f"Source Directory: {source_dir}")
        report_lines.append(f"Total Files Found: {len(self.found_files)}")
        report_lines.append("")
        
        # Group files by directory
        dir_structure = {}
        for file_info in self.found_files:
            relative_path = Path(file_info['relative'])
            parent_dir = str(relative_path.parent) if relative_path.parent != Path('.') else "Root"
            
            if parent_dir not in dir_structure:
                dir_structure[parent_dir] = []
            
            dir_structure[parent_dir].append({
                'name': file_info['name'],
                'size': file_info['size'],
                'full_path': file_info['relative'],
                'type': file_info['type']
            })
        
        # Sort directories and create report
        for directory in sorted(dir_structure.keys()):
            if directory == "Root":
                report_lines.append("📁 ROOT DIRECTORY")
            else:
                report_lines.append(f"📁 {directory}/")
            
            # Sort files in each directory
            files_in_dir = sorted(dir_structure[directory], key=lambda x: x['name'])
            for file_info in files_in_dir:
                size_str = f"{file_info['size']:.1f} KB"
                type_str = f" ({file_info['type']})"
                report_lines.append(f"   📄 {file_info['name']} ({size_str}){type_str}")
            
            report_lines.append("")
        
        # Add summary
        report_lines.append("-" * 80)
        report_lines.append("SUMMARY")
        report_lines.append("-" * 80)
        
        # Count files by type
        type_counts = {}
        for file_info in self.found_files:
            file_type = file_info['type']
            type_counts[file_type] = type_counts.get(file_type, 0) + 1
        
        for file_type, count in sorted(type_counts.items()):
            report_lines.append(f"{file_type}: {count}")
        
        report_lines.append(f"Total files: {len(self.found_files)}")
        report_lines.append("")
        report_lines.append("File locations preserved in relative paths above.")
        
        return "\n".join(report_lines)
    
    def _get_timestamp(self):
        """Get current timestamp in a filename-friendly format"""
        from datetime import datetime
        now = datetime.now()
        return now.strftime("%Y%m%d-%H%M%S")

def main():
    root = tk.Tk()
    
    # Configure styles
    style = ttk.Style()
    style.theme_use('clam')
    
    # Custom button style
    style.configure('Accent.TButton', 
                   background='#0078d4', 
                   foreground='white',
                   font=('Arial', 10, 'bold'))
    
    # Custom checkbox style
    style.configure('Accent.TCheckbutton', 
                   font=('Arial', 10))
    
    app = FileExtractorApp(root)
    
    # Center window
    root.update_idletasks()
    x = (root.winfo_screenwidth() // 2) - (root.winfo_width() // 2)
    y = (root.winfo_screenheight() // 2) - (root.winfo_height() // 2)
    root.geometry(f"+{x}+{y}")
    
    root.mainloop()

if __name__ == "__main__":
    main()
