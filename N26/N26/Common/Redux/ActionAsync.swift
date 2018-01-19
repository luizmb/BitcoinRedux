import Foundation

public protocol ActionAsync {
    associatedtype StateType
    func execute(getState: @escaping () -> StateType, dispatch: @escaping DispatchFunction)
}
