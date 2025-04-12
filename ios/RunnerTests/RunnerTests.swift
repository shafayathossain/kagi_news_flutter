import XCTest
import Flutter
@testable import Runner

class RunnerTests: XCTestCase {
  func testRunner() {
    let testResult = FlutterIntegrationTestRunner().testIntegrationTests()
    XCTAssertTrue(testResult)
  }
}
