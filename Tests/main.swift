#if os(Linux)
import XCTest
@testable import Slimdown

XCTMain([
    testCase(SlimdownTests.allTests),
])
#endif
