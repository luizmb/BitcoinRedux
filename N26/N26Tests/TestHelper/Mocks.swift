//
//  EmptyProtocols.swift
//  N26Tests
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import UIKit
@testable import N26

private func defaultDate() -> Date { return Date(timeIntervalSinceReferenceDate: 0) }
private func defaultCurrency() -> Currency { return Currency(code: "EUR", name: "Euro", symbol: "€") }

// Empty protocols
enum FooAction: Action { case foo }
struct AnyError: Error { }
class Cancelable: CancelableTask { func cancel() { } }

// Default values
extension NavigationRoute {
    static var mock: NavigationRoute { return NavigationRoute(origin: .root(), destination: .root()) }
}

extension RealTimeResponse {
    static var mock: RealTimeResponse {return RealTimeResponse(updatedTime: defaultDate(), disclaimer: "", bpi:  [defaultCurrency(): 1]) }
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
    var route: NavigationRoute {
        return NavigationRoute.mock
    }

    var calledNavigate: (UINavigationController, () -> ())?
    var onCallNavigate: ((UINavigationController, () -> ()) -> ())?
    func navigate(_ navigationController: UINavigationController, completion: @escaping () -> ()) {
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
    var rootViewController: UIViewController? = nil
}

class MockApplication: NSObject, Application {
    var keepScreenOnChanged: ((Bool) -> ())?
    var keepScreenOn: Bool = false {
        didSet {
            keepScreenOnChanged?(keepScreenOn)
        }
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
