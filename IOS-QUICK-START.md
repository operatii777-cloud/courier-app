# 🚀 Quick Start iOS - Aplicația Courier

## ⚡ Pași Rapizi

### 1. Creează Structura iOS (doar prima dată)

```bash
cd courier-flutter-app
flutter create --platforms=ios .
```

### 2. Configurează Info.plist

Copiază permisiunile GPS din `ios/Runner/Info.plist.template` în `ios/Runner/Info.plist`:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Această aplicație necesită acces la locația ta pentru tracking GPS în timpul livrărilor.</string>

<key>NSLocationAlwaysUsageDescription</key>
<string>Această aplicație necesită acces continuu la locația ta pentru tracking GPS.</string>
```

### 3. Instalează Dependențele

```bash
cd ios
pod install
cd ..
```

### 4. Configurează în Xcode

1. Deschide `ios/Runner.xcworkspace` în Xcode
2. Selectează **Runner** target
3. Tab **Signing & Capabilities**
4. Bifează **Automatically manage signing**
5. Selectează **Team** (Apple ID-ul tău)
6. Schimbă **Bundle Identifier** la ceva unic (ex: `com.restaurant.courier`)

### 5. Compilează și Rulează

```bash
# Conectează iPhone-ul la Mac
# Activează "Developer Mode" pe iPhone

# Verifică dispozitivele
flutter devices

# Rulează aplicația
flutter run
```

## ✅ Verificare Rapidă

```bash
# Rulează scriptul de verificare
./setup-ios.ps1

# Sau manual:
flutter doctor
xcodebuild -version
pod --version
```

## 📱 Build pentru Distribuție

```bash
# Build IPA
flutter build ipa

# Fișierul va fi în: build/ios/ipa/
```

## ⚠️ Probleme Comune

### "No iOS devices found"
- Conectează iPhone-ul prin USB
- Activează "Trust This Computer" pe iPhone
- Activează "Developer Mode" în Settings

### "Signing requires a development team"
- Deschide Xcode
- Selectează un Team în Signing & Capabilities

### "CocoaPods not installed"
```bash
sudo gem install cocoapods
cd ios
pod install
```

## 📚 Documentație Completă

Vezi **[IOS-SETUP.md](./IOS-SETUP.md)** pentru ghid detaliat.

