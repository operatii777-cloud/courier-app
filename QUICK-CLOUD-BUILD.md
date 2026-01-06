# ⚡ Quick Start - Cloud Build iOS

## 🎯 Scop

Compilează aplicația iOS în cloud și obține link de descărcare **fără să ai Mac**!

## 🚀 Pași Rapizi (5 minute)

### 1. Pregătește Repository-ul

```bash
cd courier-flutter-app

# Dacă nu este repo Git, inițializează
git init
git add .
git commit -m "Initial commit"

# Creează repo pe GitHub (web interface)
# Apoi adaugă remote:
git remote add origin https://github.com/TU_USERNAME/courier-app.git
git push -u origin main
```

### 2. Activează GitHub Actions

1. Mergi pe GitHub → Repository → **Settings**
2. **Actions** → **General**
3. Activează **Workflows** dacă este necesar
4. Workflow-ul `build-ios.yml` va apărea automat

### 3. Rulează Build-ul

1. Mergi la tab-ul **Actions**
2. Selectează **Build iOS App** (sau **Build iOS App (Simple)**)
3. Click **Run workflow** (butonul din dreapta)
4. Alege branch-ul (ex: `main`)
5. Click **Run workflow**

### 4. Așteaptă Build-ul

- ⏱️ Durată: ~10-15 minute
- 📊 Poți urmări progresul în timp real
- ✅ Build-ul va rula pe Mac în cloud

### 5. Descarcă IPA

1. După ce build-ul se finalizează (✅ verde), click pe run-ul respectiv
2. Scroll în jos la secțiunea **Artifacts**
3. Click pe **ios-ipa** sau **ios-ipa-unsigned**
4. **Download ZIP** - conține IPA-ul
5. Link-ul este **permanent pentru 30 de zile**

## 📱 Instalare pe iPhone

### Opțiunea 1: IPA Unsigned (Development)

IPA-ul unsigned **nu poate fi instalat direct**. Trebuie semnat:

1. Transferă IPA-ul pe Mac
2. Deschide în Xcode
3. Semnează cu certificatul tău
4. Instalează pe iPhone

### Opțiunea 2: IPA Signed (cu Apple Developer)

Dacă ai configurat signing în GitHub Secrets:
- IPA-ul va fi semnat automat
- Poate fi instalat direct pe iPhone (prin TestFlight sau Ad-Hoc)

## 🔥 Firebase App Distribution (Link Permanent)

Pentru link permanent de descărcare:

1. Creează Firebase project: [console.firebase.google.com](https://console.firebase.google.com)
2. Activează **App Distribution**
3. Obține token: `firebase login:ci`
4. Adaugă în GitHub Secrets:
   - `FIREBASE_TOKEN`
   - `FIREBASE_APP_ID`
5. După build, testerii primesc **link direct** prin email

## ⚙️ Workflow-uri Disponibile

### `build-ios.yml` (Cu Signing)
- ✅ IPA semnat (instalabil direct)
- ⚠️ Necesită Apple Developer Account
- ⚠️ Necesită certificate și provisioning profile în Secrets

### `build-ios-simple.yml` (Fără Signing)
- ✅ Build rapid
- ✅ Fără configurare complexă
- ⚠️ IPA unsigned (trebuie semnat local)

## 🎯 Recomandare

**Pentru început:** Folosește `build-ios-simple.yml`
- Build rapid
- Fără setup complex
- Descarcă IPA și semnează local dacă e necesar

**Pentru distribuție:** Folosește `build-ios.yml` + Firebase
- IPA semnat automat
- Link permanent pentru testeri
- Notificări automate

## ❓ Probleme Comune

### "Workflow not found"
- Verifică că ai pus workflow-ul în `.github/workflows/`
- Push pe GitHub: `git push origin main`

### "Build failed - CocoaPods error"
- Workflow-ul instalează CocoaPods automat
- Dacă eșuează, verifică `pubspec.yaml` pentru dependențe

### "IPA unsigned - cannot install"
- Normal pentru `build-ios-simple.yml`
- Semnează local cu Xcode sau folosește `build-ios.yml` cu signing

## 📚 Documentație Completă

Vezi **[CLOUD-BUILD-SETUP.md](./CLOUD-BUILD-SETUP.md)** pentru:
- Setup complet cu signing
- Configurare Firebase
- Setup Codemagic (alternativă)
- Troubleshooting detaliat

## 🔗 Link-uri Utile

- [GitHub Actions](https://github.com/features/actions)
- [Firebase App Distribution](https://firebase.google.com/docs/app-distribution)
- [Flutter iOS Deployment](https://docs.flutter.dev/deployment/ios)

