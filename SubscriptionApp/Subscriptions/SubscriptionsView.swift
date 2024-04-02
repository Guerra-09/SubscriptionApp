//
//  SubscriptionView.swift
//  SubscriptionApp
//
//  Created by José Guerra on 11-03-24.
//

import SwiftUI
import SwiftData

struct SubscriptionsView: View {

    @State private var showingSheet = false
    @Environment(SubscriptionsViewModel.self) var viewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("backgroundColor")
                    .ignoresSafeArea()
                
                ScrollView {
                    
                    if viewModel.subscriptions.count == 0 {
                        Text("There aren't any subscription created")
                            .font(.title2)
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                        
                        Text("Press on Create to start filling this side!")
                            .font(.subheadline)
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                    } else {
                        ForEach(viewModel.subscriptions) { subscription in
                            
                            NavigationLink(value: subscription) {
                                SubscriptionViewComponent(
                                    logo: subscription.subscriptionMetadata!.logo,
                                    logoColor: subscription.subscriptionMetadata!.logoColor,
                                    backgroundColor: subscription.subscriptionMetadata!.backgroundColor, 
                                    textColor: subscription.subscriptionMetadata!.textColor!,
                                    name: subscription.name,
                                    price: Float(subscription.price),
                                    startDay: subscription.startDay,
                                    reminder: subscription.reminder,
                                    disableService: subscription.disableService
                                )
                            }
                            
                            
                        }
                    }
                    
                    
                }
                .navigationDestination(for: Subscription.self) { sub in
                    SubscriptionUpdateView(subscription: sub, viewModel: viewModel)
                }
                
//                .overlay {
//                    Button {
//                        NewSubscriptionView()
//    
//                        showingSheet.toggle()
//                    } label: {
//                        Image(systemName: "plus")
//                            .font(.system(size: 35))
//                            .frame(width: 70, height: 150)
//                            .background(Color("buttonBackgroundColor"))
//                            .foregroundStyle(.white)
//                            .clipShape(Circle())
//                            
//                    }
//                    .position(CGPoint(x: 210.0, y: 275.0))
//                }
            }
            .onAppear {
                viewModel.getSubscriptions()
            }
        }
        
        .toolbar {
            
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    viewModel.deleteAllSubscriptions()
                }, label: {
                    Image(systemName: "trash")
                })
            }
            
            ToolbarItem(placement: .principal) {
                
                Button(action: {}, label: {
                    Text("All Subscriptions   \(Image(systemName: "chevron.down"))")
                        .frame(width: 250, height: 35)
                        .foregroundStyle(.white)
                        .background(Color("SecondaryBackgroundColor"))
                        .clipShape(.capsule)
                })
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    showingSheet.toggle()
                }, label: {
                    Text("Create")
                })
            }
            
        }
        
        .sheet(isPresented: $showingSheet, content: {
            
            NewSubscriptionView(showingSheet: $showingSheet, viewModel: viewModel)
            
        })
        
        
    }

}

//#Preview {
//    NavigationStack {
//        SubscriptionsView()
//    }
//}
