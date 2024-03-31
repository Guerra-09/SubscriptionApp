//
//  SubscriptionAppApp.swift
//  SubscriptionApp
//
//  Created by José Guerra on 11-03-24.
//

import SwiftUI
import SwiftData

@main
struct SubscriptionAppApp: App {
    var body: some Scene {
        WindowGroup {
            TabBar()
                .environmentObject(SubscriptionsViewModel())
        }
    }
}
