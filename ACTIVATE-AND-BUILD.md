# 🚀 Activează GitHub Actions și Rulează Build

Am deschis link-urile în browser. Urmează acești pași:

## ⚙️ Pasul 1: Activează GitHub Actions

În tab-ul deschis cu Settings → Actions:

1. Scroll la secțiunea **"Workflow permissions"**
2. Selectează: **"Read and write permissions"**
3. Bifează: **"Allow GitHub Actions to create and approve pull requests"** (opțional)
4. Click **"Save"** (buton verde)

## 🚀 Pasul 2: Rulează Build-ul

În tab-ul deschis cu Actions:

1. Vei vedea workflow-urile:
   - **Build iOS App (Simple)** ← Folosește acesta pentru început
   - Build iOS App (cu signing)

2. Click pe **"Build iOS App (Simple)"**

3. Click butonul **"Run workflow"** (dreapta sus, lângă "Filter workflows")

4. În dropdown:
   - **Use workflow from**: `main` (sau branch-ul tău)
   - Click **"Run workflow"** (buton verde)

## ⏱️ Pasul 3: Așteaptă Build-ul

- **Durată**: ~10-15 minute
- **Progres**: Poți urmări în timp real
- **Status**: Va deveni verde ✅ când e gata

## 📦 Pasul 4: Descarcă IPA

După ce build-ul se finalizează (✅ verde):

1. Click pe run-ul respectiv (cel cu status verde)
2. Scroll în jos la secțiunea **"Artifacts"**
3. Click pe **"ios-ipa-unsigned"**
4. Click **"Download"** (va descărca un ZIP)
5. **Extrage ZIP-ul** → conține fișierul `.ipa`

## 🔗 Link-uri Rapide

- **Settings → Actions**: https://github.com/operatii777-cloud/courier-app/settings/actions
- **Actions (Workflows)**: https://github.com/operatii777-cloud/courier-app/actions
- **Build iOS Simple**: https://github.com/operatii777-cloud/courier-app/actions/workflows/build-ios-simple.yml

## ✅ Checklist

- [ ] Actions activat (Read and write permissions)
- [ ] Build rulat (Run workflow)
- [ ] Build finalizat (✅ verde)
- [ ] IPA descărcat (din Artifacts)

## 📝 Note

- **IPA Unsigned**: Nu poate fi instalat direct pe iPhone, trebuie semnat local
- **Link Artifacts**: Disponibil **30 de zile**
- **Build Time**: ~10-15 minute (prima dată poate fi mai lent)

**Gata! După ce activezi Actions și rulezi build-ul, revino aici și îți arăt cum să descarci IPA-ul! 🎉**

