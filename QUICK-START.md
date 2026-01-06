# 🚀 Quick Start - Aplicație Flutter Curier

## ⚡ Pași rapizi pentru build APK

### 1. Instalează Flutter (dacă nu este instalat)

```bash
# Verifică instalarea
flutter doctor

# Dacă nu este instalat, urmează:
# https://docs.flutter.dev/get-started/install
```

### 2. Configurează proiectul

```bash
cd courier-flutter-app

# Instalează dependențele
flutter pub get
```

### 3. Configurează API URL

Editează `lib/config/api_config.dart`:

```dart
// Schimbă cu IP-ul tău
static const String baseUrl = 'http://192.168.50.238:3001';
```

### 4. Build APK Debug

```bash
flutter build apk --debug
```

APK-ul va fi în: `build/app/outputs/flutter-apk/app-debug.apk`

### 5. Instalează pe telefon

**Opțiunea 1: USB (ADB)**
```bash
flutter install
```

**Opțiunea 2: Transfer manual**
1. Copiază `app-debug.apk` pe telefon
2. Activează "Instalare din surse necunoscute"
3. Deschide APK-ul și instalează

## 📱 Testare

1. Deschide aplicația pe telefon
2. Login: `DEL-B9FC39` / `DEL-B9FC39`
3. Verifică că comenzile se încarcă
4. Testează navigarea și confirmarea livrării

## 🎯 Funcționalități

- ✅ Autentificare
- ✅ Lista comenzilor active
- ✅ Istoric livrări
- ✅ Navigare (Maps, Waze)
- ✅ Apelare client
- ✅ Confirmare livrare cu semnătură
- ✅ Calcul câștiguri

## 📚 Documentație

- `README.md` - Documentație completă
- `BUILD-INSTRUCTIONS.md` - Instrucțiuni detaliate build

