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
    
    @State var animation: Bool = false
    
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
                                            tintColor: subscription.subscriptionMetadata!.tintColor,
                                            backgroundColor: subscription.subscriptionMetadata!.backgroundColor,
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
                        .onDelete { indexSet in
                            print("[D] testing")
                        }

                    }
                    
                    if !showInactive {
                        
                        Text("\(self.viewModel.countDisableSubscriptions()) subscriptions hidden. ")
                            .foregroundStyle(.gray)
                            .padding(20)
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
                    if viewModel.subscriptions.count == 0 {
                        Text("Create")
                            .opacity(animation ? 1 : 0)
                            .onAppear {
                                
                                let baseAnimation = Animation.easeInOut(duration: 0.5)
                                let repeated = baseAnimation.repeatForever(autoreverses: true)
                                withAnimation(repeated) {
                                        animation.toggle()
                                }
                            }
                    } else {
                        Text("Create")
                    }
                    
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
