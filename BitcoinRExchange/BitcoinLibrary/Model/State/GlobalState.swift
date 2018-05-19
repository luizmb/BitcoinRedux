import CommonLibrary

public struct GlobalState: Equatable {
    public var bitcoinState = BitcoinState()
    public var applicationState = ApplicationState()

    public init() { }
}
