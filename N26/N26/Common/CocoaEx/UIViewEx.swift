import UIKit

extension UIView {
    static var nibName: String {
        return String(NSStringFromClass(self).split(separator: ".").last!)
    }

    class func nib() -> UINib {
        return UINib(nibName: nibName, bundle: nil)
    }
}
