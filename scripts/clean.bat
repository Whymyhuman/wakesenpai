@echo off
REM Flutter Clean Automation Script for Windows
REM Usage: scripts\clean.bat

echo 🧹 Starting Flutter Clean Process...

REM Check if Flutter is installed
flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Flutter is not installed or not in PATH
    exit /b 1
)

echo [INFO] Flutter version:
flutter --version

REM Navigate to project root (assuming script is in scripts\ folder)
cd /d "%~dp0\.."

echo [INFO] Current directory: %cd%

REM Step 1: Flutter clean
echo [INFO] Running flutter clean...
flutter clean
if %errorlevel% neq 0 (
    echo [ERROR] Flutter clean failed
    exit /b 1
)
echo [SUCCESS] Flutter clean completed

REM Step 2: Remove additional cache directories
echo [INFO] Removing additional cache directories...

REM Remove .dart_tool
if exist ".dart_tool" (
    rmdir /s /q ".dart_tool"
    echo [SUCCESS] Removed .dart_tool directory
)

REM Remove build directory
if exist "build" (
    rmdir /s /q "build"
    echo [SUCCESS] Removed build directory
)

REM Remove iOS build cache
if exist "ios\build" (
    rmdir /s /q "ios\build"
    echo [SUCCESS] Removed iOS build cache
)

REM Remove Android build cache
if exist "android\build" (
    rmdir /s /q "android\build"
    echo [SUCCESS] Removed Android build cache
)

if exist "android\app\build" (
    rmdir /s /q "android\app\build"
    echo [SUCCESS] Removed Android app build cache
)

REM Remove generated files
echo [INFO] Removing generated files...
for /r %%i in (*.g.dart) do del "%%i" 2>nul
for /r %%i in (*.freezed.dart) do del "%%i" 2>nul
echo [SUCCESS] Removed generated files

REM Step 3: Get dependencies
echo [INFO] Getting Flutter dependencies...
flutter pub get
if %errorlevel% neq 0 (
    echo [ERROR] Failed to get dependencies
    exit /b 1
)
echo [SUCCESS] Dependencies downloaded successfully

REM Step 4: Run build_runner (if build_runner is in pubspec.yaml)
findstr /c:"build_runner" pubspec.yaml >nul 2>&1
if %errorlevel% equ 0 (
    echo [INFO] Running build_runner...
    flutter packages pub run build_runner build --delete-conflicting-outputs
    if %errorlevel% equ 0 (
        echo [SUCCESS] Build runner completed successfully
    ) else (
        echo [WARNING] Build runner failed, but continuing...
    )
)

REM Step 5: Analyze code
echo [INFO] Analyzing code...
flutter analyze
if %errorlevel% equ 0 (
    echo [SUCCESS] Code analysis passed
) else (
    echo [WARNING] Code analysis found issues, but continuing...
)

echo [SUCCESS] 🎉 Flutter clean process completed successfully!
echo [INFO] Your project is now clean and ready for development.
pause