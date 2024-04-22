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
    @State var subscriptionToDelete: SubscriptionModel?
    
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
                    ForEach(subscriptionsExisting.subscriptions.filter{

                        let lowercasedQuery = query.lowercased()
                        let lowercasedName = $0.name.lowercased()
                        return lowercasedName.hasPrefix(lowercasedQuery) || lowercasedQuery == ""
                    }) { value in
                        
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
                            
                            
                            if (subscriptionsExistingUsed(subscription: value.logo)) {
                                
                                
                                NavigationLink {
                                    
                                    ExistingCreationView(viewModel: viewModel, showingSheet: $showingSheet, susbcriptionModel: SubscriptionModel(name: value.name, textColor: value.textColor, logo: value.logo, logoColor: value.logoColor, backgroundColor: value.backgroundColor), subscriptionName: value.name)
                                    
                                } label: {
                                    Image(systemName: "plus")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 30)
                                        .fontWeight(.bold)
                                        .foregroundStyle(Color(hex: "5C6362"))
                                }
                            
                
                            } else {
                                Button {
                                    subscriptionToDelete = value
                                    showingAlertDelete.toggle()
                                } label: {
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
                
                    viewModel.deleteSubscriptionByLogo(subscription: subscriptionToDelete!)
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
                        
                        CustomCreationView(viewModel: viewModel, showingSheet: $showingSheet)
                    } label: {
                        Text("Custom")
                    }
                    
                }
            })
        }

    }

    
    func subscriptionsExistingUsed(subscription: String) -> Bool {
      var logos = Dictionary<String, Bool>()
      
      for sub in viewModel.subscriptions.filter({ $0.subscriptionMetadata?.logo != nil }) {
        if let logo = sub.subscriptionMetadata?.logo {
          logos[logo] = false
        }
      }
      
      return logos[subscription] ?? true
    }
}
