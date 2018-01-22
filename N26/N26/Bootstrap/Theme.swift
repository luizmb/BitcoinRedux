//
//  Theme.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import UIKit

extension UIColor {
    enum Named: String {
        case cellBackground = "CellBackground"
        case cellHighlightText = "CellHighlightText"
        case cellText = "CellText"
        case chromeBackground = "ChromeBackground"
        case chromeText = "ChromeText"
        case listBackground = "ListBackground"
        case listSeparator = "ListSeparator"

        var color: UIColor {
            return .of(self)
        }
    }

    static func of(_ named: Named) -> UIColor {
        return UIColor(named: named.rawValue)!
    }
}

final class Theme {
    static func apply() {
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.of(.chromeText)]
        navigationBarAppearance.largeTitleTextAttributes =
            [NSAttributedStringKey.foregroundColor: UIColor.of(.chromeText)]
        navigationBarAppearance.prefersLargeTitles = true
        navigationBarAppearance.barTintColor = .of(.chromeBackground)
    }
}
