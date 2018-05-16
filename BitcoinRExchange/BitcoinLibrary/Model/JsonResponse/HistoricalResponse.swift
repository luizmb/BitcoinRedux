import Foundation

public struct HistoricalResponse: Equatable {
    public static let cacheFile = "historical_cache.bin"
    public let updatedTime: Date
    public let disclaimer: String?
    public let bpi: [Rate]

    public init(updatedTime: Date, disclaimer: String?, bpi: [Rate]) {
        self.updatedTime = updatedTime
        self.disclaimer = disclaimer
        self.bpi = bpi
    }
}
