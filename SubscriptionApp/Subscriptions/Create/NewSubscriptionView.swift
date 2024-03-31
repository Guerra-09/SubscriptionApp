//
//  NewSubscription.swift
//  SubscriptionApp
//
//  Created by José Guerra on 11-03-24.
//

import SwiftUI

struct NewSubscriptionView: View {
    
    @Binding var showingSheet: Bool
    
    @ObservedObject var viewModel: SubscriptionsViewModel
    @ObservedObject var subscriptionsExisting = NewSubscriptionViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("backgroundColor")
                    .ignoresSafeArea()
                
                    ScrollView {
                        
                        
                        // Iterating subscriptions
                        ForEach(subscriptionsExisting.subscriptions) { value in
                                
                            HStack {
                                
                                Image(value.logo)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundStyle(Color(hex: "5C6362"))
                                    .frame(width: 60, height: 60)
                                
                                Spacer()
                                
                                Text(value.name)
                                    .font(.system(size: 24))
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color(hex: "5C6362"))
                                
                                Spacer()
                                
                                NavigationLink {
                              
                                    ExistingCreationView(viewModel: viewModel, showingSheet: $showingSheet, susbcriptionModel: SubscriptionModel(name: value.name, logo: value.logo, logoColor: value.logoColor, backgroundColor: value.backgroundColor), subscriptionName: value.name)
                                
                                } label: {
                                    
                                    // If its added instead of plus should be a checkmark. This info its gotten from vm
                                    Image(systemName: "plus")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 30)
                                        .fontWeight(.bold)
                                        .foregroundStyle(Color(hex: "5C6362"))
                                }

   
                            }
                            .padding(20)

                        }
                        

                    }
                }
                // Modificando el Navigation bar, titulo y botones.
                .navigationBarBackButtonHidden(true)
                .navigationTitle("New Subscription")
                .navigationBarTitleTextColor(.white)
                .navigationBarTitleDisplayMode(.inline)
                
                
                .toolbar(content: {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(action: {
                            dismiss()
                        }, label: {
                            Text("Cancel")
                        })
                    }
                    
                    ToolbarItem(placement: .primaryAction) {
                        NavigationLink {
                            CustomCreationView()
                        } label: {
                            Text("Custom")
                        }

                    }
                })
            }
        
            
        
    }
}

//#Preview {
//    NavigationStack {
//        NewSubscriptionView()
//    }
//}
