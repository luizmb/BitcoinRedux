import Foundation

public typealias DispatchFunction = (Action) -> Void

open class StoreBase<StateType: Equatable, ReducerType> where ReducerType: Reducer, ReducerType.StateType == StateType {

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

    #if TESTING
    public var currentState: StateType {
        didSet(oldValue) {
            DispatchQueue.main.async {
                self.notifyChanges(oldValue, self.currentState)
            }
        }
    }
    #else
    private var currentState: StateType {
        didSet(oldValue) {
            DispatchQueue.main.async {
                self.notifyChanges(oldValue, self.currentState)
            }
        }
    }
    #endif

    private func reduce(_ action: Action) {
        currentState = reducer.reduce(currentState, action: action)
    }

    // MARK: - Public
    open let stateSignal: Signal<StateType>

    open func dispatch(_ action: Action) {
        reduce(action)
    }

    open func async(_ action: AnyActionAsync<StateType>) {
        let getState: () -> StateType = { [unowned self] in self.currentState }

        action.execute(
            getState: getState,
            dispatch: { [unowned self] derivedAction in self.dispatch(derivedAction) },
            dispatchAsync: { [unowned self] derivedAsyncAction in self.async(derivedAsyncAction) })
    }

    open func async<ActionAsyncType>(_ action: ActionAsyncType) where ActionAsyncType: ActionAsync, ActionAsyncType.StateType == StateType {
        async(AnyActionAsync(action))
    }
}
