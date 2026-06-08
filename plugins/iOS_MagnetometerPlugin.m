// iOS registration shim — REQUIRED so Capacitor exposes the Swift plugin to JS.
// Place in: ios/App/App/MagnetometerPlugin.m  (next to the .swift file)

#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>

CAP_PLUGIN(MagnetometerPlugin, "Magnetometer",
    CAP_PLUGIN_METHOD(start, CAPPluginReturnPromise);
    CAP_PLUGIN_METHOD(stop, CAPPluginReturnPromise);
)
