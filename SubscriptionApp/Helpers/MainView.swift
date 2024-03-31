//
//  TabBar.swift
//  SubscriptionApp
//
//  Created by José Guerra on 11-03-24.
//

import SwiftUI

struct TabBar: View {
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor(Color("SecondaryBackgroundColor"))
    }
    
    
    var body: some View {
        TabView {
            
            NavigationView {
                HomeView()
            }
            .tabItem {
                Image(systemName: "house")
            }
                
            NavigationView {
                SubscriptionsView()
            }
            .tabItem {
                Image(systemName: "creditcard")
            }
            
            NavigationView {
                ProfileView()
            }
            .tabItem {
                Image(systemName: "person.fill")
            }
            
        }
        
    }
}

#Preview {
    NavigationStack {
        TabBar()
    }
}
