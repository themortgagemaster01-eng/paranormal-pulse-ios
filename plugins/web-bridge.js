/* ============================================================================
   PHANTASM — native magnetometer bridge
   ----------------------------------------------------------------------------
   This is the ONLY change to index.html needed to make the native build read
   real EMF on iPhone. It tells the app: "if you're running inside the native
   Capacitor shell, use the native magnetometer plugin; otherwise fall back to
   the web magnetometer (Android Chrome) or the demo field (iPhone Safari)."

   HOW TO WIRE IT IN (see SETUP.md Step 7):
   1. Add this <script> in index.html's <head>, BEFORE your main <script>:
        <script type="module">
          import { Capacitor } from 'https://cdn.jsdelivr.net/npm/@capacitor/core/dist/index.js';
          // (When bundled in the native app, Capacitor is injected automatically —
          //  the registerPlugin call below is what matters.)
        </script>
   2. Inside your existing IIFE, REPLACE the body of startMagnetometer() with the
      version below (it tries native first).
   ========================================================================== */

// Drop-in replacement for startMagnetometer() in index.html:
async function startMagnetometer(){
  // --- Native path (Capacitor iOS/Android) ---
  try{
    if (window.Capacitor && window.Capacitor.isNativePlatform && window.Capacitor.isNativePlatform()){
      const Magnetometer = window.Capacitor.registerPlugin("Magnetometer");
      await Magnetometer.addListener("reading", (d) => {
        // microtesla -> milliGauss: magnitude * 10
        S.current = Math.sqrt(d.x*d.x + d.y*d.y + d.z*d.z) * 10;
      });
      await Magnetometer.start();
      S.mode = "magnetometer";      // shows "LIVE EMF" on iPhone too
      return true;
    }
  }catch(e){ /* fall through to web */ }

  // --- Web path (Android Chrome over HTTPS) ---
  if(!("Magnetometer" in window)) return false;
  try{
    if(navigator.permissions){
      const p = await navigator.permissions.query({name:"magnetometer"}).catch(()=>null);
      if(p && p.state==="denied") return false;
    }
    const mag = new Magnetometer({frequency:20, referenceFrame:"device"});
    mag.addEventListener("reading", ()=>{ S.current = Math.sqrt(mag.x**2+mag.y**2+mag.z**2)*10; });
    mag.addEventListener("error", ()=>{});
    mag.start();
    S.mode = "magnetometer";
    return true;
  }catch(e){ return false; }
  // If both fail, the app already falls back to the demo field automatically.
}
