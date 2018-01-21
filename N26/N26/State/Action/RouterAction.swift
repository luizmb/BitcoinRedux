//
//  RouterAction.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import UIKit
import BitcoinLibrary
import CommonLibrary

public enum RouterAction: Action {
    case didStart(Application, UINavigationController)
    case willNavigate(NavigationRoute)
    case didNavigate(NavigationTree)
}
