import Foundation

public typealias DispatchFunction = (Action) -> Void

public class StoreBase<StateType: Equatable, ReducerType> where ReducerType: Reducer, ReducerType.StateType == StateType {

    // MARK: - Private
    private let notifyChanges: (StateType?, StateType) -> Void
    private let reducer: ReducerType

    public init(initialState: StateType,
                reducer: ReducerType) {
        self.currentState = initialState
        self.reducer = reducer

        let pipe = Signal<StateType>.pipe()
        let (sink, signal) = pipe
        stateSignal = signal
        notifyChanges = sink

        stateSignal.onSubscribe = .notify(currentValue: { [weak self] in
            self?.currentState
        })
    }

    private var currentState: StateType {
        didSet(oldValue) {
            DispatchQueue.main.async {
                self.notifyChanges(oldValue, self.currentState)
            }
        }
    }

    private func reduce(_ action: Action) {
        currentState = reducer.reduce(currentState, action: action)
    }

    // MARK: - Public
    let stateSignal: Signal<StateType>

    public func dispatch(_ action: Action) {
        reduce(action)
    }

    public func async(_ action: AnyActionAsync<StateType>) {
        let getState: () -> StateType = { [unowned self] in self.currentState }

        action.execute(
            getState: getState,
            dispatch: { [unowned self] derivedAction in self.dispatch(derivedAction) },
            dispatchAsync: { [unowned self] derivedAsyncAction in self.async(derivedAsyncAction) })
    }

    public func async<ActionAsyncType>(_ action: ActionAsyncType) where ActionAsyncType: ActionAsync, ActionAsyncType.StateType == StateType {
        async(AnyActionAsync(action))
    }
}
