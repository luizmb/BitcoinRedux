import UIKit

final class HistoricalRecordTableViewCell: UITableViewCell {
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var rateLabel: UILabel!

    func update(viewModel: HistoricalTableViewRow) {
        dateLabel.text = viewModel.date
        rateLabel.text = viewModel.rate
    }
}

final class BulletBackgroundView: UIView {
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }

    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = true
    }
}
