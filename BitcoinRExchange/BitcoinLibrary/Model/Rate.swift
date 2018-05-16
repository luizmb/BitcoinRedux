import Foundation

public struct Rate: Codable, Equatable {
    public let date: Date
    public let rate: Float

    public init(date: Date, rate: Float) {
        self.date = date
        self.rate = rate
    }
}
