# ☁️ Build iOS în Cloud - Ghid Complet

Acest ghid te ajută să compilezi aplicația iOS în cloud și să o distribui prin link de descărcare.

## 🎯 Opțiuni Disponibile

### 1. **GitHub Actions** (Recomandat - Gratuit)
- ✅ Build automat pe Mac în cloud
- ✅ Upload IPA ca artifact (descărcare directă)
- ✅ Integrare cu Firebase App Distribution
- ✅ Gratuit pentru repo-uri publice

### 2. **Codemagic** (Alternativă)
- ✅ Interfață grafică ușoară
- ✅ Build automat
- ✅ Distribuție directă prin link
- ⚠️ Limitări pentru planul gratuit

### 3. **Firebase App Distribution** (Distribuție Beta)
- ✅ Link de descărcare direct
- ✅ Notificări pentru testeri
- ✅ Gratuit
- ⚠️ Necesită Firebase project

## 🚀 Setup GitHub Actions (Recomandat)

### Pasul 1: Pregătește Repository-ul

```bash
cd courier-flutter-app

# Inițializează Git (dacă nu există)
git init
git add .
git commit -m "Initial commit"

# Creează repo pe GitHub și adaugă remote
git remote add origin https://github.com/TU_USERNAME/courier-app.git
git push -u origin main
```

### Pasul 2: Activează GitHub Actions

1. Mergi pe GitHub → Repository → **Actions**
2. Activează **Workflows** dacă este necesar
3. Workflow-ul `build-ios.yml` va apărea automat

### Pasul 3: Rulează Build-ul

1. Mergi la **Actions** tab
2. Selectează **Build iOS App**
3. Click **Run workflow**
4. Alege branch-ul (ex: `main`)
5. Click **Run workflow**

### Pasul 4: Descarcă IPA

1. După ce build-ul se finalizează, mergi la run-ul respectiv
2. Scroll la secțiunea **Artifacts**
3. Click pe **ios-ipa** pentru descărcare
4. Link-ul este permanent pentru 30 de zile

## 🔐 Setup Signing (Opțional - pentru distribuție)

Pentru a crea un IPA semnat (instalabil direct pe iPhone), ai nevoie de:

### A. Apple Developer Account

1. Creează cont la [developer.apple.com](https://developer.apple.com)
2. Cost: $99/an (pentru distribuție App Store/TestFlight)
3. Gratuit pentru testare pe propriul iPhone (limitat)

### B. Generează Certificate și Provisioning Profile

#### Opțiunea 1: Automat (Xcode)

1. Deschide `ios/Runner.xcworkspace` în Xcode
2. Selectează **Runner** target
3. Tab **Signing & Capabilities**
4. Bifează **Automatically manage signing**
5. Selectează **Team**
6. Xcode va genera automat certificate și profile

#### Opțiunea 2: Manual (Apple Developer Portal)

1. Mergi la [developer.apple.com/account](https://developer.apple.com/account)
2. **Certificates, Identifiers & Profiles**
3. Creează:
   - **Certificate** (Development sau Distribution)
   - **App ID** (ex: `com.restaurant.courier`)
   - **Provisioning Profile** (Development sau Ad-Hoc)

### C. Exportă Certificate și Profile

```bash
# Exportă certificate (.p12)
# În Keychain Access:
# 1. Selectează certificate-ul
# 2. Right-click → Export
# 3. Salvează ca .p12 cu parolă

# Exportă provisioning profile
# Copiază din: ~/Library/MobileDevice/Provisioning Profiles/
```

### D. Adaugă Secrets în GitHub

1. Mergi la **Repository → Settings → Secrets and variables → Actions**
2. Adaugă următoarele secrets:

```
IOS_CERTIFICATE_BASE64
  → Base64 encoded .p12 certificate
  → Comandă: base64 -i certificate.p12 | pbcopy

IOS_CERTIFICATE_PASSWORD
  → Parola pentru .p12 certificate

IOS_KEYCHAIN_PASSWORD
  → Parolă pentru keychain temporar (aleatorie)

IOS_PROVISIONING_PROFILE_BASE64
  → Base64 encoded .mobileprovision file
  → Comandă: base64 -i profile.mobileprovision | pbcopy
```

## 🔥 Setup Firebase App Distribution (Link Direct)

### Pasul 1: Creează Firebase Project

1. Mergi la [console.firebase.google.com](https://console.firebase.google.com)
2. Click **Add project**
3. Urmează pașii de setup

### Pasul 2: Configurează App Distribution

1. În Firebase Console → **App Distribution**
2. Click **Get started**
3. Selectează **iOS**
4. Urmează instrucțiunile pentru setup

### Pasul 3: Obține Firebase Token

```bash
# Instalează Firebase CLI
npm install -g firebase-tools

# Login
firebase login

# Obține token
firebase login:ci
```

### Pasul 4: Adaugă Secrets în GitHub

```
FIREBASE_TOKEN
  → Token-ul obținut din `firebase login:ci`

FIREBASE_APP_ID
  → App ID din Firebase Console
  → Format: 1:123456789:ios:abcdef123456
```

### Pasul 5: Link de Descărcare

După build, testerii vor primi:
- **Email** cu link de descărcare
- **Link direct** în Firebase Console
- **QR Code** pentru scanare

## 📱 Setup Codemagic (Alternativă)

### Pasul 1: Creează Cont

1. Mergi la [codemagic.io](https://codemagic.io)
2. Sign up cu GitHub
3. Conectează repository-ul

### Pasul 2: Configurează Build

1. Selectează repository-ul
2. Click **Add application**
3. Selectează **iOS** platform
4. Codemagic va detecta automat configurația Flutter

### Pasul 3: Configurează Signing

1. Upload certificate și provisioning profile
2. Sau folosește Codemagic's automatic signing

### Pasul 4: Build și Distribuție

1. Click **Start new build**
2. Alege branch-ul
3. Build-ul va rula automat
4. Link de descărcare va fi generat automat

## 🎯 Workflow Recomandat

### Pentru Development/Testing Rapid:

1. **Folosește `build-ios-simple.yml`** (unsigned)
2. Build rapid, fără signing
3. Descarcă IPA din GitHub Actions artifacts
4. Semnează local cu Xcode dacă e necesar

### Pentru Distribuție Beta:

1. **Folosește `build-ios.yml`** (cu signing)
2. Configurează Apple Developer Account
3. Adaugă secrets în GitHub
4. Distribuie prin Firebase App Distribution
5. Testerii primesc link direct

### Pentru App Store:

1. Folosește același workflow
2. Configurează Distribution certificate
3. Upload manual în App Store Connect
4. Sau automatizează cu Fastlane

## 📋 Checklist Setup

- [ ] Repository Git creat și pus pe GitHub
- [ ] GitHub Actions activat
- [ ] Workflow `build-ios.yml` adăugat
- [ ] (Opțional) Apple Developer Account creat
- [ ] (Opțional) Certificate și Provisioning Profile generate
- [ ] (Opțional) Secrets adăugate în GitHub
- [ ] (Opțional) Firebase project creat
- [ ] (Opțional) Firebase token adăugat în secrets

## 🔗 Link-uri Utile

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Flutter iOS Deployment](https://docs.flutter.dev/deployment/ios)
- [Firebase App Distribution](https://firebase.google.com/docs/app-distribution)
- [Codemagic Documentation](https://docs.codemagic.io/)

## ❓ FAQ

### Q: Pot să compilez fără Apple Developer Account?
**A:** Da, dar IPA-ul va fi unsigned și nu poate fi instalat direct. Trebuie semnat local.

### Q: Cât costă?
**A:** 
- GitHub Actions: **Gratuit** pentru repo-uri publice
- Firebase App Distribution: **Gratuit**
- Apple Developer: **$99/an** (doar pentru distribuție)

### Q: Cât timp durează un build?
**A:** ~10-15 minute pentru build iOS complet.

### Q: Link-ul de descărcare expiră?
**A:** 
- GitHub Actions artifacts: **30 zile**
- Firebase App Distribution: **Permanent** (până la următorul build)

### Q: Pot automatiza build-ul la fiecare commit?
**A:** Da, workflow-ul rulează automat la push pe `main` branch.

