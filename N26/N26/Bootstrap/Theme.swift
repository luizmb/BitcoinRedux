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
        case chromeBackground = "ChromeBackground"
        case chromeText = "ChromeText"

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
        navigationBarAppearance.barStyle = .black
        navigationBarAppearance.barTintColor = .of(.chromeBackground)
        navigationBarAppearance.tintColor = .of(.chromeText)
        navigationBarAppearance.isTranslucent = false
        navigationBarAppearance.setBackgroundImage(UIImage(), for: .default)
        navigationBarAppearance.shadowImage = UIImage()
    }
}
