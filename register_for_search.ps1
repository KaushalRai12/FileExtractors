# File Extractor - Windows Search Registration
# This script makes File Extractor discoverable in Windows Search

param(
    [string]$InstallDir = $PWD
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "File Extractor - Windows Search Registration" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if virtual environment exists
if (-not (Test-Path "$InstallDir\venv\Scripts\file-extractor-gui.exe")) {
    Write-Host "ERROR: File Extractor not found!" -ForegroundColor Red
    Write-Host "Please run the installer first: install_windows.bat" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "This script will make File Extractor appear in Windows Search." -ForegroundColor Yellow
Write-Host "The app will be discoverable when you search for 'File Extractor'." -ForegroundColor Yellow
Write-Host ""

# Get paths
$Desktop = [Environment]::GetFolderPath("Desktop")
$StartMenu = [Environment]::GetFolderPath("StartMenu")
$Startup = [Environment]::GetFolderPath("Startup")

Write-Host "Installation Directory: $InstallDir" -ForegroundColor Green
Write-Host "Desktop Directory: $Desktop" -ForegroundColor Green
Write-Host "Start Menu: $StartMenu" -ForegroundColor Green
Write-Host ""

try {
    # Create Start Menu shortcut (this makes it searchable)
    Write-Host "Creating Start Menu shortcut..." -ForegroundColor Yellow
    $StartMenuFolder = "$StartMenu\File Extractor"
    if (-not (Test-Path $StartMenuFolder)) {
        New-Item -ItemType Directory -Path $StartMenuFolder -Force | Out-Null
    }
    
    $StartMenuShortcut = "$StartMenuFolder\File Extractor.lnk"
    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($StartMenuShortcut)
    $Shortcut.TargetPath = "$InstallDir\venv\Scripts\file-extractor-gui.exe"
    $Shortcut.WorkingDirectory = $InstallDir
    $Shortcut.IconLocation = "$InstallDir\venv\Scripts\python.exe"
    $Shortcut.Description = "File Extractor - Custom File Types"
    $Shortcut.Save()
    
    # Create desktop shortcut
    Write-Host "Creating desktop shortcut..." -ForegroundColor Yellow
    $DesktopShortcut = "$Desktop\File Extractor.lnk"
    $Shortcut = $WshShell.CreateShortcut($DesktopShortcut)
    $Shortcut.TargetPath = "$InstallDir\venv\Scripts\file-extractor-gui.exe"
    $Shortcut.WorkingDirectory = $InstallDir
    $Shortcut.IconLocation = "$InstallDir\venv\Scripts\python.exe"
    $Shortcut.Description = "File Extractor - Custom File Types"
    $Shortcut.Save()
    
    # Create startup shortcut
    Write-Host "Creating startup shortcut..." -ForegroundColor Yellow
    $StartupShortcut = "$Startup\File Extractor.lnk"
    $Shortcut = $WshShell.CreateShortcut($StartupShortcut)
    $Shortcut.TargetPath = "$InstallDir\venv\Scripts\file-extractor-gui.exe"
    $Shortcut.WorkingDirectory = $InstallDir
    $Shortcut.IconLocation = "$InstallDir\venv\Scripts\python.exe"
    $Shortcut.Description = "File Extractor - Custom File Types"
    $Shortcut.Save()
    
    # Verify shortcuts were created
    Write-Host ""
    Write-Host "Verifying shortcuts..." -ForegroundColor Yellow
    
    if (Test-Path $StartMenuShortcut) {
        Write-Host "✓ Start Menu shortcut created" -ForegroundColor Green
    } else {
        Write-Host "✗ Start Menu shortcut failed" -ForegroundColor Red
    }
    
    if (Test-Path $DesktopShortcut) {
        Write-Host "✓ Desktop shortcut created" -ForegroundColor Green
    } else {
        Write-Host "✗ Desktop shortcut failed" -ForegroundColor Red
    }
    
    if (Test-Path $StartupShortcut) {
        Write-Host "✓ Startup shortcut created" -ForegroundColor Green
    } else {
        Write-Host "✗ Startup shortcut failed" -ForegroundColor Red
    }
    
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "Registration Complete!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "File Extractor should now appear in:" -ForegroundColor White
    Write-Host "1. Windows Search (press Win key, type 'File Extractor')" -ForegroundColor White
    Write-Host "2. Start Menu → All Apps → File Extractor" -ForegroundColor White
    Write-Host "3. Desktop shortcut" -ForegroundColor White
    Write-Host "4. Automatic startup when you log in" -ForegroundColor White
    Write-Host ""
    Write-Host "To test: Press Win key and type 'File Extractor'" -ForegroundColor Yellow
    Write-Host ""
    
    # Test if the app can be found
    Write-Host "Testing Windows Search registration..." -ForegroundColor Yellow
    $startApps = Get-StartApps | Where-Object {$_.Name -like "*File Extractor*"}
    if ($startApps) {
        Write-Host "✓ App registered successfully!" -ForegroundColor Green
        Write-Host "Found: $($startApps.Name)" -ForegroundColor Green
    } else {
        Write-Host "⚠ App may take a few minutes to appear in search" -ForegroundColor Yellow
        Write-Host "Try refreshing the Start Menu or restarting Windows Explorer" -ForegroundColor Yellow
    }
    
} catch {
    Write-Host "Error during registration: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "Fallback: Creating simple batch file shortcuts..." -ForegroundColor Yellow
    
    # Create simple batch file shortcuts as fallback
    try {
        $batchContent = @"
@echo off
cd /d "$InstallDir"
venv\Scripts\Activate.ps1
file-extractor-gui
"@
        
        # Desktop batch file
        $batchContent | Out-File -FilePath "$Desktop\File Extractor.bat" -Encoding ASCII
        Write-Host "✓ Created desktop batch file shortcut" -ForegroundColor Green
        
        # Start Menu batch file
        if (-not (Test-Path "$StartMenu\File Extractor")) {
            New-Item -ItemType Directory -Path "$StartMenu\File Extractor" -Force | Out-Null
        }
        $batchContent | Out-File -FilePath "$StartMenu\File Extractor\File Extractor.bat" -Encoding ASCII
        Write-Host "✓ Created Start Menu batch file shortcut" -ForegroundColor Green
        
    } catch {
        Write-Host "✗ Failed to create fallback shortcuts: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Press Enter to exit..."
Read-Host
