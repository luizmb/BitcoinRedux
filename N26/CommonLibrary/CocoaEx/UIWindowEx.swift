import UIKit

@objc public protocol Window: class, NSObjectProtocol {
    static func create() -> Window
    @discardableResult func setup(with viewController: UIViewController?) -> Window
    var frame: CGRect { get set }
    var isKeyWindow: Bool { get }
    var rootViewController: UIViewController? { get set }
    @objc var hashValue: Int { get }
}

public func ==(lhs: Window, rhs: Window) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

extension UIWindow: Window {
    public class func create() -> Window {
        let window = UIWindow(frame: UIScreen.main.bounds)
        return window
    }

    @discardableResult public func setup(with viewController: UIViewController?) -> Window {
        self.rootViewController = viewController
        self.makeKeyAndVisible()
        return self
    }
}
