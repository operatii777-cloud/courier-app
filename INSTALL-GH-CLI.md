# Instalare GitHub CLI pentru Creare Automată Repository

## Opțiunea 1: Instalare Rapidă (Recomandat)

### Windows (PowerShell):
```powershell
# Instalează GitHub CLI
winget install --id GitHub.cli

# Sau download direct:
# https://github.com/cli/cli/releases/latest
# Descarcă: gh_X.XX.X_windows_amd64.msi
```

### După instalare:
```powershell
# Autentifică-te
gh auth login

# Apoi rulează:
.\create-repo-and-push.ps1
```

## Opțiunea 2: Creare Manuală (30 secunde)

1. **Deschide**: https://github.com/new
2. **Repository name**: `courier-app`
3. **Visibility**: **Public** ✅
4. **NU bifa** "Add a README file"
5. **NU bifa** "Add .gitignore"
6. **Click**: "Create repository"

Apoi rulează:
```powershell
cd E:\RESTAURANT\restaurant_app\restaurant_app_v3_translation_system\courier-flutter-app
git push -u origin main
```

## Opțiunea 3: GitHub Personal Access Token

1. **Creează token**: https://github.com/settings/tokens/new
2. **Nume**: "Courier App Setup"
3. **Bifează**: `repo` (Full control)
4. **Generate token**
5. **Copiază token-ul**

Apoi:
```powershell
$env:GITHUB_TOKEN='TOKEN_TĂU'
.\create-repo-and-push.ps1
```

