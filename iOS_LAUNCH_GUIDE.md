# Paranormal Pulse → iOS App Store — Launch Guide

**Goal:** ship the *native* iOS app (real EMF on iPhone) via **Codemagic** cloud build — no Mac needed.
**Status of the code:** ✅ Done. The web app (v5.5) is wired for native EMF, the Capacitor project is set up, the magnetometer plugin and Codemagic build config are in this folder.

What's left is **accounts + plumbing**, in this order. Steps marked 🧑 are yours (accounts/payment/ID); steps marked 🤝 I can drive in your browser like I did for Google Play.

---

## The 3 things only you can start

1. 🧑 **Apple Developer account — $99/year.** Sign up at **developer.apple.com/programs** with your Apple ID. Apple verifies identity; **activation can take 24–48 hours**, so start this first. (Use the same dedicated email if you like.)
2. 🧑 **Codemagic account** — free at **codemagic.io**, sign in with GitHub.
3. 🧑 **Put this project on GitHub** — a new repo (e.g. `paranormal-pulse-ios`) containing everything in this `phantasm-native` folder. (I can walk you through this, or do it with you.)

---

## Full sequence (once the Apple account is active)

### A. Apple side (🧑 with my guidance)
1. **Register the App ID / bundle identifier:** `com.paranormalpulse.app`
   (Apple portal → Certificates, IDs & Profiles → Identifiers → +.)
2. **Create the app in App Store Connect** (appstoreconnect.apple.com → My Apps → +):
   - Name: **Paranormal Pulse**  ·  Bundle ID: `com.paranormalpulse.app`  ·  SKU: `paranormalpulse`
3. **Create an App Store Connect API key** (Users and Access → Integrations → App Store Connect API → +).
   Download the `.p8` file — you'll paste it into Codemagic. **Keep it safe.**

### B. Codemagic side (🤝 I can drive most of this)
4. Connect your GitHub repo in Codemagic. It auto-detects `codemagic.yaml`.
5. Add the **App Store Connect API key** in Codemagic (Team settings → Integrations), named **`ParanormalPulse_ASC`** (matches the yaml).
6. Let Codemagic **auto-manage signing** (it creates the distribution certificate + provisioning profile from your API key).
7. **Start the build.** It runs on a cloud Mac: installs deps → generates the iOS project → adds the EMF plugin → builds a signed `.ipa` → uploads to **TestFlight**.

### C. App Store Connect — listing + submit (🤝 I can drive)
8. Fill the listing (all paste-ready in `Desktop/PHANTASM_Store_Listing.md` → "🍎 APPLE APP STORE PACK"):
   - Subtitle, description, keywords, support URL, **App Privacy** = collects nothing.
   - **Icon:** `outputs/ios/AppStoreIcon_1024_opaque.png`
   - **Screenshots:** `outputs/ios/ios_shot_*.png` (1290×2796)
   - **Age rating** questionnaire (mild horror, no objectionable content).
9. Pick the TestFlight build → **Submit for Review.** Apple review is typically **1–3 days**.

---

## Honest expectations
- The **product is done**; this is packaging. The one part that often needs a debug round or two is the **first Codemagic build** (signing + the native plugin compile) — totally normal for iOS CI. We do that together; the build logs tell us exactly what to fix.
- If you'd rather not iterate at all, the alternative is handing this exact folder to a freelancer for "Capacitor iOS build + App Store submit" (~$300–800 one-time). But Codemagic's free tier should get us there.
- **iPhone reality check:** with this *native* build, EMF is **real** on iPhone (the magnetometer plugin). Camera, mic, EVP, thermal, timeline, reports all work too.

---

## What's in this folder
- `www/` — the current Paranormal Pulse v5.5 app (what users see).
- `capacitor.config.json` — app identity (`com.paranormalpulse.app`, "Paranormal Pulse").
- `package.json` — Capacitor 6.1.x dependencies (pinned).
- `plugins/` — native magnetometer source (real EMF): iOS `.swift` + `.m`, Android `.kt`, web bridge.
- `codemagic.yaml` — the cloud iOS build + TestFlight upload pipeline.
- `add_ios_source.rb` — registers the plugin files into the Xcode project during the build.
- `iOS_LAUNCH_GUIDE.md` — this file.

**Your single next action:** start the **$99 Apple Developer account** (it takes a day or two to activate). Tell me when it's active and we'll do the rest together.
