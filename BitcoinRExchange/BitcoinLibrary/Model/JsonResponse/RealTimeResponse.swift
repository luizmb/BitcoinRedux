import Foundation

public struct RealTimeResponse {
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

extension RealTimeResponse: Equatable {
    public static func == (lhs: RealTimeResponse, rhs: RealTimeResponse) -> Bool {
        return lhs.updatedTime == rhs.updatedTime && lhs.disclaimer == rhs.disclaimer && lhs.bpi == rhs.bpi
    }
}
