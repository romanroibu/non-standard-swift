import XCTest
import TestUtils
@testable import NonStandard

enum Tokens {
    @Expirable(duration: 3) static var auth: String?
}

final class ExpirableTests: XCTestCase {

    override func setUp() {
        super.setUp()
        Tokens.auth = nil
    }

    func testExpiration() {
        XCTAssertNil(Tokens.auth)

        Tokens.auth = "aaabbbccc"
        XCTAssertNotNil(Tokens.auth)

        wait(for: 3)
        XCTAssertNil(Tokens.auth)
    }

    static var allTests = [
        ("testExpiration", testExpiration),
    ]
}
