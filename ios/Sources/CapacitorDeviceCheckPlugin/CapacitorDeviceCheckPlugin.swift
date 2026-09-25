import Foundation
import Capacitor
import DeviceCheck

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(CapacitorDeviceCheckPlugin)
public class CapacitorDeviceCheckPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "CapacitorDeviceCheckPlugin"
    public let jsName = "CapacitorDeviceCheck"
    public let pluginMethods: [CAPPluginMethod] = [
        .async("generateToken", CapacitorDeviceCheckPlugin.generateToken)
    ]

    // generateToken touches no UIKit state, so it does not need the main actor.
    func generateToken(_ call: CAPPluginCall) async throws -> JSObject {
        guard DCDevice.current.isSupported == true else {
            throw CAPPluginError("DeviceCheck is not supported on this device")
        }
        let deviceToken: String = try await withCheckedThrowingContinuation { continuation in
            // DeviceCheck calls the handler once.
            DCDevice.current.generateToken { tokenData, error in
                if let error {
                    continuation.resume(throwing: CAPPluginError("DeviceCheck error:\(error.localizedDescription)", underlyingError: error))
                } else if let deviceToken = tokenData?.base64EncodedString() {
                    continuation.resume(returning: deviceToken)
                } else {
                    continuation.resume(throwing: CAPPluginError("DeviceCheck token encoding failed"))
                }
            }
        }
        return ["token": deviceToken]
    }
}
