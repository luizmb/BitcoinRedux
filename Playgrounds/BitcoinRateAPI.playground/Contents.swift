import Foundation
import PlaygroundSupport

class MockedResponses {
    let realTimeResponse = """
        {
            "time": {
                "updated": "Jan 19, 2018 17:47:00 UTC",
                "updatedISO": "2018-01-19T17:47:00+00:00",
                "updateduk": "Jan 19, 2018 at 17:47 GMT"
            },
            "disclaimer": "This data was produced from the CoinDesk Bitcoin Price Index (USD). Non-USD currency data converted using hourly conversion rate from openexchangerates.org",
            "bpi": {
                "USD": {
                    "code": "USD",
                    "rate": "11,366.7100",
                    "description": "United States Dollar",
                    "rate_float": 11366.71
                },
                "EUR": {
                    "code": "EUR",
                    "rate": "9,288.3525",
                    "description": "Euro",
                    "rate_float": 9288.3525
                }
            }
        }
        """
    let historicalResponse = """
        {
            "bpi": {
                "2018-01-05": 14080.2791,
                "2018-01-06": 14245.432,
                "2018-01-07": 13446.3031,
                "2018-01-08": 12508.3026,
                "2018-01-09": 12097.3334,
                "2018-01-10": 12461.2565,
                "2018-01-11": 11037.315,
                "2018-01-12": 11333.0426,
                "2018-01-13": 11630.6038,
                "2018-01-14": 11159.9497,
                "2018-01-15": 11077.3733,
                "2018-01-16": 9259.0765,
                "2018-01-17": 9157.7611,
                "2018-01-18": 9191.014
            },
            "disclaimer": "This data was produced from the CoinDesk Bitcoin Price Index. BPI value data returned as EUR.",
            "time": {
                "updated": "Jan 19, 2018 18:03:01 UTC",
                "updatedISO": "2018-01-19T18:03:01+00:00"
            }
        }
        """
}

public protocol CancelableTask {
    func cancel()
}

extension URLSessionDataTask: CancelableTask {
}

public enum Result<T: Equatable>: Equatable {
    case success(T)
    case error(Error)

    func map<B>(_ transformation: (T) -> (B)) -> Result<B> {
        switch self {
        case .error(let error): return .error(error)
        case .success(let valueT): return .success(transformation(valueT))
        }
    }

    func flatMap<B>(_ transformation: (T) -> (Result<B>)) -> Result<B> {
        switch self {
        case .error(let error): return .error(error)
        case .success(let valueT): return transformation(valueT)
        }
    }

    public static func ==<T>(lhs: Result<T>, rhs: Result<T>) -> Bool {
        switch (lhs, rhs) {
        case (.error(let errorLeft), .error(let errorRight)):
            return errorLeft.localizedDescription == errorRight.localizedDescription
        case (.success(let valueLeft), .success(let valueRight)):
            return valueLeft == valueRight
        default: return false
        }
    }
}

public enum BitcoinEndpoint {
    case realtime(currency: String)
    case historical(currency: String, startDate: Date, endDate: Date)
}

extension BitcoinEndpoint {
    private static func createRequest(url urlString: String,
                                      httpMethod: String,
                                      urlParams: [String: String] = [:]) -> URLRequest {
        let urlSuffix = urlParams.count == 0 ? "" : "?" + urlParams.map { k, v in "\(k)=\(v)" }.joined(separator: "&")
        let url = URL(string: "\(urlString)\(urlSuffix)")!
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        return request
    }

    private var httpMethod: String {
        switch self {
        case .realtime: return "GET"
        case .historical: return "GET"
        }
    }

    var urlRequest: URLRequest {
        switch self {
        case let .realtime(currency):
            return BitcoinEndpoint.createRequest(url: "https://api.coindesk.com/v1/bpi/currentprice/\(currency).json",
                httpMethod: httpMethod)
        case let .historical(currency, startDate, endDate):
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
            return BitcoinEndpoint.createRequest(url: "https://api.coindesk.com/v1/bpi/historical/close.json",
                                          httpMethod: httpMethod,
                                          urlParams: ["currency": currency,
                                                      "start": dateFormatter.string(from: startDate),
                                                      "end": dateFormatter.string(from: endDate)])
        }
    }
}

protocol BitcoinRateAPI {
    func request(_ endpoint: BitcoinEndpoint, completion: @escaping (Result<Data>) -> ()) -> CancelableTask
}

public class URLSessionBitcoinRateAPI: BitcoinRateAPI {
    func request(_ endpoint: BitcoinEndpoint, completion: @escaping (Result<Data>) -> ()) -> CancelableTask {
        let task = URLSession.shared.dataTask(with: endpoint.urlRequest) { data, _, error in
            if let error = error {
                completion(.error(error))
                return
            }

            if let data = data {
                completion(.success(data))
                return
            }

            fatalError("No data and no error")
        }
        task.resume()
        return task
    }
}

public class JsonParser {
    public static func decode<T: Decodable>(_ data: Data) -> Result<T> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do {
            let result = try decoder.decode(T.self, from: data)
            return .success(result)
        } catch {
            return .error(error)
        }
    }
}

public struct RealTimeResponse {
    let updatedTime: Date
    let disclaimer: String?
    let bpi: [Currency: Float]
}

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

extension RealTimeResponse: Equatable {
    public static func ==(lhs: RealTimeResponse, rhs: RealTimeResponse) -> Bool {
        return lhs.updatedTime == rhs.updatedTime && lhs.disclaimer == rhs.disclaimer && lhs.bpi == rhs.bpi
    }
}

public struct Currency: Codable {
    let code: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case code
        case name = "description"
    }
}

extension Currency: Hashable {
    public var hashValue: Int {
        return code.hashValue
    }

    public static func ==(lhs: Currency, rhs: Currency) -> Bool {
        return lhs.code == rhs.code
    }
}

public struct Rate: Codable {
    let date: Date
    let rate: Float
}

extension Rate: Equatable {
    public static func ==(lhs: Rate, rhs: Rate) -> Bool {
        return lhs.date == rhs.date && lhs.rate == rhs.rate
    }
}

public struct HistoricalResponse {
    let updatedTime: Date
    let disclaimer: String?
    let bpi: [Rate]
}

extension HistoricalResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case time
        case disclaimer
        case bpi
    }

    enum TimeCodingKeys: String, CodingKey {
        case updatedTime = "updatedISO"
    }

    struct RateCodingKeys: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        var intValue: Int? { return nil }
        init?(intValue: Int) { return nil }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let timeContainer = try container.nestedContainer(keyedBy: TimeCodingKeys.self, forKey: .time)
        let updatedTime = try timeContainer.decode(Date.self, forKey: .updatedTime)
        let disclaimer = try container.decodeIfPresent(String.self, forKey: .disclaimer)
        let bpiContainer = try container.nestedContainer(keyedBy: RateCodingKeys.self, forKey: .bpi)

        var rates: [Rate] = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        for key in bpiContainer.allKeys {
            let date = dateFormatter.date(from: key.stringValue)!
            let rate = try bpiContainer.decode(Float.self, forKey: key)
            rates.append(Rate(date: date, rate: rate))
        }

        self.init(updatedTime: updatedTime, disclaimer: disclaimer, bpi: rates.sorted(by: { $0.date < $1.date }))
    }
}

extension HistoricalResponse: Equatable {
    public static func ==(lhs: HistoricalResponse, rhs: HistoricalResponse) -> Bool {
        return lhs.updatedTime == rhs.updatedTime && lhs.disclaimer == rhs.disclaimer && lhs.bpi == rhs.bpi
    }
}

extension Date {
    var backToMidnight: Date {
        let calendar = Calendar.current
        return calendar.startOfDay(for: self)
    }

    func addingDays(_ days: Int) -> Date {
        let calendar = Calendar.current
        var daysOffset = DateComponents()
        daysOffset.day = days
        return calendar.date(byAdding: daysOffset, to: self)!
    }
}

let api: BitcoinRateAPI = URLSessionBitcoinRateAPI()
api.request(.realtime(currency: "EUR")) { r in
    let realtime: Result<RealTimeResponse> = r.flatMap(JsonParser.decode)
    dump(realtime)
}

api.request(.historical(currency: "EUR", startDate: Date().backToMidnight.addingDays(-14), endDate: Date())) { r in
    let historical: Result<HistoricalResponse> = r.flatMap(JsonParser.decode)
    dump(historical)
}

PlaygroundPage.current.needsIndefiniteExecution = true
