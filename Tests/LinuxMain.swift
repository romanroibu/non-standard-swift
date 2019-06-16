import XCTest
import NonStandardTests

var tests: [XCTestCaseEntry] = []
tests += NonStandardTests.allTests()
tests += ExpirableTests.allTests()
XCTMain(tests)
