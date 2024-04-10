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
    @Environment(SubscriptionsViewModel.self) var viewModel
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
                                //()
                            } else {
                                NavigationLink(value: subscription) {
                                    SubscriptionViewComponent(
                                        logo: subscription.subscriptionMetadata!.logo,
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
                                }
                                .padding(.vertical, 1.5)
                            }
                                
                        }
                    }
                    
                    
                }
                .padding(.top, 25)
                .navigationDestination(for: Subscription.self) { sub in
                    SubscriptionUpdateView(subscription: sub, viewModel: viewModel)
                }
            
            }
            .onAppear {
                viewModel.getSubscriptions()
            }
        }
        .navigationTitle("Subscriptions")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitleTextColor(.white)
        
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
            
            NewSubscriptionView(showingSheet: $showingSheet, viewModel: viewModel)
            
        })
        
        .sheet(isPresented: $showingSubscriptionsBy) {
            NavigationStack {
                SubscriptionsBySheet(viewModel: viewModel)
            }
        }
        
        
    }

}


struct SubscriptionsBySheet: View {
    
    @ObservedObject var viewModel: SubscriptionsViewModel // Solo para pruebas, despues deberia borrarse el viewmodel y la opcion de borrar todo
    @Environment(\.dismiss) var dismiss
    
    var tags: [String] = ["all", "music", "streaming", "gaming"]
    
    @AppStorage("showInactive") var showInactive: Bool = true
    @AppStorage("whiteTheme") var whiteTheme: Bool = false
    @AppStorage("showAproximateDate") var showAproximateDate: Bool = false
    @AppStorage("tag") var tag: String = "all"
    
    var body: some View {
        ZStack {
            Color("backgroundColor")
                .ignoresSafeArea()
            
            VStack {
                
                Toggle(isOn: $showInactive, label: {
                    Text("Show inactives")
                        .foregroundStyle(.white)
                })
                .padding()
                
                Toggle(isOn: $showAproximateDate, label: {
                    Text("Show aproximate date")
                        .foregroundStyle(.white)
                    Text("Example: instead of 8 days -> next week")
                        .font(.caption)
                        .foregroundStyle(.white)
                })
                .padding()
                
                Toggle(isOn: $whiteTheme, label: {
                    Text("Show white theme")
                        .foregroundStyle(.white)
                })
                .disabled(true)
                .padding()
                
                PickerComponent(optionSelected: $tag, title: "Tag Filtering", options: tags)
                    .disabled(true)
                
                
                Spacer()
                
                Button(action: {
                    dismiss()
                    viewModel.deleteAllSubscriptions()
                }, label: {
                    Text("DELETE ALL DEVELOPER OPTION")
                        .foregroundStyle(.red)
                })
                
                Button(action: {
                    dismiss()
                }, label: {
                    ButtonCustom(title: "Save", color: .buttonBackground)
                })
            }
            .padding(.top, 30)

        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitleTextColor(.white)
        
    }
}

