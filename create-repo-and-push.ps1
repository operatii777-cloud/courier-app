# Script pentru creare repository și push automat
# Folosește GitHub API pentru a crea repository-ul

param(
    [string]$RepositoryName = "courier-app",
    [string]$GitHubUsername = "operatii777-cloud"
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "CREARE REPOSITORY ȘI PUSH" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$projectPath = $PSScriptRoot
Set-Location $projectPath

# Verifică dacă există token în variabile de mediu
$token = $env:GITHUB_TOKEN

if (-not $token) {
    Write-Host "🔑 Pentru a crea repository automat, am nevoie de un GitHub Personal Access Token" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "📋 PAȘI:" -ForegroundColor Cyan
    Write-Host "1. Mergi la: https://github.com/settings/tokens/new" -ForegroundColor White
    Write-Host "2. Nume token: 'Courier App Setup'" -ForegroundColor White
    Write-Host "3. Bifează: 'repo' (Full control of private repositories)" -ForegroundColor White
    Write-Host "4. Click 'Generate token'" -ForegroundColor White
    Write-Host "5. Copiază token-ul" -ForegroundColor White
    Write-Host ""
    Write-Host "Apoi rulează:" -ForegroundColor Yellow
    Write-Host "  `$env:GITHUB_TOKEN='TOKEN_TĂU'; .\create-repo-and-push.ps1" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "SAU creează repository manual:" -ForegroundColor Yellow
    Write-Host "  https://github.com/new?name=$RepositoryName" -ForegroundColor Cyan
    Write-Host ""
    
    # Deschide browser-ul pentru creare manuală
    Start-Process "https://github.com/new?name=$RepositoryName&description=Courier+Flutter+App&public=true"
    
    Write-Host "⏳ Aștept 30 secunde pentru a crea repository-ul manual..." -ForegroundColor Yellow
    Start-Sleep -Seconds 30
    
    Write-Host ""
    Write-Host "🔄 Continuă cu push-ul..." -ForegroundColor Yellow
} else {
    Write-Host "🔑 Token găsit, creez repository..." -ForegroundColor Green
    
    $headers = @{
        "Authorization" = "token $token"
        "Accept" = "application/vnd.github.v3+json"
    }
    
    $body = @{
        name = $RepositoryName
        description = "Courier Flutter App - Restaurant Management System"
        private = $false
        auto_init = $false
    } | ConvertTo-Json
    
    try {
        $response = Invoke-RestMethod -Uri "https://api.github.com/user/repos" -Headers $headers -Method Post -Body $body -ContentType "application/json"
        Write-Host "✅ Repository creat: $($response.html_url)" -ForegroundColor Green
    } catch {
        if ($_.Exception.Response.StatusCode -eq 422) {
            Write-Host "⚠️  Repository există deja, continuă cu push..." -ForegroundColor Yellow
        } else {
            Write-Host "❌ Eroare la crearea repository: $($_.Exception.Message)" -ForegroundColor Red
            exit 1
        }
    }
}

# Verifică dacă remote-ul există
$remoteCheck = git remote get-url origin 2>&1
if ($LASTEXITCODE -ne 0) {
    $repoUrl = "https://github.com/$GitHubUsername/$RepositoryName.git"
    Write-Host "🔗 Adaugă remote: $repoUrl" -ForegroundColor Yellow
    git remote add origin $repoUrl
}

# Verifică dacă există commit-uri
$commitCheck = git log --oneline -1 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "📝 Face commit..." -ForegroundColor Yellow
    git add .
    git config user.email "operatii777-cloud@users.noreply.github.com"
    git config user.name "operatii777-cloud"
    git commit -m "Initial commit - Courier Flutter App with iOS cloud build"
}

# Schimbă branch-ul la main
Write-Host "🌿 Configurează branch main..." -ForegroundColor Yellow
git branch -M main 2>&1 | Out-Null

# Push codul
Write-Host "📤 Push codul..." -ForegroundColor Yellow
try {
    git push -u origin main
    Write-Host ""
    Write-Host "✅ Cod push-at cu succes!" -ForegroundColor Green
    Write-Host ""
    Write-Host "🔗 Repository: https://github.com/$GitHubUsername/$RepositoryName" -ForegroundColor Cyan
    Write-Host "📋 Actions: https://github.com/$GitHubUsername/$RepositoryName/actions" -ForegroundColor Cyan
} catch {
    Write-Host ""
    Write-Host "⚠️  Push a eșuat. Încearcă manual:" -ForegroundColor Yellow
    Write-Host "   git push -u origin main" -ForegroundColor White
}

