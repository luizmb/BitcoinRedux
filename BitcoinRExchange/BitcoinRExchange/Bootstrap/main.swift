import Foundation

import UIKit

let args = UnsafeMutableRawPointer(CommandLine.unsafeArgv).bindMemory(to: UnsafeMutablePointer<Int8>.self, capacity: Int(CommandLine.argc))

#if TESTING
final class MockAppDelegate: UIResponder, UIApplicationDelegate {
}
UIApplicationMain(CommandLine.argc, args, nil, NSStringFromClass(MockAppDelegate.self))
#else
UIApplicationMain(CommandLine.argc, args, nil, NSStringFromClass(AppDelegate.self))
#endif
