//
//  NotificationCenter.swift
//  SubscriptionApp
//
//  Created by José Guerra on 13-04-24.
//

import Foundation
import SwiftUI
import UserNotifications

class NotificationCenter: ObservableObject {
    
    

    func createNotification(subscriptionName: String, reminderTime: String) -> () {
        
        let content = UNMutableNotificationContent()
        
        
        content.title = "Geld Reminder: \(subscriptionName)"
        
        var duedTime: String = ""
        if reminderTime == "The same day" {
            duedTime = "for today"
        } else if reminderTime == "One day before" {
            duedTime = "in two days"
        } else if reminderTime == "Two days before" {
            duedTime = "in three days"
        } else if reminderTime == "Three days before" {
            duedTime = "in three days"
        } else if reminderTime == "One week before" {
            duedTime = "in one week"
        }

        content.subtitle = "Payment is due \(duedTime)"
        content.sound = UNNotificationSound.defaultCritical
        
        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
        
        
    }
    
}
