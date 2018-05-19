@testable import BitcoinLibrary
@testable import BitcoinRExchange
@testable import CommonLibrary
import Foundation
import XCTest

// swiftlint:disable all
class ModelSerializationTests: UnitTest {
    func testDecodeValidRealtime() {
        let result: Result<RealTimeResponse> = JsonParser.decode(MockJson.realTimeResponse.data(using: .utf8)!)
        guard case let .success(realtime) = result else {
            XCTFail("Unexpected error while parsing realtime json")
            return
        }

        let dateFormatter = DateFormatter()
        let enUSPosixLocale = Locale(identifier: "en_US_POSIX")
        dateFormatter.locale = enUSPosixLocale
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"

        XCTAssertEqual(realtime.updatedTime, dateFormatter.date(from: "2018-01-19T17:47:00+00:00"))
        let expectedDisclaimer =
            "This data was produced from the CoinDesk Bitcoin Price Index (USD). " +
            "Non-USD currency data converted using hourly conversion rate from openexchangerates.org"
        XCTAssertEqual(realtime.disclaimer, expectedDisclaimer)
        XCTAssertEqual(realtime.bpi.count, 2)
        XCTAssertEqual(realtime.bpi.keys.map({ $0.code }).sorted(), ["EUR", "USD"])

        XCTAssertEqual(realtime.bpi.keys.first!.code, "USD")
        XCTAssertEqual(realtime.bpi.keys.first!.name, "United States Dollar")
        XCTAssertEqual(realtime.bpi[realtime.bpi.keys.first!]!, 11_366.71, accuracy: 0.000_000_01)

        XCTAssertEqual(Array(realtime.bpi.keys).last!.code, "EUR")
        XCTAssertEqual(Array(realtime.bpi.keys).last!.name, "Euro")
        XCTAssertEqual(realtime.bpi[Array(realtime.bpi.keys).last!]!, 9_288.352_5, accuracy: 0.000_000_01)
    }

    func testDecodeInvalidRealtime() {
        let result: Result<RealTimeResponse> =
            JsonParser.decode(MockJson.realTimeResponse
                                      .replacingOccurrences(of: "time", with: "timee")
                                      .data(using: .utf8)!)
        guard case let .error(error) = result else {
            XCTFail("Unexpected success while parsing wrong realtime json")
            return
        }

        XCTAssertGreaterThan(error.localizedDescription.count, 0)
    }

    func testDecodeValidHistorical() {
        let result: Result<HistoricalResponse> = JsonParser.decode(MockJson.historicalResponse.data(using: .utf8)!)
        guard case let .success(historical) = result else {
            XCTFail("Unexpected error while parsing historical json")
            return
        }

        var dateFormatter = DateFormatter()
        let enUSPosixLocale = Locale(identifier: "en_US_POSIX")
        dateFormatter.locale = enUSPosixLocale
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        XCTAssertEqual(historical.updatedTime, dateFormatter.date(from: "2018-01-19T18:03:01+00:00"))
        XCTAssertEqual(historical.disclaimer, "This data was produced from the CoinDesk Bitcoin Price Index. BPI value data returned as EUR.")
        XCTAssertEqual(historical.bpi.count, 14)
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        XCTAssertEqual(historical.bpi[13].date, dateFormatter.date(from: "2018-01-05"))
        XCTAssertEqual(historical.bpi[13].rate, 14_080.279_1, accuracy: 0.000_000_01)
        XCTAssertEqual(historical.bpi[12].date, dateFormatter.date(from: "2018-01-06"))
        XCTAssertEqual(historical.bpi[12].rate, 14_245.432, accuracy: 0.000_000_01)
        XCTAssertEqual(historical.bpi[11].date, dateFormatter.date(from: "2018-01-07"))
        XCTAssertEqual(historical.bpi[11].rate, 13_446.303_1, accuracy: 0.000_000_01)
        XCTAssertEqual(historical.bpi[10].date, dateFormatter.date(from: "2018-01-08"))
        XCTAssertEqual(historical.bpi[10].rate, 12_508.302_6, accuracy: 0.000_000_01)
        XCTAssertEqual(historical.bpi[9].date, dateFormatter.date(from: "2018-01-09"))
        XCTAssertEqual(historical.bpi[9].rate, 12_097.333_4, accuracy: 0.000_000_01)
        XCTAssertEqual(historical.bpi[8].date, dateFormatter.date(from: "2018-01-10"))
        XCTAssertEqual(historical.bpi[8].rate, 12_461.256_5, accuracy: 0.000_000_01)
        XCTAssertEqual(historical.bpi[7].date, dateFormatter.date(from: "2018-01-11"))
        XCTAssertEqual(historical.bpi[7].rate, 11_037.315, accuracy: 0.000_000_01)
        XCTAssertEqual(historical.bpi[6].date, dateFormatter.date(from: "2018-01-12"))
        XCTAssertEqual(historical.bpi[6].rate, 11_333.042_6, accuracy: 0.000_000_01)
        XCTAssertEqual(historical.bpi[5].date, dateFormatter.date(from: "2018-01-13"))
        XCTAssertEqual(historical.bpi[5].rate, 11_630.603_8, accuracy: 0.000_000_01)
        XCTAssertEqual(historical.bpi[4].date, dateFormatter.date(from: "2018-01-14"))
        XCTAssertEqual(historical.bpi[4].rate, 11_159.949_7, accuracy: 0.000_000_01)
        XCTAssertEqual(historical.bpi[3].date, dateFormatter.date(from: "2018-01-15"))
        XCTAssertEqual(historical.bpi[3].rate, 11_077.373_3, accuracy: 0.000_000_01)
        XCTAssertEqual(historical.bpi[2].date, dateFormatter.date(from: "2018-01-16"))
        XCTAssertEqual(historical.bpi[2].rate, 9_259.076_5, accuracy: 0.000_000_01)
        XCTAssertEqual(historical.bpi[1].date, dateFormatter.date(from: "2018-01-17"))
        XCTAssertEqual(historical.bpi[1].rate, 9_157.761_1, accuracy: 0.000_000_01)
        XCTAssertEqual(historical.bpi[0].date, dateFormatter.date(from: "2018-01-18"))
        XCTAssertEqual(historical.bpi[0].rate, 9_191.014, accuracy: 0.000_000_01)
    }

    func testDecodeInvalidHistorical() {
        let result: Result<HistoricalResponse> =
            JsonParser
                .decode(MockJson.historicalResponse
                .replacingOccurrences(of: "time", with: "timee")
                .data(using: .utf8)!)
        guard case let .error(error) = result else {
            XCTFail("Unexpected success while parsing wrong historical json")
            return
        }

        XCTAssertGreaterThan(error.localizedDescription.count, 0)
    }
}
