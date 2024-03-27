//
//  NewSubscription.swift
//  SubscriptionApp
//
//  Created by José Guerra on 11-03-24.
//

import SwiftUI

struct NewSubscriptionView: View {
    @ObservedObject var subscriptionsExisting = SubscriptionViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("backgroundColor")
                    .ignoresSafeArea()
                
                
                    VStack {
                        Text("New Subscription view")
                            .foregroundStyle(.white)
                        
                        ForEach(subscriptionsExisting.subscriptions) { value in
                            Text(value.name)
                                .foregroundStyle(.red)
                            
                            Image(value.logo)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80, height: 80)
                        }
                        
                        
                        NavigationLink("Create custom"){
                          CustomCreationView()
                        }
                        
                        NavigationLink("Create existing one"){
                            ExistingCreationView()
                        }
                    }
                
            }
        }
        
        .navigationBarBackButtonHidden(true)
        .toolbar(content: {
            ToolbarItem(placement: .cancellationAction) {
                Button(action: {
                    dismiss()
                }, label: {
                    Text("Cancel")
                })
            }
        })
        
    }
}

#Preview {
    NavigationStack {
        NewSubscriptionView()
    }
}
