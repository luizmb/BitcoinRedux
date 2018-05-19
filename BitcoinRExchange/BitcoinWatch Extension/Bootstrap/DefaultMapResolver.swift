import BitcoinLibrary
import CommonLibrary
import Foundation
import SwiftRex

public class DefaultMapResolver {
    private static let diskCache = DiskCache()

    public static func mapServices() {
        guard let injector = (Injector.shared as? Injector) else { return }

        injector.mapper.mapSingleton(EventHandler.self) { BitcoinStore.shared }
        injector.mapper.mapSingleton(BitcoinRateAPI.self) { BitcoinAPIClient.shared }
        injector.mapper.mapSingleton(RepositoryProtocol.self) { diskCache }
        injector.mapper.mapSingleton(BitcoinStateProvider.self) { BitcoinStore.shared }
    }
}

extension DefaultMapResolver {
    public static func map() {
        mapServices()
    }
}
