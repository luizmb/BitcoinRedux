import Foundation

public struct Rate: Codable {
    public let date: Date
    public let rate: Float

    public init(date: Date, rate: Float) {
        self.date = date
        self.rate = rate
    }
}

extension Rate: Equatable {
    public static func ==(lhs: Rate, rhs: Rate) -> Bool {
        return lhs.date == rhs.date && lhs.rate == rhs.rate
    }
}
