# Script pentru găsirea Flutter SDK
Write-Host "🔍 Căutare Flutter SDK..." -ForegroundColor Cyan
Write-Host ""

# 1. Verifică dacă Flutter este în PATH
Write-Host "1️⃣ Verificare PATH..." -ForegroundColor Yellow
$flutterInPath = Get-Command flutter -ErrorAction SilentlyContinue
if ($flutterInPath) {
    $flutterPath = Split-Path (Split-Path $flutterInPath.Source)
    Write-Host "✅ Flutter găsit în PATH: $flutterPath" -ForegroundColor Green
    Write-Host "   Executabil: $($flutterInPath.Source)" -ForegroundColor Gray
    exit 0
} else {
    Write-Host "❌ Flutter nu este în PATH" -ForegroundColor Red
}

Write-Host ""
Write-Host "2️⃣ Căutare în locații comune..." -ForegroundColor Yellow

# 2. Verifică locații comune
$commonLocations = @(
    "C:\src\flutter",
    "C:\flutter",
    "$env:USERPROFILE\flutter",
    "$env:USERPROFILE\AppData\Local\flutter",
    "$env:USERPROFILE\AppData\Local\dev\flutter",
    "C:\Program Files\flutter",
    "C:\Program Files (x86)\flutter",
    "D:\flutter",
    "E:\flutter",
    "F:\flutter"
)

$found = $false
foreach ($loc in $commonLocations) {
    if (Test-Path "$loc\bin\flutter.bat") {
        Write-Host "✅ Flutter SDK găsit: $loc" -ForegroundColor Green
        Write-Host "   Executabil: $loc\bin\flutter.bat" -ForegroundColor Gray
        $found = $true
        break
    }
}

if ($found) {
    exit 0
}

Write-Host ""
Write-Host "3️⃣ Căutare extensivă (poate dura câteva minute)..." -ForegroundColor Yellow
Write-Host "   Căutare pe C:\ (max 4 nivele adâncime)..." -ForegroundColor Gray

# 3. Căutare extensivă pe C:\
$flutterDirs = Get-ChildItem -Path "C:\" -Filter "flutter" -Directory -Recurse -Depth 4 -ErrorAction SilentlyContinue | 
    Where-Object { Test-Path "$($_.FullName)\bin\flutter.bat" } | 
    Select-Object -First 5 FullName

if ($flutterDirs) {
    Write-Host "✅ Flutter SDK găsit:" -ForegroundColor Green
    foreach ($dir in $flutterDirs) {
        Write-Host "   - $dir" -ForegroundColor Cyan
    }
    exit 0
}

Write-Host ""
Write-Host "4️⃣ Căutare pe E:\ (proiectul este aici)..." -ForegroundColor Yellow
$flutterDirsE = Get-ChildItem -Path "E:\" -Filter "flutter" -Directory -Recurse -Depth 4 -ErrorAction SilentlyContinue | 
    Where-Object { Test-Path "$($_.FullName)\bin\flutter.bat" } | 
    Select-Object -First 5 FullName

if ($flutterDirsE) {
    Write-Host "✅ Flutter SDK găsit:" -ForegroundColor Green
    foreach ($dir in $flutterDirsE) {
        Write-Host "   - $dir" -ForegroundColor Cyan
    }
    exit 0
}

Write-Host ""
Write-Host "❌ Flutter SDK nu a fost găsit!" -ForegroundColor Red
Write-Host ""
Write-Host "💡 Opțiuni:" -ForegroundColor Yellow
Write-Host "   1. Instalează Flutter: https://docs.flutter.dev/get-started/install/windows" -ForegroundColor Cyan
Write-Host "   2. Dacă Flutter este instalat, adaugă-l la PATH:" -ForegroundColor Cyan
Write-Host "      - Deschide 'Environment Variables'" -ForegroundColor Gray
Write-Host "      - Adaugă calea către Flutter\bin la PATH" -ForegroundColor Gray
Write-Host "   3. Sau specifică manual calea în VS Code:" -ForegroundColor Cyan
Write-Host "      - File -> Preferences -> Settings" -ForegroundColor Gray
Write-Host "      - Cauta flutter.sdk" -ForegroundColor Gray
Write-Host "      - Adaugă calea completă" -ForegroundColor Gray
