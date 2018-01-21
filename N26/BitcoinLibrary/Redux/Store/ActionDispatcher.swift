//
//  ActionDispatcher.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 21.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import Foundation
import CommonLibrary

public protocol ActionDispatcher {
    func dispatch(_ action: Action)
    func async<AppActionAsyncType: AppActionAsync>(_ action: AppActionAsyncType)
}

