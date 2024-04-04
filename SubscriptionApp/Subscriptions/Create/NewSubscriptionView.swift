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
    
    @State var showingAlertDelete: Bool = false
    @State var subscriptionToDelete: Subscription?
    
    var alreadySelected: [String] = []
    
    @State var query: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("backgroundColor")
                    .ignoresSafeArea()
                
                
                ScrollView {
                    
                    TextField("Buscar un resultado...", text: $query)
                        .padding()
                        .foregroundStyle(.white)
                        .frame(width: 370, height: 50)
                        .background(Color("subViewsBackgroundColor"))
                        .clipShape(Rectangle())
                        .cornerRadius(15)
                    


                    
                    
                    // Iterating subscriptions
                    ForEach(subscriptionsExisting.subscriptions.filter{$0.name.hasPrefix(query) || query == ""}) { value in
                        
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
                                    
                                    ExistingCreationView(viewModel: viewModel, showingSheet: $showingSheet, susbcriptionModel: SubscriptionModel(name: value.name, textColor: value.textColor, logo: value.logo, logoColor: value.logoColor, backgroundColor: value.backgroundColor), subscriptionName: value.name)
                                    
                                } label: {
                                    
                                    // If its added instead of plus should be a checkmark. This info its gotten from vm
                                    
                                    if (subscriptionsExistingUsed(subscription: value.logo)) {
                                        Image(systemName: "plus")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 30)
                                            .fontWeight(.bold)
                                            .foregroundStyle(Color(hex: "5C6362"))
                                    } else {
                                        Image(systemName: "minus")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 30)
                                            .fontWeight(.bold)
                                            .foregroundStyle(Color(hex: "5C6362"))
                                    }
                                    
                                    
                                    
                                    
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
            
            .alert("Are you sure you want to delete the subscription?", isPresented: $showingAlertDelete) {
                Button("Cancel", role: .cancel) { print("Cancelling") }
                
                Button("Delete", role: .destructive) {
                    dismiss()
                    print("Deleting \(subscriptionToDelete!.name)")
                    viewModel.deleteSubscription(subscription: subscriptionToDelete!)
                }
                
            }
            
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

    
    /// CHECK: Complexity!!!
    func subscriptionsExistingUsed(subscription: String) -> Bool {
        
        // Array de objetos que YA estan ingresados
        var array = [String]()

        for json in subscriptionsExisting.subscriptions {
            for sub in viewModel.subscriptions {
                if sub.subscriptionMetadata!.logo == json.logo {
                    array.append(json.logo)
                }
            }
        }
        
        if array.contains(subscription) { return false } else { return true }

    }
}
