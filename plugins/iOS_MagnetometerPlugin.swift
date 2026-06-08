// iOS native magnetometer plugin for Capacitor
// Place in: ios/App/App/MagnetometerPlugin.swift  (open the project in Xcode on a Mac)
// Pair it with iOS_MagnetometerPlugin.m (same folder) so Capacitor can see it.
//
// Uses CoreMotion's raw magnetometer. magneticField is in microtesla (x/y/z),
// streamed to the web layer via the "reading" event. THIS is what unlocks real
// EMF on iPhone — the thing Safari/PWA cannot do.

import Foundation
import Capacitor
import CoreMotion

@objc(MagnetometerPlugin)
public class MagnetometerPlugin: CAPPlugin {

    private let motion = CMMotionManager()

    @objc func start(_ call: CAPPluginCall) {
        guard motion.isMagnetometerAvailable else {
            call.reject("No magnetometer on this device")
            return
        }
        motion.magnetometerUpdateInterval = 1.0 / 20.0   // ~20 Hz
        motion.startMagnetometerUpdates(to: OperationQueue.main) { [weak self] (data, _) in
            guard let field = data?.magneticField else { return }
            self?.notifyListeners("reading", data: [
                "x": field.x,   // microtesla
                "y": field.y,
                "z": field.z
            ])
        }
        call.resolve()
    }

    @objc func stop(_ call: CAPPluginCall) {
        motion.stopMagnetometerUpdates()
        call.resolve()
    }
}
