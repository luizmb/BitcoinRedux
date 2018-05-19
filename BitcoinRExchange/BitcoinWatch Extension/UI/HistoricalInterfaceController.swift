import BitcoinLibrary
import CommonLibrary
import RxSwift
import SwiftRex
import WatchKit

final class HistoricalInterfaceController: WKInterfaceController {
    private let disposeBag = DisposeBag()
    @IBOutlet private var realtimeDateLabel: WKInterfaceLabel!
    @IBOutlet private var realtimeRateLabel: WKInterfaceLabel!
    @IBOutlet private var historicalTable: WKInterfaceTable!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        self.setTitle("Bitcoin Rates")

        stateProvider[\.bitcoinState].subscribe(onNext: { [weak self] state in
            self?.update(state: state)
        }).disposed(by: disposeBag)
    }

    private func update(state: BitcoinState) {
        if let realtimeSection = state.realtimeRate.possibleValue().flatMap(HistoricalTableViewSection.init)?.rows.first {
            realtimeDateLabel.setHidden(false)
            realtimeRateLabel.setHidden(false)
            realtimeDateLabel.setText(realtimeSection.date)
            realtimeRateLabel.setText(realtimeSection.rate)
        } else {
            realtimeDateLabel.setHidden(true)
            realtimeRateLabel.setHidden(true)
        }

        if let historicalSection = state.historicalRates.possibleValue().flatMap(HistoricalTableViewSection.init) {
            historicalTable.setHidden(false)
            historicalTable.setNumberOfRows(historicalSection.rows.count, withRowType: HistoricalRowController.reuseIdentifier)

            historicalSection.rows.enumerated().forEach { index, rowModel in
                guard let controller = self.historicalTable.rowController(at: index) as? HistoricalRowController else { return }

                controller.update(viewModel: rowModel)
            }

        } else {
            historicalTable.setHidden(true)
        }
    }

    @IBAction private func refreshMenuItemTap() {
        eventHandler.dispatch(BitcoinRateEvent.manualRefresh)
    }
}

extension HistoricalInterfaceController: HasBitcoinStateProvider { }
extension HistoricalInterfaceController: HasEventHandler { }
