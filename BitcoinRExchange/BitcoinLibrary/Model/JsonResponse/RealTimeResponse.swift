import Foundation

public struct RealTimeResponse: Equatable {
    public static let cacheFile = "realtime_cache.bin"
    public let updatedTime: Date
    public let disclaimer: String?
    public let bpi: [Currency: Float]

    public init(updatedTime: Date, disclaimer: String?, bpi: [Currency: Float]) {
        self.updatedTime = updatedTime
        self.disclaimer = disclaimer
        self.bpi = bpi
    }
}
