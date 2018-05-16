#if os(iOS)
import UIKit
#endif

public protocol Startable {
    static func start() -> Self?
}

#if os(iOS)
extension Startable where Self: UIViewController {
    public static func start() -> Self? {
        return Self(nibName: nibName, bundle: nil)
    }
}
#endif
