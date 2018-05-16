import CommonLibrary
import Foundation

extension InjectorProtocol {
    public var bitcoinRateAPI: BitcoinRateAPI { return self.mapper.getSingleton()! }
}

public protocol HasBitcoinRateAPI { }
extension HasBitcoinRateAPI {
    public static var bitcoinRateAPI: BitcoinRateAPI {
        return injector().bitcoinRateAPI
    }

    public var bitcoinRateAPI: BitcoinRateAPI {
        return injector().bitcoinRateAPI
    }
}
