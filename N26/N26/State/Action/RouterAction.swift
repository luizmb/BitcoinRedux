//
//  RouterAction.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import UIKit

public enum RouterAction: Action {
    case didStart(UIApplication, UINavigationController)
    case willNavigate(NavigationRoute)
    case didNavigate(NavigationTree)
}
