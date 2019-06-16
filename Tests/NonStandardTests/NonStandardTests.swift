import XCTest
import TestUtils
@testable import NonStandard

final class BidirectionalCollectionTests: XCTestCase {

    func testSafeIndexBefore() {
        let collection = [1,2,3]
        XCTAssertEqual(collection.safeIndex(before: 3), 2)
        XCTAssertEqual(collection.safeIndex(before: 2), 1)
        XCTAssertEqual(collection.safeIndex(before: 1), 0)
        XCTAssertNil(collection.safeIndex(before: 0))
    }

    static var allTests = [
        ("testSafeIndexBefore", testSafeIndexBefore),
    ]
}

final class CollectionTests: XCTestCase {

    func testSafeIndexAfter() {
        let collection = [1,2,3]
        XCTAssertEqual(collection.safeIndex(after: -1), 0)
        XCTAssertEqual(collection.safeIndex(after: 0), 1)
        XCTAssertEqual(collection.safeIndex(after: 1), 2)
        XCTAssertNil(collection.safeIndex(after: 2))
    }

    static var allTests = [
        ("testSafeIndexAfter", testSafeIndexAfter),
    ]
}


