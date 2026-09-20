package com.mycompany.capacitor.device.check

import com.getcapacitor.JSObject
import com.getcapacitor.Plugin
import com.getcapacitor.PluginCall
import com.getcapacitor.PluginMethod
import com.getcapacitor.annotation.CapacitorPlugin

@CapacitorPlugin(name = "CapacitorDeviceCheck")
public class CapacitorDeviceCheckPlugin : Plugin() {
    private val implementation = CapacitorDeviceCheck()

    @PluginMethod
    public fun generateToken(call: PluginCall) {
        val ret = JSObject()
        ret.put("token", implementation.generateToken())
        call.resolve(ret)
    }
}
