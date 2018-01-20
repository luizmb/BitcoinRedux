//
//  Startable.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import UIKit

protocol Startable {
    static func start() -> Self?
}

extension Startable where Self: UIViewController {
    static func start() -> Self? {
        return Self(nibName: nibName, bundle: nil)
    }
}
