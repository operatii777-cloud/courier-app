# Script de Setup pentru Cloud Build iOS
# Acest script verifică și configurează totul pentru build în cloud

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "SETUP CLOUD BUILD iOS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$projectRoot = Split-Path -Parent $PSScriptRoot
$courierAppPath = Join-Path $projectRoot "courier-flutter-app"

# Verifică dacă există folderul aplicației
if (-not (Test-Path $courierAppPath)) {
    Write-Host "❌ Folderul courier-flutter-app nu a fost găsit!" -ForegroundColor Red
    Write-Host "Locație așteptată: $courierAppPath" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Folder aplicație găsit: $courierAppPath" -ForegroundColor Green
Write-Host ""

# Verifică Git
Write-Host "🔍 Verifică Git..." -ForegroundColor Yellow
try {
    $gitVersion = git --version 2>&1
    if ($gitVersion) {
        Write-Host "✅ Git instalat: $gitVersion" -ForegroundColor Green
    } else {
        Write-Host "❌ Git nu este instalat" -ForegroundColor Red
        Write-Host "Instalează Git: https://git-scm.com/download/win" -ForegroundColor Yellow
        exit 1
    }
} catch {
    Write-Host "❌ Git nu este în PATH" -ForegroundColor Red
    exit 1
}

# Verifică dacă este repo Git
Write-Host ""
Write-Host "🔍 Verifică repository Git..." -ForegroundColor Yellow
Set-Location $courierAppPath

$isGitRepo = Test-Path ".git"
if (-not $isGitRepo) {
    Write-Host "⚠️  Nu este un repository Git" -ForegroundColor Yellow
    Write-Host "Inițializează Git repository..." -ForegroundColor Yellow
    
    git init
    git add .
    git commit -m "Initial commit - Courier Flutter App"
    
    Write-Host "✅ Repository Git inițializat" -ForegroundColor Green
    Write-Host ""
    Write-Host "📝 URMĂTORII PAȘI:" -ForegroundColor Cyan
    Write-Host "1. Creează un repository nou pe GitHub" -ForegroundColor White
    Write-Host "2. Adaugă remote: git remote add origin https://github.com/TU_USERNAME/courier-app.git" -ForegroundColor White
    Write-Host "3. Push: git push -u origin main" -ForegroundColor White
} else {
    Write-Host "✅ Repository Git există" -ForegroundColor Green
    
    # Verifică remote
    $remoteUrl = git remote get-url origin 2>&1
    if ($remoteUrl -and -not $remoteUrl.ToString().Contains("fatal")) {
        Write-Host "✅ Remote configurat: $remoteUrl" -ForegroundColor Green
    } else {
        Write-Host "⚠️  Remote nu este configurat" -ForegroundColor Yellow
        Write-Host "Adaugă remote: git remote add origin https://github.com/TU_USERNAME/courier-app.git" -ForegroundColor White
    }
}

# Verifică dacă există workflow-ul GitHub Actions
Write-Host ""
Write-Host "🔍 Verifică GitHub Actions workflow..." -ForegroundColor Yellow
$workflowPath = Join-Path $courierAppPath ".github" "workflows" "build-ios.yml"
$workflowSimplePath = Join-Path $courierAppPath ".github" "workflows" "build-ios-simple.yml"

if (Test-Path $workflowPath) {
    Write-Host "✅ Workflow build-ios.yml există" -ForegroundColor Green
} else {
    Write-Host "⚠️  Workflow build-ios.yml nu există" -ForegroundColor Yellow
    Write-Host "   Va fi creat automat când rulezi scriptul" -ForegroundColor White
}

if (Test-Path $workflowSimplePath) {
    Write-Host "✅ Workflow build-ios-simple.yml există" -ForegroundColor Green
} else {
    Write-Host "⚠️  Workflow build-ios-simple.yml nu există" -ForegroundColor Yellow
}

# Verifică Info.plist
Write-Host ""
Write-Host "🔍 Verifică configurație iOS..." -ForegroundColor Yellow
$infoPlistPath = Join-Path $courierAppPath "ios" "Runner" "Info.plist"
$infoPlistTemplatePath = Join-Path $courierAppPath "ios" "Runner" "Info.plist.template"

if (Test-Path $infoPlistTemplatePath) {
    Write-Host "✅ Template Info.plist există" -ForegroundColor Green
} else {
    Write-Host "⚠️  Template Info.plist nu există" -ForegroundColor Yellow
}

# Verifică pubspec.yaml
Write-Host ""
Write-Host "🔍 Verifică pubspec.yaml..." -ForegroundColor Yellow
$pubspecPath = Join-Path $courierAppPath "pubspec.yaml"
if (Test-Path $pubspecPath) {
    Write-Host "✅ pubspec.yaml există" -ForegroundColor Green
} else {
    Write-Host "❌ pubspec.yaml nu există!" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "VERIFICARE COMPLETĂ" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "📋 URMĂTORII PAȘI PENTRU CLOUD BUILD:" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. PUSH PE GITHUB:" -ForegroundColor Yellow
Write-Host "   git add ." -ForegroundColor White
Write-Host "   git commit -m 'Add iOS cloud build workflow'" -ForegroundColor White
Write-Host "   git push origin main" -ForegroundColor White
Write-Host ""
Write-Host "2. ACTIVEAZĂ GITHUB ACTIONS:" -ForegroundColor Yellow
Write-Host "   - Mergi pe GitHub → Repository → Actions" -ForegroundColor White
Write-Host "   - Activează workflows dacă este necesar" -ForegroundColor White
Write-Host ""
Write-Host "3. RULEAZĂ BUILD:" -ForegroundColor Yellow
Write-Host "   - Mergi la Actions tab" -ForegroundColor White
Write-Host "   - Selectează 'Build iOS App'" -ForegroundColor White
Write-Host "   - Click 'Run workflow'" -ForegroundColor White
Write-Host ""
Write-Host "4. DESCARCĂ IPA:" -ForegroundColor Yellow
Write-Host "   - După build, mergi la run-ul respectiv" -ForegroundColor White
Write-Host "   - Scroll la 'Artifacts'" -ForegroundColor White
Write-Host "   - Click pe 'ios-ipa' pentru descărcare" -ForegroundColor White
Write-Host ""
Write-Host "📚 Documentație completă: CLOUD-BUILD-SETUP.md" -ForegroundColor Cyan
Write-Host ""

