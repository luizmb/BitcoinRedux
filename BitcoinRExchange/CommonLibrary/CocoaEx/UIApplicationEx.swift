#if os(iOS)
import UIKit
#endif

@objc public protocol Application: class, NSObjectProtocol {
    var keepScreenOn: Bool { get set }
    @objc var hashValue: Int { get }
}

public func ==(lhs: Application, rhs: Application) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

#if os(iOS)
extension UIApplication: Application {
    public var keepScreenOn: Bool {
        get {
            return self.isIdleTimerDisabled
        }
        set {
            self.isIdleTimerDisabled = newValue
        }
    }
}
#endif
