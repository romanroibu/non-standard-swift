import Foundation

// See: https://twitter.com/v_pradeilles/status/1136791629946220544

@propertyWrapper
public struct Expirable<Value: ExpressibleByNilLiteral> {

    public let duration: TimeInterval

    private var expirationDate: Date = Date()

    private var innerValue: Value = nil

    public var value: Value {
        get { hasExpired ? nil : innerValue }
        set {
            innerValue = newValue
            expirationDate = Date().addingTimeInterval(duration)
        }
    }

    private var hasExpired: Bool {
        return expirationDate < Date()
    }

    public init(duration: TimeInterval) {
        self.duration = duration
    }
}
