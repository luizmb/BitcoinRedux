import Foundation
import CommonLibrary

extension InjectorProtocol {
    public var stateProvider: StateProvider { return self.mapper.getSingleton()! }
}

public protocol HasStateProvider { }
extension HasStateProvider {
    public static var stateProvider: StateProvider {
        return injector().stateProvider
    }

    public var stateProvider: StateProvider {
        return injector().stateProvider
    }
}
