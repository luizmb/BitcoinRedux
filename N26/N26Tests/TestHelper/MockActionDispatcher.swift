//
//  MockActionDispatcher.swift
//  N26Tests
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import Foundation
import XCTest
@testable import N26

class MockActionDispatcher: ActionDispatcher {
    var actions: [Action] = []
    var asyncActions: [Any] = []

    func dispatch(_ action: Action) {
        actions.append(action)
    }

    func async<AppActionAsyncType: AppActionAsync>(_ action: AppActionAsyncType) {
        asyncActions.append(action)
    }
}
