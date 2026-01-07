# Script pentru verificarea problemelor Git si GitHub Actions
# Usage: .\check-git-issues.ps1

Write-Host "Verificare probleme Git si GitHub Actions..." -ForegroundColor Cyan
Write-Host ""

# 1. Verifică statusul Git
Write-Host "1. Status Git:" -ForegroundColor Yellow
git status
Write-Host ""

# 2. Verifică fișierele necomise
Write-Host "2. Fisiere modificate necomise:" -ForegroundColor Yellow
$modified = git diff --name-only
if ($modified) {
    Write-Host "   ATENTIE: Fisiere modificate:" -ForegroundColor Red
    $modified | ForEach-Object { Write-Host "      - $_" -ForegroundColor Gray }
} else {
    Write-Host "   OK: Nu exista fisiere modificate" -ForegroundColor Green
}
Write-Host ""

# 3. Verifică fișierele staged
Write-Host "3. Fisiere staged pentru commit:" -ForegroundColor Yellow
$staged = git diff --cached --name-only
if ($staged) {
    Write-Host "   Fisiere staged:" -ForegroundColor Cyan
    $staged | ForEach-Object { Write-Host "      - $_" -ForegroundColor Gray }
} else {
    Write-Host "   Nu exista fisiere staged" -ForegroundColor Gray
}
Write-Host ""

# 4. Verifică ultimele commit-uri
Write-Host "4. Ultimele 5 commit-uri:" -ForegroundColor Yellow
git log --oneline -5
Write-Host ""

# 5. Verifică dacă branch-ul este în sync cu remote
Write-Host "5. Sincronizare cu remote:" -ForegroundColor Yellow
git fetch --dry-run 2>&1 | Out-Null
$behind = git rev-list --count HEAD..origin/main 2>&1
$ahead = git rev-list --count origin/main..HEAD 2>&1

if ($behind -match '^\d+$' -and [int]$behind -gt 0) {
    Write-Host "   ATENTIE: Local branch este in urma cu $behind commit-uri" -ForegroundColor Red
    Write-Host "   Ruleaza: git pull origin main" -ForegroundColor Yellow
} elseif ($ahead -match '^\d+$' -and [int]$ahead -gt 0) {
    Write-Host "   ATENTIE: Local branch este inainte cu $ahead commit-uri" -ForegroundColor Yellow
    Write-Host "   Ruleaza: git push origin main" -ForegroundColor Yellow
} else {
    Write-Host "   OK: Branch-ul este sincronizat cu remote" -ForegroundColor Green
}
Write-Host ""

# 6. Verifică .gitignore
Write-Host "6. Verificare .gitignore:" -ForegroundColor Yellow
if (Test-Path ".gitignore") {
    Write-Host "   OK: .gitignore exista" -ForegroundColor Green
} else {
    Write-Host "   ATENTIE: .gitignore nu exista" -ForegroundColor Red
}
Write-Host ""

# 7. Verifică workflow-urile GitHub Actions
Write-Host "7. Verificare workflow-uri GitHub Actions:" -ForegroundColor Yellow
if (Test-Path ".github/workflows") {
    $workflows = Get-ChildItem -Path ".github/workflows" -Filter "*.yml" -ErrorAction SilentlyContinue
    if ($workflows) {
        Write-Host "   OK: Workflow-uri gasite:" -ForegroundColor Green
        $workflows | ForEach-Object { Write-Host "      - $($_.Name)" -ForegroundColor Gray }
    } else {
        Write-Host "   ATENTIE: Nu exista workflow-uri" -ForegroundColor Red
    }
} else {
    Write-Host "   ATENTIE: Directorul .github/workflows nu exista" -ForegroundColor Red
}
Write-Host ""

# 8. Link către GitHub Actions
Write-Host "8. Link-uri utile:" -ForegroundColor Yellow
$repo = git remote get-url origin
if ($repo -match 'github\.com[:/]([^/]+)/([^/]+?)(?:\.git)?$') {
    $owner = $matches[1]
    $repoName = $matches[2] -replace '\.git$', ''
    Write-Host "   GitHub Actions: https://github.com/$owner/$repoName/actions" -ForegroundColor Cyan
    Write-Host "   Repository: https://github.com/$owner/$repoName" -ForegroundColor Cyan
}
Write-Host ""

Write-Host "Verificare completa!" -ForegroundColor Green
Write-Host ""
Write-Host "Pentru a vedea log-urile build-urilor iOS:" -ForegroundColor Yellow
Write-Host "   1. Deschide: https://github.com/operatii777-cloud/courier-app/actions" -ForegroundColor Cyan
Write-Host "   2. Click pe un workflow run" -ForegroundColor Cyan
Write-Host "   3. Click pe job-ul 'Build iOS IPA (Unsigned)'" -ForegroundColor Cyan
Write-Host "   4. Vezi log-urile pentru fiecare step" -ForegroundColor Cyan
