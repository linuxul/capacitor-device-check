import XCTest
import Capacitor
import DeviceCheck
@testable import CapacitorDeviceCheckPlugin

class CapacitorDeviceCheckTests: XCTestCase {
    func testPluginRegistration() {
        let plugin = CapacitorDeviceCheckPlugin()

        XCTAssertEqual("CapacitorDeviceCheckPlugin", plugin.identifier)
        XCTAssertEqual("CapacitorDeviceCheck", plugin.jsName)
        XCTAssertEqual(["generateToken"], plugin.pluginMethods.map { $0.name })
        XCTAssertEqual([.promise], plugin.pluginMethods.map { $0.returnType })
    }

    func testGenerateTokenThrowsWhereDeviceCheckIsNotSupported() async throws {
        try XCTSkipIf(DCDevice.current.isSupported, "DeviceCheck is supported here")
        let call = CAPPluginCall(callbackId: "test", methodName: "generateToken", options: [:], success: { _, _ in
            XCTFail("generateToken answers by returning or throwing")
        }, error: { _ in
            XCTFail("generateToken answers by returning or throwing")
        })

        do {
            _ = try await CapacitorDeviceCheckPlugin().generateToken(call)
            XCTFail("generateToken must throw where DeviceCheck is not supported")
        } catch let error as CAPPluginError {
            // The bridge rejects the call with this message and no code, as the method did before.
            XCTAssertEqual(error.message, "DeviceCheck is not supported on this device")
            XCTAssertNil(error.code)
        }
    }
}
