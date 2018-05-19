import CommonLibrary
import Foundation
import SwiftRex

final public class BitcoinStore: StoreBase<GlobalState> {
    public override init<M: Middleware>(initialState: GlobalState,
                                        reducer: Reducer<GlobalState>,
                                        middleware: M) where M.StateType == GlobalState {
        super.init(initialState: initialState, reducer: reducer, middleware: middleware)
    }
}
