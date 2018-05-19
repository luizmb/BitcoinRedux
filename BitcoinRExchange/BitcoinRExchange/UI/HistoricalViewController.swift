import BitcoinLibrary
import CommonLibrary
import RxSwift
import SwiftRex
import UIKit

final class HistoricalViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let refreshControl = UIRefreshControl()
    private var dataSource: HistoricalDataSource!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var noDataLine1Label: UILabel!
    @IBOutlet private weak var noDataLine2Label: UILabel!
    @IBOutlet private weak var noDataRefreshButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Bitcoin Rates"
        navigationController?.hidesBarsOnSwipe = true
        dataSource = HistoricalDataSource(tableView: tableView)
        stateProvider[\.bitcoinState].subscribe(onNext: { [weak self] state in
            self?.update(state: state)
        }).disposed(by: disposeBag)
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
    }

    private func update(state: BitcoinState) {
        var sections: [HistoricalTableViewSection] = []

        if let realtimeSection = state.realtimeRate.possibleValue().flatMap(HistoricalTableViewSection.init) {
            sections.append(realtimeSection)
        }

        if let historicalSection = state.historicalRates.possibleValue().flatMap(HistoricalTableViewSection.init) {
            sections.append(historicalSection)
        }

        self.dataSource.viewModel = sections
        if sections.isEmpty {
            self.tableView.isHidden = true
            self.noDataLine1Label.isHidden = false
            self.noDataLine2Label.isHidden = false
            self.noDataRefreshButton.isHidden = false
        } else {
            self.tableView.isHidden = false
            self.noDataLine1Label.isHidden = true
            self.noDataLine2Label.isHidden = true
            self.noDataRefreshButton.isHidden = true
        }

        switch (state.realtimeRate, state.historicalRates) {
        case (.syncing, _), (_, .syncing): return
        default: self.refreshControl.endRefreshing()
        }
    }

    @IBAction private func refreshButtonTap(_ sender: Any) {
        eventHandler.dispatch(BitcoinRateEvent.manualRefresh)
    }

    @objc private func pullToRefresh() {
        eventHandler.dispatch(BitcoinRateEvent.manualRefresh)
    }

    override var prefersStatusBarHidden: Bool {
        return navigationController?.isNavigationBarHidden == true
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.slide
    }
}

extension HistoricalViewController: HasBitcoinStateProvider { }
extension HistoricalViewController: HasEventHandler { }
extension HistoricalViewController: Startable { }
