//
//  SubscriptionView.swift
//  SubscriptionApp
//
//  Created by José Guerra on 11-03-24.
//

import SwiftUI
import SwiftData

struct SubscriptionsView: View {

    @State var showingSubscriptionsBy: Bool = false
    @State private var showingSheet = false
    @State var showToolbar: Bool = true
    @EnvironmentObject var viewModel: SubscriptionsViewModel
    @AppStorage("showInactive") var showInactive: Bool = true
    
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
                            
                            if !showInactive && subscription.disableService {
                            
                                
                            } else {
                                
                                NavigationLink(value: subscription) {
                                    
                                    if let logo = subscription.subscriptionMetadata?.logo {
                                        
                                        SubscriptionViewComponent(
                                            logo: logo,
                                            logoColor: subscription.subscriptionMetadata!.logoColor,
                                            backgroundColor: subscription.subscriptionMetadata!.backgroundColor,
                                            textColor: subscription.subscriptionMetadata!.textColor!,
                                            name: subscription.name,
                                            price: Float(subscription.price),
                                            cycle: subscription.cycle,
                                            startDay: subscription.startDay,
                                            reminder: subscription.reminder,
                                            disableService: subscription.disableService
                                        )
                                    } else {
                                        Text("Nothing to see here")
                                    }
                                    
                                    
                                }
                                .padding(.vertical, 1.5)
                                 
                            }
                                
                        }

                    }
                    
                    
                }
                .padding(.top, 25)
                .navigationDestination(for: Subscription.self) { sub in
                    SubscriptionUpdateView(viewModel: viewModel, showToolbar: $showToolbar, subscription: sub)
                }
            
            }
            .task {
                viewModel.getSubscriptions()
                showToolbar = true
            }
 
        }
        .navigationTitle("Subscriptions")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitleTextColor(.white)
        .toolbar(showToolbar ? .visible : .hidden, for: .tabBar)
        .toolbar {
            
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    showingSubscriptionsBy.toggle()
                }, label: {
                    Image(systemName: "gear")
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
            
            CreationView(viewModel: viewModel, showingSheet: $showingSheet)
            
        })
        
        .sheet(isPresented: $showingSubscriptionsBy) {
            NavigationStack {
                SubscriptionsSettingsSheet(viewModel: viewModel)
            }
        }
        
        
    }
    


}
