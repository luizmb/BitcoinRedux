import BitcoinLibrary
import CommonLibrary
import WatchKit

final class HistoricalRowController: NSObject {
    static let reuseIdentifier = "HistoricalRow"

    @IBOutlet private var dateLabel: WKInterfaceLabel!
    @IBOutlet private var rateLabel: WKInterfaceLabel!

    func update(viewModel: HistoricalTableViewRow) {
        dateLabel.setText(viewModel.date)
        rateLabel.setText(viewModel.rate)
    }
}
