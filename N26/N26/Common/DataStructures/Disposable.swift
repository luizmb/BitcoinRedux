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

protocol HasDisposableBag: class {
    var disposables: [Any] { get set }
}

extension Disposable {
    func addDisposableTo(_ disposableBag: inout [Any]) {
        disposableBag.append(self)
    }

    func bind(to parent: HasDisposableBag) {
        parent.disposables.append(self)
    }
}
