//
//  DateExtensions.swift
//  SubscriptionApp
//
//  Created by José Guerra on 05-04-24.
//

import Foundation

extension Calendar {
    static let iso8601 = Calendar(identifier: .iso8601)
}


extension Date {
    
    
    var year: Int {
        Calendar.iso8601.component(.year, from: self)
    }
    
    var month: Int {
        Calendar.iso8601.component(.month, from: self)
    }
    
    var lastDateOfPreviousMonth: Date? {
        DateComponents(calendar: .iso8601, year: year, month: month, day: 0).date
    }
    
    func convertToTimeZone(identifier: String) -> Date {
        let timeZone = TimeZone(identifier: identifier)!
        let delta = TimeInterval(timeZone.secondsFromGMT(for: self) - TimeZone.current.secondsFromGMT(for: self))
        return addingTimeInterval(delta)
    }
    
    
}


extension Date {
    init?(_ year: Int,_ month: Int,_ day: Int) {
        guard let date = DateComponents(calendar: .current, year: year, month: month, day: day, hour: 12).date else { return nil }
        self = date
    }
}
