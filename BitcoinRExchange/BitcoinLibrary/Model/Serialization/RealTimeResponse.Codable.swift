import Foundation

extension RealTimeResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case time
        case disclaimer
        case bpi
    }

    enum TimeCodingKeys: String, CodingKey {
        case updatedTime = "updatedISO"
    }

    struct CurrencyCodingKeys: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        var intValue: Int? { return nil }
        init?(intValue: Int) { return nil }

        static let rateFloat = CurrencyCodingKeys(stringValue: "rate_float")!
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let timeContainer = try container.nestedContainer(keyedBy: TimeCodingKeys.self, forKey: .time)
        let updatedTime = try timeContainer.decode(Date.self, forKey: .updatedTime)
        let disclaimer = try container.decodeIfPresent(String.self, forKey: .disclaimer)
        let bpiContainer = try container.nestedContainer(keyedBy: CurrencyCodingKeys.self, forKey: .bpi)

        var currencies: [Currency: Float] = [:]
        for key in bpiContainer.allKeys {
            let currencyContainer = try bpiContainer.nestedContainer(keyedBy: CurrencyCodingKeys.self, forKey: key)
            let rate = try currencyContainer.decode(Float.self, forKey: .rateFloat)
            let currency = try bpiContainer.decode(Currency.self, forKey: key)
            currencies[currency] = rate
        }

        self.init(updatedTime: updatedTime, disclaimer: disclaimer, bpi: currencies)
    }
}
