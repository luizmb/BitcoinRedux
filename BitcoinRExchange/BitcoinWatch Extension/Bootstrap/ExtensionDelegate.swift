import BitcoinLibrary
import CommonLibrary
import WatchKit

class ExtensionDelegate: NSObject, WKExtensionDelegate {
    var refreshTimer: Timer?

    override init() {
        super.init()
        DefaultMapResolver.map()
    }

    @objc func refresh() {
        actionDispatcher.async(BitcoinRateRequest.realtimeRefresh(isManual: false))
        actionDispatcher.async(BitcoinRateRequest.historicalDataRefresh(isManual: false))
    }

    func applicationDidFinishLaunching() {
        actionDispatcher.async(BootstrapRequest.boot)
        actionDispatcher.async(BitcoinRateRequest.realtimeCache)
        actionDispatcher.async(BitcoinRateRequest.historicalCache)
    }

    func applicationDidBecomeActive() {
        refreshTimer = Timer.scheduledTimer(timeInterval: 30,
                                            target: self,
                                            selector: #selector(refresh),
                                            userInfo: nil,
                                            repeats: true)
        refreshTimer?.fire()
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
        refreshTimer?.invalidate()
    }

    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        for task in backgroundTasks {
            // Use a switch statement to check the task type
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                // Be sure to complete the background task once you’re done.
                backgroundTask.setTaskCompletedWithSnapshot(false)
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                // Snapshot tasks have a unique completion call, make sure to set your expiration date
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                // Be sure to complete the connectivity task once you’re done.
                connectivityTask.setTaskCompletedWithSnapshot(false)
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                // Be sure to complete the URL session task once you’re done.
                urlSessionTask.setTaskCompletedWithSnapshot(false)
            default:
                // make sure to complete unhandled task types
                task.setTaskCompletedWithSnapshot(false)
            }
        }
    }
}

extension ExtensionDelegate: HasActionDispatcher { }
