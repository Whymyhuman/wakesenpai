# Flutter Clean Automation Script for PowerShell
# Usage: .\scripts\clean.ps1

Write-Host "🧹 Starting Flutter Clean Process..." -ForegroundColor Cyan

# Function to print colored output
function Write-Status {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Blue
}

function Write-Success {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[WARNING] $Message" -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

# Check if Flutter is installed
try {
    $null = Get-Command flutter -ErrorAction Stop
} catch {
    Write-Error "Flutter is not installed or not in PATH"
    exit 1
}

Write-Status "Flutter version:"
flutter --version

# Navigate to project root (assuming script is in scripts\ folder)
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location (Join-Path $scriptPath "..")

Write-Status "Current directory: $(Get-Location)"

# Step 1: Flutter clean
Write-Status "Running flutter clean..."
$cleanResult = flutter clean
if ($LASTEXITCODE -ne 0) {
    Write-Error "Flutter clean failed"
    exit 1
}
Write-Success "Flutter clean completed"

# Step 2: Remove additional cache directories
Write-Status "Removing additional cache directories..."

# Remove .dart_tool
if (Test-Path ".dart_tool") {
    Remove-Item -Recurse -Force ".dart_tool"
    Write-Success "Removed .dart_tool directory"
}

# Remove build directory
if (Test-Path "build") {
    Remove-Item -Recurse -Force "build"
    Write-Success "Removed build directory"
}

# Remove iOS build cache
if (Test-Path "ios\build") {
    Remove-Item -Recurse -Force "ios\build"
    Write-Success "Removed iOS build cache"
}

# Remove Android build cache
if (Test-Path "android\build") {
    Remove-Item -Recurse -Force "android\build"
    Write-Success "Removed Android build cache"
}

if (Test-Path "android\app\build") {
    Remove-Item -Recurse -Force "android\app\build"
    Write-Success "Removed Android app build cache"
}

# Remove generated files
Write-Status "Removing generated files..."
Get-ChildItem -Recurse -Filter "*.g.dart" | Remove-Item -Force
Get-ChildItem -Recurse -Filter "*.freezed.dart" | Remove-Item -Force
Write-Success "Removed generated files"

# Step 3: Get dependencies
Write-Status "Getting Flutter dependencies..."
$pubGetResult = flutter pub get
if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to get dependencies"
    exit 1
}
Write-Success "Dependencies downloaded successfully"

# Step 4: Run build_runner (if build_runner is in pubspec.yaml)
if (Select-String -Path "pubspec.yaml" -Pattern "build_runner" -Quiet) {
    Write-Status "Running build_runner..."
    $buildRunnerResult = flutter packages pub run build_runner build --delete-conflicting-outputs
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Build runner completed successfully"
    } else {
        Write-Warning "Build runner failed, but continuing..."
    }
}

# Step 5: Analyze code
Write-Status "Analyzing code..."
$analyzeResult = flutter analyze
if ($LASTEXITCODE -eq 0) {
    Write-Success "Code analysis passed"
} else {
    Write-Warning "Code analysis found issues, but continuing..."
}

Write-Success "🎉 Flutter clean process completed successfully!"
Write-Status "Your project is now clean and ready for development."

# Keep window open
Read-Host "Press Enter to continue..."