# File Extractor Desktop Shortcut Creator
# This script creates a desktop shortcut for the File Extractor application

param(
    [string]$InstallDir = $PWD,
    [string]$DesktopPath = "$env:USERPROFILE\Desktop"
)

try {
    # Create WScript Shell object
    $WshShell = New-Object -comObject WScript.Shell
    
    # Define shortcut path
    $ShortcutPath = "$DesktopPath\File Extractor.lnk"
    
    # Create shortcut object
    $Shortcut = $WshShell.CreateShortcut($ShortcutPath)
    
    # Set shortcut properties
    $Shortcut.TargetPath = "$InstallDir\venv\Scripts\file-extractor-gui.exe"
    $Shortcut.WorkingDirectory = $InstallDir
    $Shortcut.IconLocation = "$InstallDir\venv\Scripts\python.exe"
    $Shortcut.Description = "File Extractor - Custom File Types"
    
    # Save the shortcut
    $Shortcut.Save()
    
    Write-Host "Desktop shortcut created successfully at: $ShortcutPath" -ForegroundColor Green
    
    # Verify the shortcut was created
    if (Test-Path $ShortcutPath) {
        Write-Host "Shortcut verification: PASSED" -ForegroundColor Green
    } else {
        Write-Host "Shortcut verification: FAILED" -ForegroundColor Red
    }
    
} catch {
    Write-Host "Error creating shortcut: $($_.Exception.Message)" -ForegroundColor Red
    
    # Fallback: Create a simple batch file shortcut
    try {
        $BatchPath = "$DesktopPath\File Extractor.bat"
        $BatchContent = @"
@echo off
cd /d "$InstallDir"
call venv\Scripts\activate.bat
file-extractor-gui
pause
"@
        
        $BatchContent | Out-File -FilePath $BatchPath -Encoding ASCII
        Write-Host "Created fallback batch file shortcut at: $BatchPath" -ForegroundColor Yellow
        
    } catch {
        Write-Host "Failed to create fallback shortcut: $($_.Exception.Message)" -ForegroundColor Red
    }
}
