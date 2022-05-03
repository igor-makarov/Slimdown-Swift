import Foundation
import XCTest
import Slimdown

class SlimdownTest: XCTestCase {
    struct Fixture {
        var name: String { inputUrl.deletingPathExtension().lastPathComponent }
        let inputUrl: URL
        let outputUrl: URL
    }

    var fixture: Fixture!

    static let fixtures: [Fixture] = {
        Bundle.module.urls(forResourcesWithExtension: "md", subdirectory: nil)!.map { inputUrl in
            let name = inputUrl.deletingPathExtension().lastPathComponent
            let outputUrl = Bundle.module.url(forResource: name, withExtension: "html")
            return Fixture(inputUrl: inputUrl, outputUrl: outputUrl!)
        }
    }()

    override class var defaultTestSuite: XCTestSuite {
        let suite = XCTestSuite(name: NSStringFromClass(self))

        for fixture in fixtures {
            let test = SlimdownTest(selector: #selector(verifyFixture))
            test.fixture = fixture
            suite.addTest(test)
        }
        return suite
    }

    @objc func verifyFixture() throws {
        let md = try String(contentsOf: fixture.inputUrl)
        let expectedHtml = try String(contentsOf: fixture.outputUrl)
        let html = render(text: md)
        XCTAssertEqual(html, expectedHtml, "failure in \(fixture.name)")
    }

    static var allTests: [(String, (XCTestCase) -> Void)] = [
    ]
}
