# Script automat pentru setup GitHub și push
# Acest script automatizează tot procesul

param(
    [string]$RepositoryName = "courier-app",
    [string]$GitHubUsername = "operatii777-cloud",
    [string]$GitHubToken = ""
)

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "SETUP AUTOMAT GITHUB" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$projectPath = $PSScriptRoot

# Verifică dacă este repository Git
Set-Location $projectPath
if (-not (Test-Path ".git")) {
    Write-Host "📦 Inițializează repository Git..." -ForegroundColor Yellow
    git init
    git config user.email "operatii777-cloud@users.noreply.github.com"
    git config user.name "operatii777-cloud"
}

# Verifică dacă există commit-uri
$hasCommits = git log --oneline -1 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "📝 Face commit la cod..." -ForegroundColor Yellow
    git add .
    git commit -m "Initial commit - Courier Flutter App with iOS cloud build"
}

# Verifică dacă există remote
$remoteExists = git remote get-url origin 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "🔗 Configurează remote..." -ForegroundColor Yellow
    
    $repoUrl = "https://github.com/$GitHubUsername/$RepositoryName.git"
    
    # Verifică dacă repository-ul există deja
    Write-Host "🔍 Verifică dacă repository-ul există..." -ForegroundColor Yellow
    
    if ($GitHubToken) {
        # Folosește token pentru verificare
        $headers = @{
            "Authorization" = "token $GitHubToken"
            "Accept" = "application/vnd.github.v3+json"
        }
        
        try {
            $response = Invoke-RestMethod -Uri "https://api.github.com/repos/$GitHubUsername/$RepositoryName" -Headers $headers -Method Get -ErrorAction SilentlyContinue
            Write-Host "✅ Repository există deja" -ForegroundColor Green
        } catch {
            Write-Host "📦 Creează repository nou..." -ForegroundColor Yellow
            
            $body = @{
                name = $RepositoryName
                description = "Courier Flutter App - Restaurant Management System"
                private = $false
                auto_init = $false
            } | ConvertTo-Json
            
            try {
                $response = Invoke-RestMethod -Uri "https://api.github.com/user/repos" -Headers $headers -Method Post -Body $body -ContentType "application/json"
                Write-Host "✅ Repository creat cu succes!" -ForegroundColor Green
            } catch {
                Write-Host "⚠️  Nu s-a putut crea repository automat" -ForegroundColor Yellow
                Write-Host "   Creează manual: https://github.com/new" -ForegroundColor White
                Write-Host "   Nume: $RepositoryName" -ForegroundColor White
                Write-Host "   Visibility: Public" -ForegroundColor White
            }
        }
    } else {
        Write-Host "⚠️  Token GitHub nu este furnizat" -ForegroundColor Yellow
        Write-Host "   Creează repository manual:" -ForegroundColor White
        Write-Host "   1. Mergi la: https://github.com/new" -ForegroundColor Cyan
        Write-Host "   2. Nume: $RepositoryName" -ForegroundColor Cyan
        Write-Host "   3. Visibility: Public" -ForegroundColor Cyan
        Write-Host "   4. Click 'Create repository'" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "   Apoi apasă Enter pentru a continua..." -ForegroundColor Yellow
        Read-Host
    }
    
    # Adaugă remote
    Write-Host "🔗 Adaugă remote: $repoUrl" -ForegroundColor Yellow
    git remote add origin $repoUrl 2>&1 | Out-Null
    
    # Verifică dacă remote-ul a fost adăugat
    $currentRemote = git remote get-url origin 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Remote configurat: $currentRemote" -ForegroundColor Green
    }
}

# Schimbă branch-ul la main
Write-Host "🌿 Configurează branch main..." -ForegroundColor Yellow
git branch -M main 2>&1 | Out-Null

# Push codul
Write-Host "📤 Push codul pe GitHub..." -ForegroundColor Yellow
Write-Host "   (Poți fi întrebat să te autentifici)" -ForegroundColor DarkYellow

try {
    git push -u origin main
    Write-Host ""
    Write-Host "✅ Cod push-at cu succes!" -ForegroundColor Green
} catch {
    Write-Host ""
    Write-Host "⚠️  Push a eșuat. Încearcă manual:" -ForegroundColor Yellow
    Write-Host "   git push -u origin main" -ForegroundColor White
    Write-Host ""
    Write-Host "   Sau folosește GitHub Desktop sau VS Code Git extension" -ForegroundColor White
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "SETUP COMPLET!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "📋 URMĂTORII PAȘI:" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Activează GitHub Actions:" -ForegroundColor Yellow
Write-Host "   https://github.com/$GitHubUsername/$RepositoryName/settings/actions" -ForegroundColor White
Write-Host "   → Actions → General → Workflow permissions → Read and write" -ForegroundColor White
Write-Host ""
Write-Host "2. Rulează Build:" -ForegroundColor Yellow
Write-Host "   https://github.com/$GitHubUsername/$RepositoryName/actions" -ForegroundColor White
Write-Host "   → Build iOS App (Simple) → Run workflow" -ForegroundColor White
Write-Host ""
Write-Host "3. Descarcă IPA:" -ForegroundColor Yellow
Write-Host "   După build → Artifacts → ios-ipa-unsigned" -ForegroundColor White
Write-Host ""

