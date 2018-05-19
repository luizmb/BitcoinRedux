import CommonLibrary
import Foundation
import SwiftRex

extension InjectorProtocol {
    public var eventHandler: EventHandler { return self.mapper.getSingleton()! }
}

public protocol HasEventHandler { }
extension HasEventHandler {
    public static var eventHandler: EventHandler {
        return injector().eventHandler
    }

    public var eventHandler: EventHandler {
        return injector().eventHandler
    }
}
