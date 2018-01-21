//
//  BootstrapRequest.swift
//  BitcoinWatch Extension
//
//  Created by Luiz Rodrigo Martins Barbosa on 21.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import WatchKit
import BitcoinLibrary
import CommonLibrary

enum BootstrapRequest: AppActionAsync {
    case boot

    func execute(getState: @escaping () -> AppState,
                 dispatch: @escaping DispatchFunction,
                 dispatchAsync: @escaping (AnyActionAsync<AppState>) -> ()) {
        switch self {
        case .boot:
            // Theme.apply()

            dispatch(RouterAction.didStart)

            // TODO: Trigger auto-refresh
            dispatchAsync(AnyActionAsync(BitcoinRateRequest.realtimeCache))
            dispatchAsync(AnyActionAsync(BitcoinRateRequest.historicalCache))
            dispatchAsync(AnyActionAsync(BitcoinRateRequest.realtimeRefresh))
            dispatchAsync(AnyActionAsync(BitcoinRateRequest.historicalDataRefresh))
        }
    }
}

