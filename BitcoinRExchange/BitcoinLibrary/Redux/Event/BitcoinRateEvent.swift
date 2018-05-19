import Foundation
import SwiftRex

public enum BitcoinRateEvent: EventProtocol {
    case setup
    case manualRefresh
    case automaticRefresh
}
