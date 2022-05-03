import Foundation
import XCTest
import Slimdown

class SlimdownTests: XCTestCase {
    func testHref() {
        let md = #"[xx](yy)"#
        let html = render(text: md)
        XCTAssertEqual(html, #"<a href='yy'>xx</a>"#)
    }
    
    static var allTests = [
        ("testHref", testHref),
    ]
}
