# 🔧 Ghid de Troubleshooting Git și GitHub Actions

## 📍 Unde să vezi problemele

### 1. **GitHub Actions - Log-uri Build**
- **Link direct**: https://github.com/operatii777-cloud/courier-app/actions
- **Pași**:
  1. Deschide link-ul de mai sus
  2. Click pe workflow run-ul care a eșuat (roșu) sau în curs (galben)
  3. Click pe job-ul `Build iOS IPA (Unsigned)`
  4. Vezi log-urile pentru fiecare step
  5. Caută erori în roșu sau warning-uri în galben

### 2. **Local Git - Verificare Probleme**

Rulează scriptul de verificare:
```powershell
.\check-git-issues.ps1
```

Sau verifică manual:
```powershell
# Status Git
git status

# Diferențe necomise
git diff

# Ultimele commit-uri
git log --oneline -10

# Sincronizare cu remote
git fetch
git status
```

## 🐛 Probleme Comune și Soluții

### **Problema 1: Build iOS eșuează cu erori de paths**

**Simptome**:
- `Error: ios/Podfile.lock not found`
- `Error: ios/Runner.xcodeproj not found`
- `Error: build/ios/iphoneos/Runner.app not found`

**Soluție**:
1. Verifică că structura iOS există:
   ```bash
   ls -la ios/
   ```
2. Dacă lipsește, creează-o:
   ```bash
   flutter create --platforms=ios .
   ```
3. Verifică că `Podfile.lock` există:
   ```bash
   ls -la ios/Podfile.lock
   ```

### **Problema 2: Cache-uri Git Actions nu funcționează**

**Simptome**:
- Build-ul durează mult (30+ minute)
- CocoaPods se reinstalează la fiecare build
- Pod dependencies se reinstalează

**Soluție**:
1. Verifică că cache keys sunt corecte în workflow:
   - `ios/Podfile.lock` (nu `**/Podfile.lock`)
   - Path-urile sunt corecte: `ios/Pods`, `~/.cocoapods`
2. Verifică în log-uri dacă cache-ul este folosit:
   - Caută: `Cache restored from key:`
   - Dacă nu apare, cache-ul nu funcționează

### **Problema 3: Certificate/Signing Errors**

**Simptome**:
- `Error: No signing certificate found`
- `Error: Provisioning profile not found`
- `Error: codesign failed`

**Soluție**:
1. Pentru build unsigned (development):
   - Workflow-ul `build-ios-simple.yml` ar trebui să funcționeze
   - Verifică că folosește `--no-codesign`
2. Pentru build signed (production):
   - Verifică că secrets sunt setate în GitHub:
     - `IOS_CERTIFICATE_BASE64`
     - `IOS_CERTIFICATE_PASSWORD`
     - `IOS_KEYCHAIN_PASSWORD`
     - `IOS_PROVISIONING_PROFILE_BASE64`

### **Problema 4: Flutter Version Mismatch**

**Simptome**:
- `Error: Flutter version not found`
- `Error: Flutter SDK not found`

**Soluție**:
1. Verifică versiunea în workflow:
   ```yaml
   flutter-version: '3.24.0'
   ```
2. Verifică că versiunea este disponibilă:
   - https://docs.flutter.dev/release/archive

### **Problema 5: CocoaPods Installation Fails**

**Simptome**:
- `Error: gem install cocoapods failed`
- `Error: pod: command not found`

**Soluție**:
1. Verifică că CocoaPods este instalat:
   ```bash
   pod --version
   ```
2. Dacă nu, instalează manual:
   ```bash
   sudo gem install cocoapods
   ```

## 🔍 Debugging Workflow-uri

### **Adaugă logging în workflow:**

```yaml
- name: Debug Info
  run: |
    echo "Flutter version:"
    flutter --version
    echo "iOS structure:"
    ls -la ios/
    echo "Podfile.lock:"
    cat ios/Podfile.lock || echo "Podfile.lock not found"
```

### **Verifică cache-uri:**

```yaml
- name: Check Cache
  run: |
    echo "Cache keys:"
    echo "CocoaPods: ${{ runner.os }}-cocoapods-${{ hashFiles('ios/Podfile.lock') }}"
    echo "Pods: ${{ runner.os }}-pods-${{ hashFiles('ios/Podfile.lock') }}"
```

## 📊 Monitoring Build-uri

### **GitHub Actions Dashboard:**
- **All workflows**: https://github.com/operatii777-cloud/courier-app/actions
- **Specific workflow**: https://github.com/operatii777-cloud/courier-app/actions/workflows/build-ios-simple.yml

### **Notificări:**
- GitHub trimite email-uri când build-urile eșuează
- Poți configura notificări în GitHub Settings → Notifications

## 🛠️ Comenzi Utile

```powershell
# Verifică status Git
git status

# Vezi diferențe
git diff

# Vezi istoric
git log --oneline --graph -10

# Sincronizează cu remote
git fetch
git pull origin main

# Verifică branch-uri
git branch -a

# Verifică remote
git remote -v

# Verifică workflow-uri local
Get-ChildItem .github/workflows/
```

## 📞 Suport

Dacă problemele persistă:
1. Verifică log-urile complete din GitHub Actions
2. Copiază mesajele de eroare exacte
3. Verifică că toate path-urile sunt corecte
4. Verifică că toate dependențele sunt instalate

