# 🚀 Instrucțiuni Build APK - Aplicație Flutter Curier

## 📋 Pași pentru crearea APK-ului

### 1. Instalează Flutter

```bash
# Verifică dacă Flutter este instalat
flutter doctor

# Dacă nu este instalat:
# https://docs.flutter.dev/get-started/install
```

### 2. Configurează proiectul

```bash
cd courier-flutter-app
flutter pub get
```

### 3. Configurează API URL

Editează `lib/config/api_config.dart`:

```dart
// Schimbă cu IP-ul tău sau URL-ul backend-ului
static const String baseUrl = 'http://192.168.50.238:3001';
```

### 4. Build APK Debug (pentru testare)

```bash
flutter build apk --debug
```

APK-ul va fi generat în:
```
build/app/outputs/flutter-apk/app-debug.apk
```

### 5. Build APK Release (pentru distribuție)

```bash
flutter build apk --release
```

APK-ul va fi generat în:
```
build/app/outputs/flutter-apk/app-release.apk
```

## 📱 Instalare pe telefon

### Metoda 1: USB (ADB)

```bash
# Conectează telefonul via USB
# Activează "USB Debugging" în Settings → Developer Options

# Instalează APK-ul
flutter install
# sau
adb install build/app/outputs/flutter-apk/app-debug.apk
```

### Metoda 2: Transfer manual

1. Copiază `app-debug.apk` pe telefon (USB, email, cloud)
2. Pe telefon: Settings → Security → "Instalare din surse necunoscute" (ON)
3. Deschide APK-ul și confirmă instalarea

### Metoda 3: QR Code

```bash
# Generează un QR code cu link către APK
# Folosește un serviciu online sau:
# python -m http.server 8000
# Apoi accesează http://[IP]:8000/app-debug.apk
```

## 🔧 Troubleshooting

### "Gradle build failed"
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter build apk --debug
```

### "SDK not found"
- Verifică că Android SDK este instalat
- Setează `ANDROID_HOME` în variabilele de mediu

### "Min SDK version"
- Verifică `android/app/build.gradle` - `minSdkVersion` trebuie să fie 21+

## 📦 Dimensiune APK

- Debug APK: ~50-80 MB
- Release APK: ~20-40 MB (cu optimizări)

## ✅ Verificare

După instalare, verifică:
1. Aplicația se deschide
2. Login funcționează
3. Comenzile se încarcă
4. Navigarea funcționează
5. Confirmarea livrării funcționează

## 🎯 Next Steps

1. **Testează pe dispozitive reale**
2. **Configurează signing pentru release** (dacă vrei să distribui)
3. **Adaugă notificări push** (opțional)
4. **Optimizează pentru producție**

