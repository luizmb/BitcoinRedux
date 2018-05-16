import UIKit

protocol ConfigurableCell {

    associatedtype DataObject

    func update(_ viewModel: DataObject?)
}
