import CommonLibrary
import Foundation

extension InjectorProtocol {
    public var stateProvider: BitcoinStateProvider { return self.mapper.getSingleton()! }
}

public protocol HasBitcoinStateProvider { }
extension HasBitcoinStateProvider {
    public static var stateProvider: BitcoinStateProvider {
        return injector().stateProvider

    }

    public var stateProvider: BitcoinStateProvider {
        return injector().stateProvider
    }
}
