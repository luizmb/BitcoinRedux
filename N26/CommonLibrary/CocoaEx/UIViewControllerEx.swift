import UIKit

extension UIViewController {
    static var nibName: String {
        return String(NSStringFromClass(self).split(separator: ".").last!.dropLast("Controller".count))
    }

    class func nib() -> UINib {
        return UINib(nibName: nibName, bundle: nil)
    }
}
