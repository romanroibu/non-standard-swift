public func ??<T>(_ lhs: T?, _ rhs: @autoclosure () -> Never) -> T {
    if let value = lhs {
        return value
    } else {
        rhs()
    }
}

