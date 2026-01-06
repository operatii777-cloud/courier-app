# 📱 Configurare și Compilare iOS pentru Aplicația Courier

## ⚠️ Cerințe Preliminare

### 1. Hardware și Software
- **Mac cu macOS** (obligatoriu - Xcode rulează doar pe Mac)
- **Xcode** instalat (cel puțin versiunea 14.0+)
- **Xcode Command Line Tools**:
  ```bash
  xcode-select --install
  ```
- **CocoaPods** (manager de dependențe iOS):
  ```bash
  sudo gem install cocoapods
  ```

### 2. Apple Developer Account
- **Apple ID** (gratuit pentru testare pe propriul iPhone)
- **Apple Developer Program** ($99/an) - necesar pentru:
  - Distribuire în App Store
  - Testare pe mai multe dispozitive
  - Certificare pentru distribuție

## 🚀 Pași de Configurare

### Pasul 1: Creează Structura iOS

Dacă nu există folderul `ios/`, rulează:

```bash
cd courier-flutter-app
flutter create --platforms=ios .
```

Aceasta va crea structura iOS necesară.

### Pasul 2: Configurează Info.plist pentru GPS

Editează `ios/Runner/Info.plist` și adaugă:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Această aplicație necesită acces la locația ta pentru tracking GPS în timpul livrărilor.</string>

<key>NSLocationAlwaysUsageDescription</key>
<string>Această aplicație necesită acces continuu la locația ta pentru tracking GPS în timpul livrărilor.</string>

<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>Această aplicație necesită acces continuu la locația ta pentru tracking GPS în timpul livrărilor.</string>
```

### Pasul 3: Configurează Bundle Identifier

1. Deschide `ios/Runner.xcworkspace` în Xcode
2. Selectează proiectul "Runner" în navigator
3. Selectează target-ul "Runner"
4. Tab "Signing & Capabilities"
5. Schimbă **Bundle Identifier** la ceva unic (ex: `com.restaurant.courier`)
6. Selectează **Team** (Apple Developer Account)

### Pasul 4: Instalează Dependențele Native

```bash
cd ios
pod install
cd ..
```

## 📦 Compilare pentru iPhone

### Opțiunea 1: Debug pe iPhone fizic (conectat prin USB)

```bash
# Conectează iPhone-ul la Mac prin USB
# Activează "Developer Mode" pe iPhone (Settings > Privacy & Security > Developer Mode)

# Verifică dispozitivele disponibile
flutter devices

# Rulează aplicația
flutter run -d <device-id>
```

### Opțiunea 2: Build IPA pentru distribuție

```bash
# Build pentru release
flutter build ios --release

# Sau pentru App Store
flutter build ipa
```

Fișierul `.ipa` va fi generat în `build/ios/ipa/`

### Opțiunea 3: Build prin Xcode (recomandat pentru prima dată)

1. Deschide `ios/Runner.xcworkspace` în Xcode
2. Selectează dispozitivul tău sau simulator
3. Apasă **Run** (⌘R) sau **Product > Run**

## 🔐 Semnare și Certificare

### Pentru Testare (Development)

1. În Xcode, selectează **Runner** target
2. Tab **Signing & Capabilities**
3. Bifează **Automatically manage signing**
4. Selectează **Team** (Apple ID-ul tău)
5. Xcode va genera automat certificatul

### Pentru App Store (Distribution)

1. În Xcode, selectează **Product > Archive**
2. Așteaptă build-ul să se finalizeze
3. Window-ul **Organizer** se va deschide automat
4. Selectează archive-ul și apasă **Distribute App**
5. Alege **App Store Connect**
6. Urmează pașii pentru upload

## 📱 Testare pe iPhone fără App Store

### TestFlight (Recomandat)

1. Upload aplicația în App Store Connect
2. Adaugă testeri în TestFlight
3. Testerii primesc link de instalare

### Ad-Hoc Distribution

1. În Xcode, **Product > Archive**
2. **Distribute App > Ad-Hoc**
3. Exportă `.ipa` file
4. Distribuie manual testerilor (necesită UDID-ul iPhone-ului)

## ⚙️ Configurare Specifică pentru Aplicația Courier

### Permisiuni GPS în Info.plist

Aplicația necesită permisiuni pentru:
- **Location When In Use** - pentru tracking GPS când aplicația rulează
- **Location Always** - pentru tracking continuu (opțional, dar recomandat)

### Background Location (Opțional)

Pentru tracking GPS când aplicația este în background:

1. În Xcode, adaugă **Background Modes** capability
2. Bifează **Location updates**
3. În cod Flutter, folosește `Geolocator.getPositionStream()` în loc de `getCurrentPosition()`

## 🐛 Troubleshooting

### Eroare: "No iOS devices found"
- Verifică că iPhone-ul este conectat prin USB
- Activează "Trust This Computer" pe iPhone
- Activează "Developer Mode" în Settings

### Eroare: "Signing for Runner requires a development team"
- Selectează un Team în Xcode (Signing & Capabilities)
- Sau adaugă Apple ID în Xcode Preferences > Accounts

### Eroare: "CocoaPods not installed"
```bash
sudo gem install cocoapods
cd ios
pod install
```

### Eroare: "Unable to boot simulator"
- Deschide Xcode > Preferences > Components
- Descarcă simulator-ul necesar

## 📝 Note Importante

1. **Flutter funcționează pe iOS** - același cod Dart funcționează pe ambele platforme
2. **Compilarea iOS necesită Mac** - nu poți compila pentru iOS pe Windows
3. **Apple Developer Account** - necesar pentru semnare și distribuție
4. **Testare pe simulator** - poți testa fără iPhone fizic, dar GPS nu va funcționa real

## 🔗 Resurse

- [Flutter iOS Setup](https://docs.flutter.dev/deployment/ios)
- [Xcode Download](https://developer.apple.com/xcode/)
- [Apple Developer](https://developer.apple.com/)

