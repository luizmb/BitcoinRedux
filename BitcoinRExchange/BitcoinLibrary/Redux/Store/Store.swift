import CommonLibrary
import Foundation

public protocol AppActionAsync: ActionAsync where StateType == AppState {
}

final public class Store: StoreBase<AppState, EntryPointReducer> {
    public static let shared: Store = {
        let global = Store()
        return global
    }()

    private init() {
        super.init(initialState: AppState(), reducer: EntryPointReducer())
    }
}

extension Store: ActionDispatcher { }
