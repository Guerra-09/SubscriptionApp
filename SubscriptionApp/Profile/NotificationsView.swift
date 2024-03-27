//
//  NotificationsView.swift
//  SubscriptionApp
//
//  Created by José Guerra on 11-03-24.
//

import SwiftUI

struct NotificationsView: View {
    var body: some View {
        ZStack {
            Color("backgroundColor")
                .ignoresSafeArea()
            
            VStack {
                
                Text("Notifications View")
                    .foregroundStyle(.white)
                
            }
            
        }
    }
}

#Preview {
    NotificationsView()
}
