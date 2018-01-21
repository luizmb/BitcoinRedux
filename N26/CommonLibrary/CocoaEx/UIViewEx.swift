import UIKit

extension UIView {
    public static var nibName: String {
        return String(NSStringFromClass(self).split(separator: ".").last!)
    }

    public class func nib() -> UINib {
        return UINib(nibName: nibName, bundle: nil)
    }
}
