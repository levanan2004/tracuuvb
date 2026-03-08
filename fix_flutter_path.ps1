# Script to move Flutter to a path without spaces
# Run this script as Administrator

Write-Host "=== Flutter Path Fix Script ===" -ForegroundColor Green
Write-Host ""

# Current Flutter path
$oldPath = "C:\Users\cunuo\Config IT\flutter"
$newPath = "C:\flutter"

# Check if old path exists
if (-Not (Test-Path $oldPath)) {
    Write-Host "Error: Flutter not found at $oldPath" -ForegroundColor Red
    Write-Host "Please update the oldPath variable in this script" -ForegroundColor Yellow
    exit 1
}

# Check if new path already exists
if (Test-Path $newPath) {
    Write-Host "Warning: $newPath already exists!" -ForegroundColor Yellow
    $response = Read-Host "Do you want to overwrite it? (yes/no)"
    if ($response -ne "yes") {
        Write-Host "Operation cancelled" -ForegroundColor Red
        exit 1
    }
    Remove-Item $newPath -Recurse -Force
}

# Move Flutter
Write-Host "Moving Flutter from:" -ForegroundColor Cyan
Write-Host "  $oldPath" -ForegroundColor White
Write-Host "To:" -ForegroundColor Cyan
Write-Host "  $newPath" -ForegroundColor White
Write-Host ""
Write-Host "This may take a few minutes..." -ForegroundColor Yellow

try {
    Move-Item -Path $oldPath -Destination $newPath -Force
    Write-Host "✓ Flutter moved successfully!" -ForegroundColor Green
} catch {
    Write-Host "Error moving Flutter: $_" -ForegroundColor Red
    exit 1
}

# Update PATH environment variable
Write-Host ""
Write-Host "Updating PATH environment variable..." -ForegroundColor Cyan

# Get current PATH
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
$machinePath = [Environment]::GetEnvironmentVariable("Path", "Machine")

# Remove old Flutter paths
$userPath = $userPath -replace [regex]::Escape("$oldPath\bin;"), ""
$userPath = $userPath -replace [regex]::Escape("$oldPath\bin"), ""
$machinePath = $machinePath -replace [regex]::Escape("$oldPath\bin;"), ""
$machinePath = $machinePath -replace [regex]::Escape("$oldPath\bin"), ""

# Add new Flutter path to User PATH if not exists
if ($userPath -notlike "*$newPath\bin*") {
    $userPath = "$newPath\bin;" + $userPath
    [Environment]::SetEnvironmentVariable("Path", $userPath, "User")
    Write-Host "✓ Added $newPath\bin to User PATH" -ForegroundColor Green
}

Write-Host ""
Write-Host "=== Setup Complete ===" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Close ALL PowerShell/Terminal windows" -ForegroundColor White
Write-Host "2. Open a NEW PowerShell window" -ForegroundColor White
Write-Host "3. Run: flutter doctor" -ForegroundColor White
Write-Host "4. Navigate to your project and run: flutter clean" -ForegroundColor White
Write-Host "5. Then run: flutter pub get" -ForegroundColor White
Write-Host "6. Finally run: flutter run" -ForegroundColor White
Write-Host ""

Read-Host "Press Enter to exit"
