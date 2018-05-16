import Foundation
import CommonLibrary

public protocol ActionDispatcher {
    func dispatch(_ action: Action)
    func async<AppActionAsyncType: AppActionAsync>(_ action: AppActionAsyncType)
}

