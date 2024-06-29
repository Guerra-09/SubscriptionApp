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
    
//    @Environment(\.scenePhase) var scenePhase
        

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
        // Esto podria ser necesario en ciertos casos...
//        .onChange(of: scenePhase) { phase in
//            switch phase {
//                
//            case .background:
//                print("Background Phase")
//                
//            case .inactive:
//                print("Inactive Phase")
//                
//            case .active:
//                print("Active Phase")
//                
//            @unknown default:
//                print("Default")
//            
//            }
//            
//            
//        }
    }
}

