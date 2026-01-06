# Script de Setup iOS pentru Aplicația Courier
# NOTĂ: Acest script verifică doar cerințele. Compilarea iOS necesită Mac.

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "VERIFICARE SETUP iOS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Verifică dacă rulează pe Mac
$isMac = $IsMacOS -or ($env:OS -eq "Darwin") -or (Test-Path "/usr/bin/sw_vers")

if (-not $isMac) {
    Write-Host "⚠️  ATENȚIE: Compilarea iOS necesită macOS!" -ForegroundColor Yellow
    Write-Host "Acest script poate fi rulat doar pe Mac." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Opțiuni:" -ForegroundColor Cyan
    Write-Host "1. Folosește un Mac pentru compilare" -ForegroundColor White
    Write-Host "2. Folosește CI/CD (GitHub Actions, Codemagic, etc.)" -ForegroundColor White
    Write-Host "3. Folosește servicii cloud (MacStadium, AWS Mac instances)" -ForegroundColor White
    Write-Host ""
    exit 0
}

Write-Host "✅ Rulează pe macOS" -ForegroundColor Green
Write-Host ""

# Verifică Flutter
Write-Host "🔍 Verifică Flutter..." -ForegroundColor Yellow
try {
    $flutterVersion = flutter --version 2>&1 | Select-String "Flutter" | Select-Object -First 1
    if ($flutterVersion) {
        Write-Host "✅ Flutter instalat: $flutterVersion" -ForegroundColor Green
    } else {
        Write-Host "❌ Flutter nu este instalat" -ForegroundColor Red
        Write-Host "Instalează Flutter: https://docs.flutter.dev/get-started/install/macos" -ForegroundColor Yellow
        exit 1
    }
} catch {
    Write-Host "❌ Flutter nu este în PATH" -ForegroundColor Red
    exit 1
}

# Verifică Xcode
Write-Host ""
Write-Host "🔍 Verifică Xcode..." -ForegroundColor Yellow
try {
    $xcodeVersion = xcodebuild -version 2>&1 | Select-String "Xcode" | Select-Object -First 1
    if ($xcodeVersion) {
        Write-Host "✅ Xcode instalat: $xcodeVersion" -ForegroundColor Green
    } else {
        Write-Host "❌ Xcode nu este instalat" -ForegroundColor Red
        Write-Host "Instalează Xcode din App Store" -ForegroundColor Yellow
        exit 1
    }
} catch {
    Write-Host "❌ Xcode nu este instalat" -ForegroundColor Red
    exit 1
}

# Verifică CocoaPods
Write-Host ""
Write-Host "🔍 Verifică CocoaPods..." -ForegroundColor Yellow
try {
    $podVersion = pod --version 2>&1
    if ($podVersion) {
        Write-Host "✅ CocoaPods instalat: v$podVersion" -ForegroundColor Green
    } else {
        Write-Host "⚠️  CocoaPods nu este instalat" -ForegroundColor Yellow
        Write-Host "Instalează: sudo gem install cocoapods" -ForegroundColor Yellow
    }
} catch {
    Write-Host "⚠️  CocoaPods nu este instalat" -ForegroundColor Yellow
    Write-Host "Instalează: sudo gem install cocoapods" -ForegroundColor Yellow
}

# Verifică dacă există folderul iOS
Write-Host ""
Write-Host "🔍 Verifică structura iOS..." -ForegroundColor Yellow
if (Test-Path "ios") {
    Write-Host "✅ Folder iOS există" -ForegroundColor Green
} else {
    Write-Host "⚠️  Folder iOS nu există" -ForegroundColor Yellow
    Write-Host "Creează structura iOS: flutter create --platforms=ios ." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "VERIFICARE COMPLETĂ" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Următorii pași:" -ForegroundColor Cyan
Write-Host "1. Configurează Info.plist cu permisiuni GPS" -ForegroundColor White
Write-Host "2. Deschide ios/Runner.xcworkspace în Xcode" -ForegroundColor White
Write-Host "3. Configurează Bundle Identifier și Signing" -ForegroundColor White
Write-Host "4. Rulează: cd ios && pod install" -ForegroundColor White
Write-Host "5. Compilează: flutter build ios" -ForegroundColor White
Write-Host ""

