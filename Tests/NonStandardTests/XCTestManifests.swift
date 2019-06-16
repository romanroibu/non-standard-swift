import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(BidirectionalCollectionTests.allTests),
        testCase(CollectionTests.allTests),
        testCase(ExpirableTests.allTests),
    ]
}
#endif
