import XCTest
import NonStandardTests

var tests: [XCTestCaseEntry] = []
tests += NonStandardTests.allTests()
XCTMain(tests)
