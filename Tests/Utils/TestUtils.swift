#if !canImport(XCTest)
#error("This target should only be used in test targets.")
#endif

import Foundation
import NonStandard
import XCTest

public func stringify(_ object: Any, options: JSONSerialization.WritingOptions = []) throws -> String {
    let data = try JSONSerialization.data(withJSONObject: object, options: options)
    return String(decoding: data, as: UTF8.self)
}

public func stringify<T: Encodable>(_ encodable: T, options: JSONSerialization.WritingOptions = []) throws -> String {
    let data = try JSONEncoder().encode(encodable)
    return String(decoding: data, as: UTF8.self)
}

//MARK:- Asserts

public func AssertEqualJSON<T: Encodable>(_ expression1: @autoclosure () -> T, _ expression2: @autoclosure () -> [String: Any], _ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(try stringify(expression1()),
                   try stringify(expression2()),
                   message(), file: file, line: line)
}
