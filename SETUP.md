# PHANTASM → Native App (Capacitor) — Setup Guide

This turns your existing web app into real iOS + Android apps **without rewriting it**. Capacitor wraps your `www/` folder and adds native hooks — most importantly a magnetometer plugin that unlocks **real EMF on iPhone** (the thing Safari can't do).

---

## ⚠️ Read this first — the one hard constraint

| Build | Can you do it on THIS Windows laptop? |
|-------|----------------------------------------|
| **Android app** | ✅ Yes — install Android Studio (free). Publish to Google Play ($25 one-time). |
| **iPhone app** | ❌ No — building an iOS app **requires a Mac with Xcode**. Windows physically cannot compile it. Apple Developer account is $99/year. |

**Your options for the iPhone build (pick one):**
1. **Use a Mac** you own/borrow (even occasionally — you mainly need it to build & submit).
2. **Rent a Mac in the cloud** — e.g. MacinCloud (~$20–30/month), remote-desktop into it.
3. **Cloud build service** — Codemagic or Ionic Appflow build iOS in the cloud from your project (free tiers exist). Easiest if you never want to touch a Mac.
4. **Hire a developer** for the iOS build + submission (one-time, ~$300–800 for just the wrap+submit if the app's already built — which it is).

**Recommended:** do the **Android build yourself here first** (it's free and proves the whole pipeline), then handle iOS via cloud build or a short contractor.

---

## What's in this folder
- `capacitor.config.json` — app identity/config (appId `com.phantasm.investigation`).
- `package.json` — dependencies.
- `www/` — **copy your 5 web files in here** (see `www/_README.txt`).
- `plugins/` — the native magnetometer plugin code + the web bridge:
  - `Android_MagnetometerPlugin.kt`
  - `iOS_MagnetometerPlugin.swift` + `iOS_MagnetometerPlugin.m`
  - `web-bridge.js` — the one edit to `index.html` that uses the native sensor.

---

## Prerequisites to install
- **Node.js** (LTS) — https://nodejs.org  (gives you `npm`/`npx`)
- **Android Studio** — https://developer.android.com/studio  (for the Android build)
- **(iOS only)** a Mac with **Xcode** from the Mac App Store

---

## Step-by-step

**1. Put the web app in place.** Copy `index.html`, `phantasm_landing_page.html`, `manifest.json`, `icon-192.png`, `icon-512.png` from `Desktop\phantasm` into `Desktop\phantasm-native\www\`. Delete `www\_README.txt`.

**2. Open a terminal in this folder** and install:
```
npm install
```

**3. Initialize Capacitor** (accept the defaults; appId/appName come from `capacitor.config.json`):
```
npx cap init PHANTASM com.phantasm.investigation --web-dir=www
```

**4. Add the platforms** you want:
```
npx cap add android
npx cap add ios        # only works/needed on a Mac
```

**5. Sync your web app into them** (re-run this any time you change `www/`):
```
npx cap sync
```

**6. Install the magnetometer plugin code:**
- **Android:** copy `plugins/Android_MagnetometerPlugin.kt` into
  `android/app/src/main/java/com/phantasm/investigation/`.
  Then register it in `MainActivity.java` inside `onCreate` (before `super`), or via the
  `registerPlugin(MagnetometerPlugin.class)` call — see Capacitor docs for your version.
- **iOS (on the Mac):** copy `iOS_MagnetometerPlugin.swift` **and** `iOS_MagnetometerPlugin.m`
  into `ios/App/App/`. The `.m` file is what makes Capacitor expose it to JavaScript.
  Add a usage description in `ios/App/App/Info.plist` if prompted for motion access.

**7. Wire the bridge into the app.** Open `web-bridge.js`, and in `www/index.html` replace the
existing `startMagnetometer()` function with the version in that file. It tries the native
sensor first, then falls back to web/demo. (One small edit — everything else stays the same.)

**8. Build & run:**
```
npx cap open android     # opens Android Studio → press Run on a connected phone/emulator
npx cap open ios         # opens Xcode (Mac) → press Run on a connected iPhone
```
On a real Android phone you'll see **LIVE EMF**. On iPhone, with the plugin in place, you'll
**also** see LIVE EMF — no more "Demo Field."

---

## Publishing
- **Google Play:** in Android Studio, Build → Generate Signed Bundle (.aab). Create a Play
  Console account ($25 once), upload, fill the listing, submit. Review ~1–3 days.
- **App Store:** in Xcode, Product → Archive → Distribute. Apple Developer account ($99/yr),
  upload via App Store Connect, submit. Review ~24–48h.
- **Listing assets you'll need:** app icon (you have one), 5–8 screenshots per platform, a short
  description, and a privacy policy URL (you can host a simple one on the same Netlify site —
  your "How PHANTASM Works" page is most of it already).

---

## Honest notes
- The web app **already works today** — this native step is only about (a) real iPhone EMF and
  (b) being in the app stores. No rush; ship native when the audience justifies the $99/yr + effort.
- Keep all raw sensors **free** in the app (per your plan). Charge for exports/reports/filters via
  RevenueCat later — that's a separate, additive step once the native shell is running.
- If you hand this to a developer: this folder + `plugins/` is your spec. The job is "wrap an
  existing web app in Capacitor and add a magnetometer plugin," which is a small, well-defined task.
