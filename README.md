# 📱 Aplicație Flutter - Mod Curier

Aplicație mobilă nativă pentru curieri, conectată la backend-ul Restaurant Admin.

## 🎯 Platforme Suportate

✅ **Android** - Complet funcțional  
✅ **iOS** - Complet funcțional (100% compatibil!)

Aceeași aplicație Flutter rulează nativ pe ambele platforme.

📱 **Vrei aplicația pe iOS?** → Vezi [IOS-GHID-RAPID.md](./IOS-GHID-RAPID.md) pentru instrucțiuni complete!

## 🚀 Instalare

### 1. Instalează Flutter

```bash
# Verifică dacă Flutter este instalat
flutter --version

# Dacă nu este instalat, urmează instrucțiunile:
# https://docs.flutter.dev/get-started/install
```

### 2. Clonează și configurează

```bash
cd courier-flutter-app
flutter pub get
```

### 3. Configurează API URL

Editează `lib/config/api_config.dart` și setează URL-ul backend-ului:

```dart
// Development (IP local)
static const String baseUrl = 'http://192.168.50.238:3001';

// Producție
// static const String baseUrl = 'https://restaurant.ro';
```

### 4. Rulează aplicația

```bash
# Development
flutter run

# Build APK pentru testare
flutter build apk --debug

# APK-ul va fi în: build/app/outputs/flutter-apk/app-debug.apk
```

## 📦 Build Aplicație

### 📱 Build pentru Android (APK)

#### Debug APK (pentru testare)

```bash
flutter build apk --debug
```

APK-ul va fi generat în: `build/app/outputs/flutter-apk/app-debug.apk`

#### Release APK (pentru distribuție)

```bash
flutter build apk --release
```

APK-ul va fi generat în: `build/app/outputs/flutter-apk/app-release.apk`

### 🍎 Build pentru iOS (IPA)

**Opțiune 1: Build în Cloud (Recomandat - fără Mac!)**

Aplicația poate fi compilată pentru iOS direct în GitHub Actions, fără să ai un Mac!

```bash
# 1. Push pe GitHub
git push origin main

# 2. Mergi pe GitHub → Actions → "Build iOS App (Simple)"
# 3. Descarcă IPA-ul din Artifacts după build
```

**Opțiune 2: Build Local (necesită Mac cu Xcode)**

```bash
# Instalează dependențele iOS
cd ios
pod install
cd ..

# Build IPA
flutter build ios --release
```

📚 **Pentru detalii complete iOS**: Vezi [IOS-SETUP.md](./IOS-SETUP.md) și [CLOUD-BUILD-SETUP.md](./CLOUD-BUILD-SETUP.md)

## 🔧 Configurare

### Android

1. **Min SDK Version**: 21 (Android 5.0)
2. **Target SDK Version**: 33+
3. **Internet Permission**: ✅ Configurat automat

### iOS

1. **Min iOS Version**: 12.0
2. **Permissions**: GPS, Camera, Network (configurat automat)
3. **Build**: Disponibil prin GitHub Actions (Cloud) sau Xcode (Mac)

### Funcționalități

- ✅ Autentificare (username/password sau token API)
- ✅ Lista comenzilor active
- ✅ Istoric livrări
- ✅ Navigare (Google Maps, Waze)
- ✅ Apelare client
- ✅ Confirmare livrare cu semnătură
- ✅ Calcul câștiguri
- ✅ Auto-refresh comenzilor

## 📱 Instalare pe Dispozitiv

### Instalare APK pe Android

1. **Transferă APK-ul pe telefon** (USB, email, cloud)
2. **Activează "Instalare din surse necunoscute"**:
   - Settings → Security → Unknown Sources (ON)
3. **Deschide APK-ul** și confirmă instalarea
4. **Deschide aplicația** și autentifică-te

### Instalare IPA pe iOS

1. **Folosește TestFlight** (recomandat pentru testare)
   - Upload IPA în App Store Connect
   - Invită testeri prin TestFlight
2. **Sau instalează direct** (necesită certificat de development)
   - Conectează iPhone la Mac
   - Instalează prin Xcode
3. **Sau folosește serviciu de signing** (ex: AltStore, Sideloadly)

## 🔗 Conectare la Backend

Aplicația se conectează la backend-ul existent:
- API: `http://[IP]:3001/api/couriers/*`
- Autentificare: Bearer Token sau username/password
- WebSocket: pentru notificări în timp real (opțional)

## 📚 Structură Proiect

```
lib/
├── main.dart                 # Entry point
├── config/
│   └── api_config.dart      # Configurare API
├── models/
│   ├── courier.dart         # Model curier
│   └── delivery_order.dart  # Model comandă
├── services/
│   ├── api_service.dart     # Serviciu API
│   └── auth_service.dart    # Serviciu autentificare
├── screens/
│   ├── login_screen.dart    # Ecran login
│   ├── home_screen.dart     # Ecran principal
│   └── delivery_detail_screen.dart
├── widgets/
│   ├── order_card.dart      # Card comandă
│   └── signature_pad.dart   # Pad semnătură
└── utils/
    └── navigation_utils.dart # Utilități navigare
```

## 🎨 Design

Aplicația folosește același design ca aplicația web:
- Dark theme (slate-900 background)
- Carduri albe pentru comenzi
- Butoane colorate pentru acțiuni
- Iconuri Lucide (compatibile cu Flutter)

## 🐛 Debugging

```bash
# Verifică log-urile
flutter logs

# Run cu verbose
flutter run -v

# Verifică erori
flutter analyze
```

## 📱 iOS Support - ✅ 100% Compatible!

**Aplicația este acum 100% compatibilă cu iOS!** 🎉

Același cod Dart rulează pe ambele platforme (Android și iOS) fără modificări.

📋 **Vezi statusul complet**: **[IOS-COMPATIBILITY.md](./IOS-COMPATIBILITY.md)**

### ☁️ **BUILD ÎN CLOUD (Recomandat - Fără Mac!)**

**Compilează aplicația iOS în cloud și descarcă IPA-ul direct!**

👉 **[CLOUD-BUILD-SETUP.md](./CLOUD-BUILD-SETUP.md)** - Ghid complet

**Quick Start Cloud Build:**
```bash
# 1. Rulează scriptul de setup
./setup-cloud-build.ps1

# 2. Push pe GitHub
git add .
git commit -m "Add iOS cloud build"
git push origin main

# 3. Mergi pe GitHub → Actions → Run workflow
# 4. Descarcă IPA din Artifacts (link permanent 30 zile)
```

**Avantaje Cloud Build:**
- ✅ **Nu necesită Mac** - build în cloud
- ✅ **Link de descărcare direct** - după build
- ✅ **Gratuit** - GitHub Actions pentru repo-uri publice
- ✅ **Automatizat** - build la fiecare commit
- ✅ **Firebase Distribution** - link permanent pentru testeri

### 🖥️ Build Local (Mac)

Vezi ghidul complet: **[IOS-SETUP.md](./IOS-SETUP.md)**

**Quick Start:**
```bash
# Creează structura iOS (doar prima dată)
flutter create --platforms=ios .

# Configurează dependențele native
cd ios
pod install
cd ..

# Build pentru iOS
flutter build ios
```

**Notă:** Compilarea iOS local necesită Mac. Pentru Windows, folosește **Cloud Build** (vezi mai sus).

## 📝 Note

- Aplicația necesită conexiune la internet
- Backend-ul trebuie să fie accesibil de pe telefon
- Pentru producție, folosește HTTPS
- **Android**: APK-ul debug poate fi instalat direct pe telefon
- **iOS**: Build disponibil prin GitHub Actions (Cloud) sau Xcode (Mac local)
- **iOS App Store**: Necesită Apple Developer Program ($99/an) pentru publicare

