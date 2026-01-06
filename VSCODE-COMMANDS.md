# 🔍 Comenzi VS Code - Găsire Flutter SDK

## ⚠️ Important: Android SDK ≠ Flutter SDK

- **Android SDK**: `C:\Users\flori\AppData\Local\Android\Sdk` ✅ (deja găsit)
- **Flutter SDK**: Căutăm separat (de obicei în `C:\src\flutter` sau `C:\flutter`)

## 📋 Comenzi pentru VS Code Terminal

### 1. Caută Flutter în PATH
```powershell
where.exe flutter
```

### 2. Verifică locațiile comune
```powershell
# Locație 1
Test-Path "C:\src\flutter"

# Locație 2
Test-Path "C:\flutter"

# Locație 3
Test-Path "$env:USERPROFILE\flutter"

# Locație 4
Test-Path "$env:USERPROFILE\AppData\Local\flutter"
```

### 3. Caută pe toate unitățile (lent, dar sigur)
```powershell
# Pe C:\ (max 2 nivele pentru viteză)
Get-ChildItem -Path C:\ -Filter "flutter" -Directory -Recurse -Depth 2 -ErrorAction SilentlyContinue | Where-Object { Test-Path "$($_.FullName)\bin\flutter.bat" } | Select-Object FullName

# Pe E:\
Get-ChildItem -Path E:\ -Filter "flutter" -Directory -Recurse -Depth 2 -ErrorAction SilentlyContinue | Where-Object { Test-Path "$($_.FullName)\bin\flutter.bat" } | Select-Object FullName
```

### 4. Dacă găsești Flutter SDK, verifică versiunea
```powershell
# Exemplu (înlocuiește cu calea ta):
& "C:\src\flutter\bin\flutter.bat" --version
```

## 🔧 După ce găsești Flutter SDK

### Adaugă în PATH (temporar - pentru sesiunea curentă)
```powershell
$env:Path += ";C:\src\flutter\bin"
# (Înlocuiește cu calea ta)
```

### Adaugă în PATH (permanent)
```powershell
[Environment]::SetEnvironmentVariable('Path', $env:Path + ';C:\src\flutter\bin', 'User')
# (Înlocuiește cu calea ta)
```

### Verifică instalarea
```powershell
flutter doctor
```

## 📥 Dacă nu găsești Flutter SDK

### Instalează Flutter:
1. Descarcă: https://docs.flutter.dev/get-started/install/windows
2. Extrage în `C:\src\flutter` (sau altă locație)
3. Adaugă `C:\src\flutter\bin` în PATH
4. Repornește VS Code
5. Rulează `flutter doctor`

## 🎯 Quick Check (copiază în VS Code Terminal)

```powershell
$locations = @("C:\src\flutter", "C:\flutter", "$env:USERPROFILE\flutter", "$env:USERPROFILE\AppData\Local\flutter"); foreach ($loc in $locations) { if (Test-Path "$loc\bin\flutter.bat") { Write-Host "✅ Flutter SDK: $loc" -ForegroundColor Green; & "$loc\bin\flutter.bat" --version } }
```

