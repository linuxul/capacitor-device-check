import XCTest
@testable import CapacitorDeviceCheckPlugin

class CapacitorDeviceCheckTests: XCTestCase {
    func testPluginRegistration() {
        let plugin = CapacitorDeviceCheckPlugin()

        XCTAssertEqual("CapacitorDeviceCheckPlugin", plugin.identifier)
        XCTAssertEqual("CapacitorDeviceCheck", plugin.jsName)
        XCTAssertEqual(["generateToken"], plugin.pluginMethods.map { $0.name })
        for method in plugin.pluginMethods {
            XCTAssertTrue(plugin.responds(to: method.selector), "\(method.name) is not exposed to Objective-C")
        }
    }
}
