import Foundation

public protocol ActionAsync {
    associatedtype StateType
    func execute(getState: @escaping () -> StateType,
                 dispatch: @escaping DispatchFunction,
                 dispatchAsync: @escaping (AnyActionAsync<StateType>) -> ())
}

public struct AnyActionAsync<S>: ActionAsync {
    public typealias StateType = S
    let executeFunction: (
        @escaping () -> S,
        @escaping DispatchFunction,
        @escaping (AnyActionAsync<StateType>) -> ())
        -> Void

    public init<A: ActionAsync>(_ actionAsync: A) where A.StateType == S {
        self.executeFunction = actionAsync.execute
    }

    public func execute(getState: @escaping () -> S,
                        dispatch: @escaping DispatchFunction,
                        dispatchAsync: @escaping (AnyActionAsync<StateType>) -> ()) {
        return executeFunction(getState, dispatch, dispatchAsync)
    }
}
