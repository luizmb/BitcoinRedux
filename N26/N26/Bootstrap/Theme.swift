//
//  Theme.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import UIKit

final class Theme {
    static func apply() {
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.yellow]
        navigationBarAppearance.barStyle = .black
        navigationBarAppearance.barTintColor = .red
        navigationBarAppearance.tintColor = .yellow
        navigationBarAppearance.isTranslucent = false
        navigationBarAppearance.setBackgroundImage(UIImage(), for: .default)
        navigationBarAppearance.shadowImage = UIImage()
    }
}
