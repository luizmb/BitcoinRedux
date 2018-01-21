//
//  RouterAction.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

#if os(iOS)
import UIKit
#endif
import CommonLibrary

public enum RouterAction: Action {
    #if os(iOS)
    case didStart(Application, UINavigationController)
    #endif
    case willNavigate(NavigationRoute)
    case didNavigate(NavigationTree)
}
