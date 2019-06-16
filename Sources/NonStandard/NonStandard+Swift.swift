public func ??<T>(_ lhs: T?, _ rhs: @autoclosure () -> Never) -> T {
    if let value = lhs {
        return value
    } else {
        rhs()
    }
}

extension BidirectionalCollection {

    public func safeIndex(before nextIndex: Index) -> Index? {
        let prevIndex = index(before: nextIndex)
        return startIndex <= prevIndex ? prevIndex : nil
    }
}

extension Collection {

    public func safeIndex(after prevIndex: Index) -> Index? {
        let nextIndex = index(after: prevIndex)
        return nextIndex < endIndex ? nextIndex : nil
    }
}
