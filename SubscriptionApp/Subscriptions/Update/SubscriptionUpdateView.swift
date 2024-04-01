//
//  SubscriptionUpdateView.swift
//  SubscriptionApp
//
//  Created by José Guerra on 01-04-24.
//

import SwiftUI

struct SubscriptionUpdateView: View {
    

    var subscription: Subscription
    
    var body: some View {
        ZStack {
            Color("backgroundColor")
                .ignoresSafeArea()
            
            VStack {
                Text("Update view")
                    .font(.title)
                
                Text("Editing: \(subscription.name)")
            }
            .foregroundStyle(.white)
            
            
        }        
    }
}

//#Preview {
//    SubscriptionUpdateView()
//}
