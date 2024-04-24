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
    
    
    
}
