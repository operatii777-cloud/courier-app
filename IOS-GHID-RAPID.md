# 🍎 Ghid Rapid iOS - Courier App

## Da, aplicația este disponibilă pentru iOS! ✅

Aplicația Courier este **100% compatibilă cu iOS**. Același cod Flutter rulează atât pe Android, cât și pe iOS.

## 🚀 Cum obțin aplicația iOS?

### Opțiunea 1: Build Automat în Cloud (RECOMANDAT)

**✅ Nu ai nevoie de Mac!**

1. **Declanșează build-ul**:
   - Mergi pe GitHub: [github.com/operatii777-cloud/courier-app/actions](https://github.com/operatii777-cloud/courier-app/actions)
   - Click pe "Build iOS App (Simple - No Signing)"
   - Click pe "Run workflow" → "Run workflow"

2. **Așteaptă build-ul** (durează ~10-15 minute)

3. **Descarcă IPA-ul**:
   - Click pe workflow-ul finalizat
   - Secțiunea "Artifacts" → Download "ios-ipa-unsigned"

4. **Instalează pe iPhone**:
   - Folosește [AltStore](https://altstore.io/) sau [Sideloadly](https://sideloadly.io/)
   - Sau distribue prin TestFlight (necesită Apple Developer account)

### Opțiunea 2: Build Local (necesită Mac)

**📋 Prerequisite**: Mac cu Xcode instalat

```bash
# 1. Instalează dependențele iOS
cd ios
pod install
cd ..

# 2. Build IPA
flutter build ios --release

# 3. IPA-ul va fi în: build/ios/iphoneos/
```

Apoi deschide proiectul în Xcode pentru signing și distribuție:
```bash
open ios/Runner.xcworkspace
```

## 📱 Instalare pe iPhone

### Variantă 1: TestFlight (Recomandat pentru testeri)

1. Ai nevoie de Apple Developer account ($99/an)
2. Upload IPA în App Store Connect
3. Distribue link TestFlight către testeri
4. Testerii instalează din TestFlight app

### Variantă 2: Sideload (Gratis, fără certificat)

**Folosind AltStore**:
1. Instalează [AltStore](https://altstore.io/) pe computer
2. Conectează iPhone la computer
3. Drag & drop IPA-ul în AltStore
4. App-ul se instalează pe iPhone (valabil 7 zile)

**Folosind Sideloadly**:
1. Descarcă [Sideloadly](https://sideloadly.io/)
2. Conectează iPhone la computer
3. Selectează IPA-ul și Apple ID
4. Click "Start" - app-ul se instalează

## 🔐 Certificat de Signing

### Pentru Testare (Gratis)

- Folosește Apple ID personal în Xcode
- App-ul este valid 7 zile
- Trebuie reinstalat săptămânal

### Pentru Distribuție (Plătit)

- Apple Developer Program: $99/an
- Certificat valid 1 an
- Poți distribui prin TestFlight și App Store

## 📚 Documentație Detaliată

- **Setup complet iOS**: [IOS-SETUP.md](./IOS-SETUP.md)
- **Build în cloud**: [CLOUD-BUILD-SETUP.md](./CLOUD-BUILD-SETUP.md)  
- **Compatibilitate**: [IOS-COMPATIBILITY.md](./IOS-COMPATIBILITY.md)
- **Quick Start**: [IOS-QUICK-START.md](./IOS-QUICK-START.md)

## ❓ Întrebări Frecvente

**Q: Pot construi app-ul iOS fără Mac?**  
A: Da! Folosește GitHub Actions pentru build automat în cloud.

**Q: Trebuie să plătesc pentru Apple Developer?**  
A: Nu pentru testare. Pentru App Store și TestFlight, da ($99/an).

**Q: Funcționează toate feature-urile pe iOS?**  
A: Da, 100%! GPS, camera, networking, semnături - totul funcționează.

**Q: Cât durează build-ul în cloud?**  
A: ~10-15 minute pentru un build complet.

**Q: Pot instala IPA-ul direct pe iPhone?**  
A: Nu direct. Ai nevoie de sideload (AltStore/Sideloadly) sau TestFlight.

## 🎯 Status iOS

✅ **iOS 12.0+** - Suportat  
✅ **iPhone** - Complet funcțional  
✅ **iPad** - Complet funcțional  
✅ **Landscape & Portrait** - Suportat  
✅ **Dark Mode** - Suportat  
✅ **GPS Tracking** - Configurat  
✅ **Camera & Photos** - Configurat  
✅ **Background Location** - Configurat

## 🚀 Next Steps

1. **Testează build-ul**: Declanșează un workflow pe GitHub Actions
2. **Instalează pe iPhone**: Folosește AltStore sau TestFlight
3. **Configurează API**: Actualizează `lib/config/api_config.dart` cu server-ul tău
4. **Testează features**: GPS, semnături, navigare

---

**🎉 Aplicația este gata pentru iOS!** Nu există nicio diferență în funcționalitate între Android și iOS.
