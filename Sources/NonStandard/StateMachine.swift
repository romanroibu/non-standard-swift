///
/// Read more about finite state machines
/// [here](https://en.wikipedia.org/wiki/Finite-state_machine).
public protocol StateMachine {

    associatedtype Input
    associatedtype Output
    associatedtype State: Equatable
    associatedtype InitialContext = Void

    static var allStates: [State] { get }
    static func initialState(withContext context: InitialContext) -> State
    static func isFinal(state: State) -> Bool
    static func transition(input: Input) -> Output

    var currentState: State { get set }
    var isFinished: Bool { get }
    mutating func restart(withContext context: InitialContext)

    init(state: State)
    init(context: InitialContext)
}

extension StateMachine {

    public var isFinished: Bool {
        return Self.isFinal(state: self.currentState)
    }

    public init(context: InitialContext) {
        let state = Self.initialState(withContext: context)
        self.init(state: state)
    }

    public mutating func restart(withContext context: InitialContext) {
        self.currentState = Self.initialState(withContext: context)
    }
}

extension StateMachine where InitialContext == Void {

    public static var initialState: State {
        return Self.initialState(withContext: ())
    }

    public mutating func restart() {
        self.restart(withContext: ())
    }
}

extension StateMachine where InitialContext: ExpressibleByNilLiteral {

    public static var initialState: State {
        return Self.initialState(withContext: nil)
    }

    public mutating func restart() {
        self.restart(withContext: nil)
    }
}

extension StateMachine where Self == State {
    public init(state: State) {
        self = state
    }
}

extension StateMachine where Self == State, Self: CaseIterable {

    public static var allStates: [State] {
        return Array(self.allCases)
    }
}

extension StateMachine where Self == State, Output == State {

    public mutating func transition(input: Input) {
        self = Self.transition(input: input)
    }
}

extension StateMachine where Input == Void {

    public static func transition() -> Output {
        self.transition(input: ())
    }
}

//MARK:- Classifier

///
/// Read more about classifier state machines
/// [here](https://en.wikipedia.org/wiki/Finite-state_machine#Classifiers).
public protocol ClassifierStateMachine: StateMachine where Output == State, InitialContext == Void {

    associatedtype FinalOutput

    var finalOutput: FinalOutput? { get }
}

//MARK:- Acceptor

///
/// Read more about acceptor state machines
/// [here](https://en.wikipedia.org/wiki/Finite-state_machine#Acceptors_(recognizers)).
public protocol AcceptorStateMachine: ClassifierStateMachine where FinalOutput == Bool {

    static var acceptedState: State { get }
    static var rejectedState: State { get }

    var isAccepted: Bool { get }
}

extension AcceptorStateMachine {

    public static func isFinal(state: State) -> Bool {
        return state == Self.acceptedState
            || state == Self.rejectedState
    }

    public var finalOutput: FinalOutput? {
        guard Self.isFinal(state: currentState) else {
            return nil
        }

        assert(Self.acceptedState != Self.rejectedState)
        return currentState == Self.acceptedState
    }

    public var isAccepted: Bool {
        return finalOutput ?? false
    }

    public var isRejected: Bool {
        return !(finalOutput ?? true)
    }
}

//MARK:- Transducer

///
/// Read more about transducer state machines
/// [here](https://en.wikipedia.org/wiki/Finite-state_machine#Transducers).
public protocol TransducerStateMachine: StateMachine where Output == (state: State, action: EntryAction) {
    associatedtype EntryAction
}

//MARK:- Moore machine

///
/// Read more about Moore state machines
/// [here](https://en.wikipedia.org/wiki/Finite-state_machine#Transducers) and
/// [here](https://en.wikipedia.org/wiki/Moore_machine).
public protocol MooreStateMachine: TransducerStateMachine where Input == Void {
}

extension MooreStateMachine {

    public mutating func transition() -> EntryAction {
        let (state, action) = Self.transition()
        self.currentState = state
        return action
    }
}

//MARK:- Mealy machine

///
/// Read more about Mealy state machines
/// [here](https://en.wikipedia.org/wiki/Finite-state_machine#Transducers) and
/// [here](https://en.wikipedia.org/wiki/Mealy_machine).
public protocol MealyStateMachine: TransducerStateMachine {
}

extension MealyStateMachine {

    public mutating func transition(input: Input) -> EntryAction {
        let (state, action) = Self.transition(input: input)
        self.currentState = state
        return action
    }
}

//MARK:- Generator

///
/// Read more about generator state machines
/// [here](https://en.wikipedia.org/wiki/Finite-state_machine#Generators).
public protocol GeneratorStateMachine: StateMachine, IteratorProtocol where Input == Void, Output == (state: State, partial: PartialOutput?), Element == PartialOutput {

    associatedtype PartialOutput

    static var finalState: State? { get }

    mutating func transition() -> PartialOutput?
}

extension GeneratorStateMachine {

    public static func isFinal(state: State) -> Bool {
        return state == finalState
    }

    public mutating func transition() -> PartialOutput? {
        let (state, partial) = Self.transition()
        self.currentState = state
        return partial
    }

    //MARK: IteratorProtocol

    mutating func next() -> PartialOutput? {
        return transition()
    }
}

public struct GeneratorSequence<GSM: GeneratorStateMachine>: Sequence {

    public typealias InitialContext = GSM.InitialContext

    private let initialContext: InitialContext

    public init(_ initialContext:  InitialContext) {
        self.initialContext = initialContext
    }

    public func makeIterator() -> GSM {
        return GSM(context: self.initialContext)
    }
}

extension AnySequence {

    public init<GSM: GeneratorStateMachine>(_ generator: @autoclosure () -> GSM) where GSM.Element == Element {
        let gen = generator()
        self.init { gen }
    }
}
