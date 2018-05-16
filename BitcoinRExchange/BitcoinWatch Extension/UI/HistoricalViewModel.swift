import BitcoinLibrary
import CommonLibrary
import Foundation

struct HistoricalViewModel {
    let sections: [HistoricalTableViewSection]?
}

struct HistoricalTableViewSection {
    let title: String
    let rows: [HistoricalTableViewRow]
}

struct HistoricalTableViewRow {
    let date: String
    let rate: String
}

extension HistoricalTableViewSection {
    init(_ state: BitcoinRealTimeRate) {
        self.title = "Real-time rate"
        self.rows = [state].map(HistoricalTableViewRow.init)
    }

    init(_ state: [BitcoinHistoricalRate]) {
        self.title = "Historical rates"
        self.rows = state.map(HistoricalTableViewRow.init)
    }
}

extension HistoricalTableViewRow {
    init(_ state: BitcoinRealTimeRate) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short

        let numberFormatter = NumberFormatter()
        numberFormatter.currencyCode = state.currency.code
        numberFormatter.currencySymbol = state.currency.symbol
        numberFormatter.numberStyle = .currency

        self.date = dateFormatter.string(from: state.lastUpdate)
        self.rate = numberFormatter.string(from: NSDecimalNumber(value: state.rate)) ?? ""
    }

    init(_ state: BitcoinHistoricalRate) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none

        let numberFormatter = NumberFormatter()
        numberFormatter.currencyCode = state.currency.code
        numberFormatter.currencySymbol = state.currency.symbol
        numberFormatter.numberStyle = .currency

        self.date = state.closedDate.formattedFromComponents(styleAttitude: .short,
                                                             year: false,
                                                             month: true,
                                                             day: true,
                                                             hour: false,
                                                             minute: false,
                                                             second: false,
                                                             locale: Locale.current)

        self.rate = numberFormatter.string(from: NSDecimalNumber(value: state.rate)) ?? ""
    }
}
