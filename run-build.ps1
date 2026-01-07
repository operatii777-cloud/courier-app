# Script pentru activare GitHub Actions și rulare build automat

param(
    [string]$Repository = "operatii777-cloud/courier-app",
    [string]$WorkflowFile = "build-ios-simple.yml",
    [string]$GitHubToken = ""
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "ACTIVARE GITHUB ACTIONS ȘI BUILD" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Verifică dacă GitHub CLI este instalat
$ghInstalled = Get-Command gh -ErrorAction SilentlyContinue

if ($ghInstalled) {
    Write-Host "✅ GitHub CLI găsit" -ForegroundColor Green
    
    # Verifică autentificare
    $authCheck = gh auth status 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "🔑 Autentifică-te în GitHub CLI:" -ForegroundColor Yellow
        Write-Host "   gh auth login" -ForegroundColor White
        gh auth login
    }
    
    Write-Host "⚙️  Activează GitHub Actions..." -ForegroundColor Yellow
    
    # Activează Actions prin API
    if ($GitHubToken) {
        $headers = @{
            "Authorization" = "token $GitHubToken"
            "Accept" = "application/vnd.github.v3+json"
        }
    } else {
        # Folosește GitHub CLI pentru token
        $token = gh auth token 2>&1
        if ($LASTEXITCODE -eq 0) {
            $headers = @{
                "Authorization" = "token $token"
                "Accept" = "application/vnd.github.v3+json"
            }
        } else {
            Write-Host "⚠️  Nu pot obține token. Folosește GitHub API manual." -ForegroundColor Yellow
            Write-Host ""
            Write-Host "📋 PAȘI MANUALI:" -ForegroundColor Cyan
            Write-Host "1. Activează Actions: https://github.com/$Repository/settings/actions" -ForegroundColor White
            Write-Host "2. Rulează build: https://github.com/$Repository/actions/workflows/$WorkflowFile" -ForegroundColor White
            exit 0
        }
    }
    
    # Rulează workflow
    Write-Host "🚀 Rulează workflow: $WorkflowFile" -ForegroundColor Yellow
    
    $body = @{
        ref = "main"
    } | ConvertTo-Json
    
    try {
        $response = Invoke-RestMethod -Uri "https://api.github.com/repos/$Repository/actions/workflows/$WorkflowFile/dispatches" -Headers $headers -Method Post -Body $body -ContentType "application/json"
        Write-Host "✅ Build pornit cu succes!" -ForegroundColor Green
        Write-Host ""
        Write-Host "🔗 Urmărește progresul: https://github.com/$Repository/actions" -ForegroundColor Cyan
    } catch {
        Write-Host "⚠️  Eroare la rularea workflow: $($_.Exception.Message)" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "📋 Rulează manual:" -ForegroundColor Cyan
        Write-Host "   https://github.com/$Repository/actions/workflows/$WorkflowFile" -ForegroundColor White
    }
    
} else {
    Write-Host "⚠️  GitHub CLI nu este instalat" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "📋 PAȘI MANUALI (2 minute):" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1. ACTIVEAZĂ GITHUB ACTIONS:" -ForegroundColor Yellow
    Write-Host "   https://github.com/$Repository/settings/actions" -ForegroundColor Cyan
    Write-Host "   → Actions → General → Workflow permissions" -ForegroundColor White
    Write-Host "   → Selectează: 'Read and write permissions'" -ForegroundColor White
    Write-Host "   → Click 'Save'" -ForegroundColor White
    Write-Host ""
    Write-Host "2. RULEAZĂ BUILD:" -ForegroundColor Yellow
    Write-Host "   https://github.com/$Repository/actions" -ForegroundColor Cyan
    Write-Host "   → Click pe 'Build iOS App (Simple)'" -ForegroundColor White
    Write-Host "   → Click 'Run workflow' (dreapta sus)" -ForegroundColor White
    Write-Host "   → Alege branch: 'main'" -ForegroundColor White
    Write-Host "   → Click 'Run workflow'" -ForegroundColor White
    Write-Host ""
    Write-Host "3. AȘTEAPTĂ BUILD (~15 minute):" -ForegroundColor Yellow
    Write-Host "   → Urmărește progresul în timp real" -ForegroundColor White
    Write-Host "   → După finalizare, descarcă IPA din Artifacts" -ForegroundColor White
    Write-Host ""
    
    # Deschide link-urile în browser
    Start-Process "https://github.com/$Repository/settings/actions"
    Start-Sleep -Seconds 2
    Start-Process "https://github.com/$Repository/actions"
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "✅ GATA!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

