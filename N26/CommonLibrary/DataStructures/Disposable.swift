import Foundation

public final class Disposable {
    public let dispose: () -> ()
    public init(dispose: @escaping () -> ()) {
        self.dispose = dispose
    }
    
    deinit {
        dispose()
    }
}

public protocol HasDisposableBag: class {
    var disposables: [Any] { get set }
}

extension Disposable {
    public func addDisposableTo(_ disposableBag: inout [Any]) {
        disposableBag.append(self)
    }

    public func bind(to parent: HasDisposableBag) {
        parent.disposables.append(self)
    }
}
