# Script simplu pentru push pe GitHub
# Creează repository-ul manual pe GitHub, apoi rulează acest script

param(
    [string]$RepositoryName = "courier-app",
    [string]$GitHubUsername = "operatii777-cloud"
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "SETUP GITHUB - PUSH AUTOMAT" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$projectPath = $PSScriptRoot
Set-Location $projectPath

# Verifică dacă este repository Git
if (-not (Test-Path ".git")) {
    Write-Host "📦 Inițializează repository Git..." -ForegroundColor Yellow
    git init
    git config user.email "operatii777-cloud@users.noreply.github.com"
    git config user.name "operatii777-cloud"
}

# Verifică dacă există commit-uri
$commitCheck = git log --oneline -1 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "📝 Face commit la cod..." -ForegroundColor Yellow
    git add .
    git commit -m "Initial commit - Courier Flutter App with iOS cloud build"
    Write-Host "✅ Commit făcut" -ForegroundColor Green
}

# Verifică remote
$remoteCheck = git remote get-url origin 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "⚠️  Repository-ul nu este conectat la GitHub" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "📋 PAȘI:" -ForegroundColor Cyan
    Write-Host "1. Creează repository pe GitHub:" -ForegroundColor White
    Write-Host "   https://github.com/new" -ForegroundColor Cyan
    Write-Host "   Nume: $RepositoryName" -ForegroundColor White
    Write-Host "   Visibility: Public" -ForegroundColor White
    Write-Host ""
    Write-Host "2. Apoi rulează din nou acest script" -ForegroundColor White
    Write-Host ""
    exit 0
}

# Schimbă branch-ul la main
Write-Host "🌿 Configurează branch main..." -ForegroundColor Yellow
git branch -M main 2>&1 | Out-Null

# Push codul
Write-Host "📤 Push codul pe GitHub..." -ForegroundColor Yellow
Write-Host "   (Poți fi întrebat să te autentifici)" -ForegroundColor DarkYellow
Write-Host ""

try {
    git push -u origin main
    Write-Host ""
    Write-Host "✅ Cod push-at cu succes!" -ForegroundColor Green
} catch {
    Write-Host ""
    Write-Host "⚠️  Push a eșuat" -ForegroundColor Yellow
    Write-Host "   Încearcă manual: git push -u origin main" -ForegroundColor White
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "✅ SETUP COMPLET!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "📋 URMĂTORII PAȘI:" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Activează GitHub Actions:" -ForegroundColor Yellow
Write-Host "   https://github.com/$GitHubUsername/$RepositoryName/settings/actions" -ForegroundColor Cyan
Write-Host "   → Actions → General → Workflow permissions → Read and write" -ForegroundColor White
Write-Host ""
Write-Host "2. Rulează Build:" -ForegroundColor Yellow
Write-Host "   https://github.com/$GitHubUsername/$RepositoryName/actions" -ForegroundColor Cyan
Write-Host "   → Build iOS App (Simple) → Run workflow" -ForegroundColor White
Write-Host ""
Write-Host "3. Descarcă IPA (după ~15 minute):" -ForegroundColor Yellow
Write-Host "   → Artifacts → ios-ipa-unsigned → Download" -ForegroundColor White
Write-Host ""

