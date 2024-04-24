//
//  SubscriptionAppApp.swift
//  SubscriptionApp
//
//  Created by José Guerra on 11-03-24.
//

import SwiftUI
import SwiftData
import UserNotifications


@main
struct SubscriptionAppApp: App {


    let center = UNUserNotificationCenter.current()
    
    init() {
        center.requestAuthorization(options: [.sound, .badge, .alert]) { granted, error in
            if let error = error {
                print("[D] ERROR REQUESTING NOTIFICATIONS SubscriptionAppApp \(error)")
            }
        }
        
        

    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(SubscriptionsViewModel())
        }
    }
}
