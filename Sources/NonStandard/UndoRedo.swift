@propertyWrapper
public struct UndoRedo<Value> {

    public typealias Stack = Array<Value>

    private var currentIndex: Stack.Index

    private var historyStack: Stack

    public var value: Value {
        get { historyStack[currentIndex] }
        set {
            historyStack = Array(historyStack[...currentIndex])
            historyStack.append(newValue)
            currentIndex += 1
        }
    }

    public var undoStack: Stack {
        if let lastIndex = historyStack.safeIndex(before: currentIndex) {
            return Array(historyStack[...lastIndex])
        } else {
            return []
        }
    }

    public var redoStack: Stack {
        if let firstIndex = historyStack.safeIndex(after: currentIndex) {
            return Array(historyStack[firstIndex...])
        } else {
            return []
        }
    }

    public init(initialValue: Value) {
        self.currentIndex = 0
        self.historyStack = [initialValue]
    }

    public mutating func undo() {
        if let newIndex = historyStack.safeIndex(before: currentIndex) {
            currentIndex = newIndex
        }
    }

    public mutating func redo() {
        if let newIndex = historyStack.safeIndex(after: currentIndex) {
            currentIndex = newIndex
        }
    }
}

//MARK:- Equatable

extension UndoRedo: Equatable where Value: Equatable {
}

//MARK:- Hashable

extension UndoRedo: Hashable where Value: Hashable {
}
