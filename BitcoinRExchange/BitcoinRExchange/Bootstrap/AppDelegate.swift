import BitcoinLibrary
import CommonLibrary
import UIKit

final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var refreshTimer: Timer?

    override init() {
        super.init()
        DefaultMapResolver.map()
    }

    @objc func refresh() {
        eventHandler.dispatch(BitcoinRateEvent.automaticRefresh)
    }

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow.create() as? UIWindow
        eventHandler.dispatch(ApplicationEvent.boot(application: application,
                                                    window: window!,
                                                    launchOptions: launchOptions))

        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        refreshTimer = Timer.scheduledTimer(timeInterval: 30,
                                            target: self,
                                            selector: #selector(refresh),
                                            userInfo: nil,
                                            repeats: true)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        refreshTimer?.invalidate()
    }
}

extension AppDelegate: HasEventHandler { }
