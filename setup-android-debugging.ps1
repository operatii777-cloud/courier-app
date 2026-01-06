# Script pentru configurarea debugging Android in VS Code
# Acest script configureaza ADB si Flutter pentru a detecta telefonul

Write-Host "Configurare Android Debugging pentru VS Code..." -ForegroundColor Cyan
Write-Host ""

# 1. Gaseste Android SDK
Write-Host "Cautare Android SDK..." -ForegroundColor Yellow

$androidSdkPaths = @(
    "$env:LOCALAPPDATA\Android\Sdk",
    "$env:USERPROFILE\AppData\Local\Android\Sdk",
    "C:\Users\$env:USERNAME\AppData\Local\Android\Sdk",
    "$env:ANDROID_HOME"
)

$androidSdkPath = $null
foreach ($path in $androidSdkPaths) {
    if ($path -and (Test-Path $path)) {
        $platformTools = Join-Path $path "platform-tools"
        if (Test-Path $platformTools) {
            $androidSdkPath = $path
            break
        }
    }
}

if (-not $androidSdkPath) {
    Write-Host "Android SDK nu a fost gasit!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Instaleaza Android Studio:" -ForegroundColor Yellow
    Write-Host "   https://developer.android.com/studio"
    Write-Host ""
    exit 1
}

$platformToolsPath = Join-Path $androidSdkPath "platform-tools"
$adbPath = Join-Path $platformToolsPath "adb.exe"

Write-Host "Android SDK gasit: $androidSdkPath" -ForegroundColor Green
Write-Host "ADB gasit: $adbPath" -ForegroundColor Green
Write-Host ""

# 2. Verifica daca ADB este in PATH
$adbInPath = $false
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($currentPath -like "*$platformToolsPath*") {
    $adbInPath = $true
    Write-Host "ADB este deja in PATH" -ForegroundColor Green
} else {
    Write-Host "ADB nu este in PATH" -ForegroundColor Yellow
    Write-Host "   Adaugare la PATH..." -ForegroundColor Yellow
    
    $newPath = $currentPath + ";$platformToolsPath"
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    $env:Path += ";$platformToolsPath"
    
    Write-Host "ADB adaugat la PATH" -ForegroundColor Green
}

Write-Host ""

# 3. Verifica dispozitivele conectate
Write-Host "Verificare dispozitive Android..." -ForegroundColor Yellow
Write-Host ""

# Foloseste calea completa pentru a evita problemele cu PATH
& $adbPath devices

Write-Host ""
Write-Host "=========================================================" -ForegroundColor Green
Write-Host "INSTRUCTIUNI PENTRU TELEFON:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Activeaza USB Debugging pe telefon:" -ForegroundColor Cyan
Write-Host "   Android: Settings -> About Phone -> Tap 'Build Number' 7x"
Write-Host "   Apoi: Settings -> Developer Options -> USB Debugging (ON)"
Write-Host ""
Write-Host "2. Conecteaza telefonul la PC via USB" -ForegroundColor Cyan
Write-Host ""
Write-Host "3. Accepta prompt-ul 'Allow USB Debugging' pe telefon" -ForegroundColor Cyan
Write-Host ""
Write-Host "4. Ruleaza din nou acest script pentru verificare" -ForegroundColor Cyan
Write-Host ""
Write-Host "=========================================================" -ForegroundColor Green
Write-Host ""

# 4. Verifica Flutter
Write-Host "Verificare Flutter devices..." -ForegroundColor Yellow
Write-Host ""

# Actualizeaza PATH pentru sesiunea curenta
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

flutter devices

Write-Host ""
Write-Host "=========================================================" -ForegroundColor Green
Write-Host "CONFIGURARE COMPLETA!" -ForegroundColor Green
Write-Host ""
Write-Host "Urmatorii pasi:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Activeaza USB Debugging pe telefon (vezi instructiunile de mai sus)" -ForegroundColor Cyan
Write-Host "2. Conecteaza telefonul la PC" -ForegroundColor Cyan
Write-Host "3. Accepta 'Allow USB Debugging' pe telefon" -ForegroundColor Cyan
Write-Host "4. Reporneste VS Code" -ForegroundColor Cyan
Write-Host "5. In VS Code: View -> Command Palette -> 'Flutter: Select Device'" -ForegroundColor Cyan
Write-Host ""
Write-Host "Daca telefonul nu apare:" -ForegroundColor Yellow
Write-Host "   - Verifica ca USB Debugging este activat"
Write-Host "   - Verifica ca ai acceptat prompt-ul pe telefon"
Write-Host "   - Ruleaza: adb devices (ar trebui sa vezi telefonul)"
Write-Host "   - Ruleaza: flutter devices (ar trebui sa vezi telefonul)"
Write-Host ""
Write-Host "=========================================================" -ForegroundColor Green
