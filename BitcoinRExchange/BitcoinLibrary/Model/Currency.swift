import Foundation

public struct Currency: Codable {
    public let code: String
    public let name: String
    public var symbol: String?

    enum CodingKeys: String, CodingKey {
        case code
        case name = "description"
        case symbol
    }

    public init(code: String, name: String, symbol: String? = nil) {
        self.code = code
        self.name = name
        self.symbol = symbol
    }
}

extension Currency: Hashable {
    public var hashValue: Int {
        return code.hashValue
    }

    public static func == (lhs: Currency, rhs: Currency) -> Bool {
        return lhs.code == rhs.code
    }
}
