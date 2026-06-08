// ANDROID native magnetometer plugin for Capacitor
// Place in: android/app/src/main/java/com/phantasm/investigation/MagnetometerPlugin.kt
// Then register it (see SETUP.md, Step 6).
//
// Reads the raw magnetometer (TYPE_MAGNETIC_FIELD) and streams x/y/z (microtesla)
// to the web layer via the "reading" event.

package com.phantasm.investigation

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import com.getcapacitor.JSObject
import com.getcapacitor.Plugin
import com.getcapacitor.PluginCall
import com.getcapacitor.PluginMethod
import com.getcapacitor.annotation.CapacitorPlugin

@CapacitorPlugin(name = "Magnetometer")
class MagnetometerPlugin : Plugin(), SensorEventListener {

    private var sensorManager: SensorManager? = null
    private var magnetometer: Sensor? = null

    override fun load() {
        sensorManager = context.getSystemService(Context.SENSOR_SERVICE) as SensorManager
        magnetometer = sensorManager?.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD)
    }

    @PluginMethod
    fun start(call: PluginCall) {
        if (magnetometer == null) {
            call.reject("No magnetometer on this device")
            return
        }
        sensorManager?.registerListener(this, magnetometer, SensorManager.SENSOR_DELAY_UI)
        call.resolve()
    }

    @PluginMethod
    fun stop(call: PluginCall) {
        sensorManager?.unregisterListener(this)
        call.resolve()
    }

    override fun onSensorChanged(event: SensorEvent) {
        val data = JSObject()
        data.put("x", event.values[0].toDouble())   // microtesla
        data.put("y", event.values[1].toDouble())
        data.put("z", event.values[2].toDouble())
        notifyListeners("reading", data)
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) { /* no-op */ }
}
