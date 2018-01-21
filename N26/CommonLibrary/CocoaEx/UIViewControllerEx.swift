import UIKit

extension UIViewController {
    public static var nibName: String {
        return String(NSStringFromClass(self).split(separator: ".").last!.dropLast("Controller".count))
    }

    public class func nib() -> UINib {
        return UINib(nibName: nibName, bundle: nil)
    }
}
