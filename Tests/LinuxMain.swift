import XCTest
import NonStandardTests

var tests: [XCTestCaseEntry] = []
tests += BidirectionalCollectionTests.allTests()
tests += CollectionTests.allTests()
tests += ExpirableTests.allTests()
XCTMain(tests)
