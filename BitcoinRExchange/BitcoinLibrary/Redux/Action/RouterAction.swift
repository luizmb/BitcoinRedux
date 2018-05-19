#if os(iOS)
import UIKit
#endif
import CommonLibrary
import SwiftRex

public enum RouterAction: ActionProtocol {
    #if os(iOS)
    case didStart(Application, UINavigationController)
    case navigationStarted(source: UIViewController, route: NavigationRoute)
    #else
    case didStart
    case navigationStarted(route: NavigationRoute)
    #endif
    case didNavigate(NavigationTree)
}
