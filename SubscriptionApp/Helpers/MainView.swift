//
//  TabBar.swift
//  SubscriptionApp
//
//  Created by José Guerra on 11-03-24.
//

import SwiftUI

enum Tabs: Int {
    case home = 0
    case subscriptions = 1
    case profile = 2
}

struct MainView: View {
    
    
    
    @AppStorage("lastUsedView") var selectedTab: Tabs = .home
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor(Color("SecondaryBackgroundColor"))
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            NavigationStack {
                HomeView()
                    
            }
            .tag(Tabs.home)
            .tabItem {
                Image(systemName: "house")
            }
                
            NavigationStack {
                SubscriptionsView()
            }
            .tag(Tabs.subscriptions)
            .tabItem {
                Image(systemName: "creditcard")
            }
            
            NavigationStack {
                ProfileView()
            }
            .tag(Tabs.profile)
            .tabItem {
                Image(systemName: "person.fill")
            }
            
        }
        .onAppear {
            print("[D] selectedTab: \(selectedTab)")
        }
        
    }
        
}
