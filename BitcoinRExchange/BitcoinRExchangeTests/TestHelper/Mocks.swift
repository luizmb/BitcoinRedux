@testable import BitcoinLibrary
@testable import BitcoinRExchange
@testable import CommonLibrary
import UIKit

private func defaultDate() -> Date { return Date(timeIntervalSinceReferenceDate: 0) }
private func defaultCurrency() -> Currency { return Currency(code: "EUR", name: "Euro", symbol: "€") }

// Empty protocols
enum FooAction: Action { case foo }
struct AnyError: Error { }
class Cancelable: CancelableTask {
    let id = UUID()
    var cancelCount = 0
    func cancel() { cancelCount += 1 }
}

// Default values
extension NavigationRoute {
    static var mock: NavigationRoute { return NavigationRoute(origin: .root(), destination: .root()) }
}

extension RealTimeResponse {
    static var mock: RealTimeResponse { return RealTimeResponse(updatedTime: defaultDate(), disclaimer: "", bpi: [defaultCurrency(): 1]) }
}

extension BitcoinRealTimeRate {
    static var mock: BitcoinRealTimeRate {
        return BitcoinRealTimeRate(currency: defaultCurrency(),
                                   lastUpdate: defaultDate(),
                                   rate: 1)
    }
}

extension HistoricalResponse {
    static var mock: HistoricalResponse {
        return HistoricalResponse(updatedTime: defaultDate(),
                                  disclaimer: "",
                                  bpi: [
                                    Rate(date: defaultDate().addingDays(0), rate: 1),
                                    Rate(date: defaultDate().addingDays(1), rate: 2),
                                    Rate(date: defaultDate().addingDays(2), rate: 3),
                                    Rate(date: defaultDate().addingDays(3), rate: 4)
                                  ])
    }
}

extension Array where Element == BitcoinHistoricalRate {
    static var mock: [BitcoinHistoricalRate] {
        return [
            BitcoinHistoricalRate(currency: defaultCurrency(),
                                  closedDate: defaultDate().addingDays(0),
                                  rate: 1),
            BitcoinHistoricalRate(currency: defaultCurrency(),
                                  closedDate: defaultDate().addingDays(1),
                                  rate: 2),
            BitcoinHistoricalRate(currency: defaultCurrency(),
                                  closedDate: defaultDate().addingDays(2),
                                  rate: 3),
            BitcoinHistoricalRate(currency: defaultCurrency(),
                                  closedDate: defaultDate().addingDays(3),
                                  rate: 4)
        ]
    }
}

// Mock
class MockRoute: KnownRoute {
    var route = NavigationRoute.mock

    var calledNavigate: (UINavigationController, () -> Void)?
    var onCallNavigate: ((UINavigationController, () -> Void) -> Void)?
    func navigate(_ navigationController: UINavigationController, completion: @escaping () -> Void) {
        onCallNavigate?(navigationController, completion)
        calledNavigate = (navigationController, completion)
    }
}

class MockWindow: NSObject, Window {
    static func create() -> Window {
        let w = MockWindow()
        w.frame = UIScreen.main.bounds
        return w
    }

    @discardableResult func setup(with viewController: UIViewController?) -> Window {
        self.rootViewController = viewController
        self.isKeyWindow = true
        return self
    }

    var frame: CGRect = .zero
    var isKeyWindow: Bool = false
    var rootViewController: UIViewController?
}

class MockApplication: NSObject, Application {
    var keepScreenOnChanged: ((Bool) -> Void)?
    var keepScreenOn: Bool = false {
        didSet {
            keepScreenOnChanged?(keepScreenOn)
        }
    }
}

class MockRepository: RepositoryProtocol {
    var calledSave: (Data, String)?
    var onCallSave: ((Data, String) -> Void)?
    func save(data: Data, filename: String) {
        onCallSave?(data, filename)
        calledSave = (data, filename)
    }

    var calledLoad: String?
    var onCallLoad: ((String) -> (Result<Data>))?
    func load(filename: String) -> Result<Data> {
        let result = onCallLoad?(filename) ?? .error(AnyError())
        calledLoad = filename
        return result
    }
}

class MockAPI: BitcoinRateAPI {
    var calledRequest: (BitcoinEndpoint, (Result<Data>) -> Void)?
    var onCallRequest: ((BitcoinEndpoint, (Result<Data>) -> Void) -> CancelableTask)?
    func request(_ endpoint: BitcoinEndpoint, completion: @escaping (Result<Data>) -> Void) -> CancelableTask {
        let result = onCallRequest?(endpoint, completion) ?? Cancelable()
        calledRequest = (endpoint, completion)
        return result
    }
}

class MockAPIResponse: BitcoinRateAPI {
    init() { }
    var returnError = false

    func request(_ endpoint: BitcoinEndpoint, completion: @escaping (Result<Data>) -> Void) -> CancelableTask {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let retValue: Result<Data>
            switch (self.returnError, endpoint) {
            case (true, _):
                retValue = .error(AnyError())
            case (false, .realtime):
                retValue = .success(MockJson.realTimeResponse.data(using: .utf8)!)
            case (false, .historical):
                retValue = .success(MockJson.historicalResponse.data(using: .utf8)!)
            }
            completion(retValue)
        }

        return Cancelable()
    }
}

class MockActionDispatcher: ActionDispatcher {
    var actions: [Action] = []
    var asyncActions: [Any] = []

    func dispatch(_ action: Action) {
        actions.append(action)
    }

    func async<AppActionAsyncType: AppActionAsync>(_ action: AppActionAsyncType) {
        asyncActions.append(action)
    }
}

// swiftlint:disable line_length
class MockJson {
    static let realTimeResponse = """
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

    static let historicalResponse = """
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
