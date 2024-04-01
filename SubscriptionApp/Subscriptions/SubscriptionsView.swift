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
        NavigationStack(path: $path) {
            ZStack {
                Color("backgroundColor")
                    .ignoresSafeArea()
                
                ScrollView {
                    
                    ForEach(viewModel.subscriptions) { subscription in

                        NavigationLink(value: subscription) {
                            SubscriptionViewComponent(
                                logo: subscription.subscriptionMetadata!.logo,
                                logoColor: subscription.subscriptionMetadata!.logoColor,
                                backgroundColor: subscription.subscriptionMetadata!.backgroundColor,
                                name: subscription.name,
                                price: Int(subscription.price),
                                startDay: subscription.startDay,
                                reminder: subscription.reminder,
                                disableService: subscription.disableService
                            )
                        }
                        
                        
                    }
                }
                .navigationDestination(for: Subscription.self) { sub in
                    SubscriptionUpdateView(subscription: sub)
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
