import XCTest
import Foundation
@testable import BitcoinRExchange
@testable import BitcoinLibrary
@testable import CommonLibrary

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
        XCTAssertEqual(realtime.disclaimer, "This data was produced from the CoinDesk Bitcoin Price Index (USD). Non-USD currency data converted using hourly conversion rate from openexchangerates.org")
        XCTAssertEqual(realtime.bpi.count, 2)
        XCTAssertEqual(realtime.bpi.keys.map({ $0.code }).sorted(), ["EUR", "USD"])

        XCTAssertEqual(realtime.bpi.keys.first!.code, "USD")
        XCTAssertEqual(realtime.bpi.keys.first!.name, "United States Dollar")
        XCTAssertEqual(realtime.bpi[realtime.bpi.keys.first!]!, 11366.71, accuracy: 0.00000001)

        XCTAssertEqual(Array(realtime.bpi.keys).last!.code, "EUR")
        XCTAssertEqual(Array(realtime.bpi.keys).last!.name, "Euro")
        XCTAssertEqual(realtime.bpi[Array(realtime.bpi.keys).last!]!, 9288.3525, accuracy: 0.00000001)
    }

    func testDecodeInvalidRealtime() {
        let result: Result<RealTimeResponse> = JsonParser.decode(MockJson.realTimeResponse.replacingOccurrences(of: "time",
                                                                                                       with: "timee").data(using: .utf8)!)
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
        XCTAssertEqual(historical.bpi[13].rate, 14080.2791, accuracy: 0.00000001)
        XCTAssertEqual(historical.bpi[12].date, dateFormatter.date(from: "2018-01-06"))
        XCTAssertEqual(historical.bpi[12].rate, 14245.432, accuracy: 0.00000001)
        XCTAssertEqual(historical.bpi[11].date, dateFormatter.date(from: "2018-01-07"))
        XCTAssertEqual(historical.bpi[11].rate, 13446.3031, accuracy: 0.00000001)
        XCTAssertEqual(historical.bpi[10].date, dateFormatter.date(from: "2018-01-08"))
        XCTAssertEqual(historical.bpi[10].rate, 12508.3026, accuracy: 0.00000001)
        XCTAssertEqual(historical.bpi[9].date, dateFormatter.date(from: "2018-01-09"))
        XCTAssertEqual(historical.bpi[9].rate, 12097.3334, accuracy: 0.00000001)
        XCTAssertEqual(historical.bpi[8].date, dateFormatter.date(from: "2018-01-10"))
        XCTAssertEqual(historical.bpi[8].rate, 12461.2565, accuracy: 0.00000001)
        XCTAssertEqual(historical.bpi[7].date, dateFormatter.date(from: "2018-01-11"))
        XCTAssertEqual(historical.bpi[7].rate, 11037.315, accuracy: 0.00000001)
        XCTAssertEqual(historical.bpi[6].date, dateFormatter.date(from: "2018-01-12"))
        XCTAssertEqual(historical.bpi[6].rate, 11333.0426, accuracy: 0.00000001)
        XCTAssertEqual(historical.bpi[5].date, dateFormatter.date(from: "2018-01-13"))
        XCTAssertEqual(historical.bpi[5].rate, 11630.6038, accuracy: 0.00000001)
        XCTAssertEqual(historical.bpi[4].date, dateFormatter.date(from: "2018-01-14"))
        XCTAssertEqual(historical.bpi[4].rate, 11159.9497, accuracy: 0.00000001)
        XCTAssertEqual(historical.bpi[3].date, dateFormatter.date(from: "2018-01-15"))
        XCTAssertEqual(historical.bpi[3].rate, 11077.3733, accuracy: 0.00000001)
        XCTAssertEqual(historical.bpi[2].date, dateFormatter.date(from: "2018-01-16"))
        XCTAssertEqual(historical.bpi[2].rate, 9259.0765, accuracy: 0.00000001)
        XCTAssertEqual(historical.bpi[1].date, dateFormatter.date(from: "2018-01-17"))
        XCTAssertEqual(historical.bpi[1].rate, 9157.7611, accuracy: 0.00000001)
        XCTAssertEqual(historical.bpi[0].date, dateFormatter.date(from: "2018-01-18"))
        XCTAssertEqual(historical.bpi[0].rate, 9191.014, accuracy: 0.00000001)
    }

    func testDecodeInvalidHistorical() {
        let result: Result<HistoricalResponse> = JsonParser.decode(MockJson.historicalResponse.replacingOccurrences(of: "time",
                                                                                                           with: "timee").data(using: .utf8)!)
        guard case let .error(error) = result else {
            XCTFail("Unexpected success while parsing wrong historical json")
            return
        }

        XCTAssertGreaterThan(error.localizedDescription.count, 0)
    }
}
