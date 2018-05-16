import CommonLibrary
import Foundation

extension InjectorProtocol {
    public var actionDispatcher: ActionDispatcher { return self.mapper.getSingleton()! }
}

public protocol HasActionDispatcher { }
extension HasActionDispatcher {
    public static var actionDispatcher: ActionDispatcher {
        return injector().actionDispatcher
    }

    public var actionDispatcher: ActionDispatcher {
        return injector().actionDispatcher
    }
}
