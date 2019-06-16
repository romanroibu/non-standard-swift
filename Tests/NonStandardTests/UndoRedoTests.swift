import XCTest
import TestUtils
@testable import NonStandard

extension UndoRedo {
    typealias State = (Stack, Value, Stack)
    var state: State { (undoStack, value, redoStack) }
}

struct Bar<T> {
    @UndoRedo var foo: T
}

final class UndoRedoTests: XCTestCase {

    func testUndoRedo() {
        var bar = Bar(foo: 1)
        XCTAssert(bar.$foo.state == ([], 1, []))

        bar.foo = 2
        bar.foo = 3
        bar.foo = 4
        bar.foo = 5
        XCTAssert(bar.$foo.state == ([1, 2, 3, 4], 5, []))

        bar.$foo.undo()
        bar.$foo.undo()
        XCTAssert(bar.$foo.state == ([1, 2], 3, [4, 5]))

        bar.$foo.undo()
        bar.foo = 333
        XCTAssert(bar.$foo.state == ([1, 2], 333, []))

        bar.$foo.undo()
        bar.$foo.undo()
        XCTAssert(bar.$foo.state == ([], 1, [2, 333]))

        bar.$foo.undo() //out-of-bounds
        XCTAssert(bar.$foo.state == ([], 1, [2, 333]))

        bar.$foo.redo()
        bar.$foo.redo()
        XCTAssert(bar.$foo.state == ([1, 2], 333, []))

        bar.$foo.redo() //out-of-bounds
        XCTAssert(bar.$foo.state == ([1, 2], 333, []))
    }

    static var allTests = [
        ("testUndoRedo", testUndoRedo),
    ]
}
