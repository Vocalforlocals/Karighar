<#
.SYNOPSIS
    Karighar (कारीघर) — Automated Android APK Build Script
    Smart India Hackathon 2026 | MoSJE Problem Statement #26090

.DESCRIPTION
    Compiles the production-ready Android APK with pre-flight environment checks,
    dependency hydration, and artifact path reporting.
#>

[CmdletBinding()]
param (
    [switch]$SplitPerAbi = $false,
    [switch]$SkipAnalyze = $false
)

$ErrorActionPreference = "Stop"

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host " 🏛️ Karighar (कारीघर) — Android APK Build Pipeline" -ForegroundColor Yellow
Write-Host " Smart India Hackathon 2026 | MoSJE Problem Statement #26090" -ForegroundColor Gray
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host ""

# 1. Locate Flutter
Write-Host "[1/5] Checking Flutter SDK..." -ForegroundColor Green
$flutterCmd = Get-Command flutter -ErrorAction SilentlyContinue
if (-not $flutterCmd) {
    if (Test-Path "C:\src\flutter\bin\flutter.bat") {
        $flutter = "C:\src\flutter\bin\flutter.bat"
    } else {
        Write-Error "Flutter SDK not found in PATH or standard location (C:\src\flutter\bin)."
        exit 1
    }
} else {
    $flutter = $flutterCmd.Source
}
Write-Host "      Found Flutter: $flutter" -ForegroundColor DarkGray

# 2. Pre-flight Flutter Doctor Check
Write-Host "[2/5] Checking Android Toolchain..." -ForegroundColor Green
& $flutter doctor --android-licenses -v 2>&1 | Out-Null

# 3. Static Code Analysis
if (-not $SkipAnalyze) {
    Write-Host "[3/5] Running static analysis..." -ForegroundColor Green
    & $flutter analyze --no-fatal-infos
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Flutter analysis reported errors. Please resolve before building."
        exit $LASTEXITCODE
    }
    Write-Host "      Static analysis passed with 0 errors." -ForegroundColor DarkGray
} else {
    Write-Host "[3/5] Skipping static analysis (-SkipAnalyze specified)" -ForegroundColor Yellow
}

# 4. Fetch Dependencies
Write-Host "[4/5] Getting dependencies..." -ForegroundColor Green
& $flutter pub get

# 5. Build Release APK
Write-Host "[5/5] Building Android Release APK..." -ForegroundColor Green
if ($SplitPerAbi) {
    Write-Host "      Mode: Split per ABI (arm64-v8a, armeabi-v7a, x86_64)" -ForegroundColor DarkGray
    & $flutter build apk --release --split-per-abi
} else {
    Write-Host "      Mode: Universal Release APK" -ForegroundColor DarkGray
    & $flutter build apk --release
}

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "================================================================" -ForegroundColor Green
    Write-Host " ✅ Build Successful!" -ForegroundColor Green
    Write-Host " APK location:" -ForegroundColor Yellow
    Get-ChildItem -Path "build\app\outputs\flutter-apk\*.apk" | ForEach-Object {
        $sizeMB = [math]::Round($_.Length / 1MB, 2)
        Write-Host "  -> $($_.FullName) ($sizeMB MB)" -ForegroundColor Cyan
    }
    Write-Host "================================================================" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "❌ Build encountered an error (Exit code: $LASTEXITCODE)." -ForegroundColor Red
    Write-Host "Note: If Android command-line tools are missing, please ensure" -ForegroundColor Yellow
    Write-Host "Android SDK Command-line Tools (latest) are installed via Android Studio." -ForegroundColor Yellow
}
