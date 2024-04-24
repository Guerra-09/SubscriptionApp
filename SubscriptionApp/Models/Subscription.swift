//
//  Susbcription.swift
//  SubscriptionApp
//
//  Created by José Guerra on 29-03-24.
//

import Foundation
import SwiftData

@Model
class Subscription {
    
    @Attribute(.unique) var id: UUID
    var name: String
    var price: Float
    var startDay: Date
    var cycle: String
    var descriptionText: String
    
    var reminder: Bool
    var reminderTime: String
    var disableService: Bool
    var customSubscription: Bool
    
    @Relationship(.unique) var subscriptionMetadata: SubscriptionMetadata?
    
    
    init(id: UUID, name: String, price: Float, startDay: Date, cycle: String, descriptionText: String, reminder: Bool, reminderTime: String, disableService: Bool, customSubscription: Bool,  subscriptionMetadata: SubscriptionMetadata) {
        self.id = id
        self.name = name
        self.price = price
        self.startDay = startDay
        self.cycle = cycle
        self.descriptionText = descriptionText
        self.reminder = reminder
        self.reminderTime = reminderTime
        self.disableService = disableService
        self.customSubscription = customSubscription
        self.subscriptionMetadata = subscriptionMetadata
    }
    
}

@Model
class SubscriptionMetadata {
    var logo: String
    var logoColor: String
    var backgroundColor: String
    var textColor: String?
    
    init(id: UUID, logo: String, logoColor: String, backgroundColor: String, textColor: String?) {
        self.logo = logo
        self.logoColor = logoColor
        self.backgroundColor = backgroundColor
        self.textColor = textColor
    }
    
}




