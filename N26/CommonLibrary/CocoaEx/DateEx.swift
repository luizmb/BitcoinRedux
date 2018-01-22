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

    public func formattedFromComponents(styleAttitude: DateFormatter.Style, year: Bool = false, month: Bool = false, day: Bool = false, hour: Bool = false, minute: Bool = false, second: Bool = false, locale: Locale = Locale.current) -> String {
        let long = styleAttitude == .long || styleAttitude == .full
        let short = styleAttitude == .short
        var comps = ""

        if year { comps += long ? "yyyy" : "yy" }
        if month { comps += long ? "MMMM" : (short ? "MM" : "MMM") }
        if day { comps += long ? "dd" : "d" }

        if hour { comps += long ? "HH" : "H" }
        if minute { comps += long ? "mm" : "m" }
        if second { comps += long ? "ss" : "s" }
        let format = DateFormatter.dateFormat(fromTemplate: comps, options: 00, locale: locale)
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
