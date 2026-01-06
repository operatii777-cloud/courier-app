# 🔍 Găsire Flutter SDK

## Comenzi pentru VS Code Terminal

### 1. Caută Flutter în PATH
```powershell
where.exe flutter
```

### 2. Caută în locații comune
```powershell
# Verifică locațiile comune
Test-Path "C:\src\flutter"
Test-Path "C:\flutter"
Test-Path "$env:USERPROFILE\flutter"
Test-Path "$env:USERPROFILE\AppData\Local\flutter"
```

### 3. Caută pe toate unitățile
```powershell
# Caută pe C:\ (limită la 2 nivele pentru viteză)
Get-ChildItem -Path C:\ -Filter "flutter" -Directory -ErrorAction SilentlyContinue -Depth 2 | Select-Object FullName

# Caută pe E:\
Get-ChildItem -Path E:\ -Filter "flutter" -Directory -ErrorAction SilentlyContinue -Depth 2 | Select-Object FullName
```

### 4. Verifică dacă Flutter este instalat
```powershell
# Dacă găsești Flutter SDK, verifică versiunea:
& "C:\src\flutter\bin\flutter.bat" --version
# (Înlocuiește cu calea ta)
```

## 📋 După ce găsești Flutter SDK

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

Sau manual:
1. Settings → System → About → Advanced system settings
2. Environment Variables → Path → Edit
3. New → Adaugă: `C:\src\flutter\bin` (sau calea ta)

### Verifică instalarea
```powershell
flutter doctor
```

## 🎯 Dacă nu găsești Flutter SDK

### Instalează Flutter:
1. Descarcă de pe: https://docs.flutter.dev/get-started/install/windows
2. Extrage în `C:\src\flutter` (sau altă locație)
3. Adaugă `C:\src\flutter\bin` în PATH
4. Rulează `flutter doctor`

## 📝 Note

- Flutter SDK trebuie să conțină folderul `bin` cu `flutter.bat`
- Calea completă ar trebui să fie: `C:\src\flutter\bin\flutter.bat`
- După adăugarea în PATH, repornește VS Code

