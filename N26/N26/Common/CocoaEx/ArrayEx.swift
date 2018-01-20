//
//  ArrayEx.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import UIKit

extension Array {
    subscript (safe index: Int) -> Element? {
        return index < count && index >= 0 ? self[index] : nil
    }
}
