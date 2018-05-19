import Foundation
import SwiftRex
#if os(iOS)
import UIKit
#endif

public enum RouterEvent: EventProtocol {
    #if os(iOS)
    case navigateRequest(viewController: UIViewController, route: KnownRoute)
    #else
    case navigateRequest(route: KnownRoute)
    #endif
}
