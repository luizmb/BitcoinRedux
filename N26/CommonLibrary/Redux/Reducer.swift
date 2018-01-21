import Foundation

public protocol Reducer {
    associatedtype StateType
    func reduce(_ currentState: StateType, action: Action) -> StateType
}

private struct _AnyReducer<S, R: Reducer>: Reducer where R.StateType == S {
    typealias StateType = S
    let reducer: R

    func reduce(_ currentState: S, action: Action) -> S {
        return reducer.reduce(currentState, action: action)
    }
}

public struct AnyReducer<S>: Reducer {
    public typealias StateType = S
    let reducerFunction: (S, Action) -> S

    public init<R: Reducer>(_ reducer: R) where R.StateType == S {
        self.reducerFunction = reducer.reduce
    }

    public func reduce(_ currentState: S, action: Action) -> S {
        return reducerFunction(currentState, action)
    }
}
