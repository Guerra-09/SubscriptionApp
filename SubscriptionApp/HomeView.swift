//
//  MainView.swift
//  SubscriptionApp
//
//  Created by José Guerra on 11-03-24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            Color("backgroundColor")
                .ignoresSafeArea()
            Text("Home View")
                .foregroundStyle(Color(.white))
        }
        .navigationTitle("Home")
        .navigationBarTitleTextColor(.white)
            
        
    }
    
}

#Preview {
    NavigationStack {
        HomeView()
    }
}

