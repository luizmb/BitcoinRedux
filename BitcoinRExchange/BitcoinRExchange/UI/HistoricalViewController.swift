import BitcoinLibrary
import CommonLibrary
import UIKit

final class HistoricalViewController: UIViewController {
    var disposables: [Any] = []
    @IBOutlet private weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    private var dataSource: HistoricalDataSource!
    @IBOutlet private weak var noDataLine1Label: UILabel!
    @IBOutlet private weak var noDataLine2Label: UILabel!
    @IBOutlet private weak var noDataRefreshButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Bitcoin Rates"
        navigationController?.hidesBarsOnSwipe = true
        dataSource = HistoricalDataSource(tableView: tableView)
        stateProvider[\.bitcoinState].subscribe { [weak self] state in
            self?.update(state: state)
        }.bind(to: self)
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
        actionDispatcher.async(BitcoinRateRequest.realtimeRefresh(isManual: true))
        actionDispatcher.async(BitcoinRateRequest.historicalDataRefresh(isManual: true))
    }

    @objc private func pullToRefresh() {
        actionDispatcher.async(BitcoinRateRequest.realtimeRefresh(isManual: true))
        actionDispatcher.async(BitcoinRateRequest.historicalDataRefresh(isManual: true))
    }

    override var prefersStatusBarHidden: Bool {
        return navigationController?.isNavigationBarHidden == true
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.slide
    }
}

extension HistoricalViewController: HasActionDispatcher { }
extension HistoricalViewController: HasStateProvider { }
extension HistoricalViewController: Startable { }
extension HistoricalViewController: HasDisposableBag { }
