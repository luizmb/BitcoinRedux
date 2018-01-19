import UIKit

extension UIWindow {
    class func create() -> UIWindow {
        let window = UIWindow(frame: UIScreen.main.bounds)
        return window
    }

    @discardableResult func setup(with viewController: UIViewController?) -> UIWindow {
        self.rootViewController = viewController
        self.makeKeyAndVisible()
        return self
    }
}
