//
//  DateEx.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import Foundation

extension Date {
    public var backToMidnight: Date {
        let calendar = Calendar.current
        return calendar.startOfDay(for: self)
    }

    public func addingDays(_ days: Int) -> Date {
        let calendar = Calendar.current
        var daysOffset = DateComponents()
        daysOffset.day = days
        return calendar.date(byAdding: daysOffset, to: self)!
    }
}
