#if os(iOS)
import UIKit
#endif
import CommonLibrary

public enum RouterAction: Action {
    #if os(iOS)
    case didStart(Application, UINavigationController)
    #else
    case didStart
    #endif
    case willNavigate(NavigationRoute)
    case didNavigate(NavigationTree)
}
