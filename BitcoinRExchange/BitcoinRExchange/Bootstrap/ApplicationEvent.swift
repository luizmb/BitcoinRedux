import CommonLibrary
import Foundation
import SwiftRex
import UIKit

public enum ApplicationEvent: EventProtocol {
    case boot(application: Application, window: Window, launchOptions: [UIApplicationLaunchOptionsKey: Any]?)
}
