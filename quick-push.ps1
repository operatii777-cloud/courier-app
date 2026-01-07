# Script rapid pentru push după ce ai creat repository-ul manual

$projectPath = $PSScriptRoot
Set-Location $projectPath

Write-Host "📤 Push codul pe GitHub..." -ForegroundColor Cyan

# Verifică dacă remote-ul există
$remoteCheck = git remote get-url origin 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Remote nu este configurat!" -ForegroundColor Red
    Write-Host "   Rulează: git remote add origin https://github.com/operatii777-cloud/courier-app.git" -ForegroundColor Yellow
    exit 1
}

# Push
git push -u origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✅ Push reușit!" -ForegroundColor Green
    Write-Host "🔗 https://github.com/operatii777-cloud/courier-app" -ForegroundColor Cyan
} else {
    Write-Host ""
    Write-Host "❌ Push a eșuat" -ForegroundColor Red
    Write-Host "   Verifică că ai creat repository-ul pe GitHub" -ForegroundColor Yellow
}

