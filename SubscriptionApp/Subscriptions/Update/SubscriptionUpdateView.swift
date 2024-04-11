//
//  SubscriptionUpdateView.swift
//  SubscriptionApp
//
//  Created by José Guerra on 01-04-24.
//

import SwiftUI

struct SubscriptionUpdateView: View {
    
    let subscriptionCycle: [String] = ["weekly", "monthly", "each three months", "each six months", "yearly"]
    let reminderOptions: [String] = ["The same day","One day before", "Two days before", "Three days before", "One week before", "Two weeks before"]
    
    @Bindable var subscription: Subscription
    @ObservedObject var viewModel: SubscriptionsViewModel
    
    @State var showingAlertDelete: Bool = false
    
    @State var subscriptionPrice: String = ""
    @State var subscriptionToDelete: Subscription?
    
    @Environment(\.dismiss) var dismiss
    

    
    var body: some View {
        ZStack {
            Color("backgroundColor")
                .ignoresSafeArea()
            
            
            ScrollView {
                
                Image(subscription.subscriptionMetadata?.logo ?? "")
                    .resizable()
                    .modifier(ImageWithLogoModifier())
                
                
                // Name
                TextFieldAndLabel(labelName: "Name", placeholder: "Editar", textVariable: $subscription.name, bigContainer: false)
                 
                // Price
                TextFieldAndLabel(labelName: "Price", placeholder: "$0.00", textVariable: $subscriptionPrice, bigContainer: false)
                    .keyboardType(.decimalPad)
                    .onChange(of: subscriptionPrice) { oldValue, newValue in
                        
                        var filteredText = newValue.filter { "0123456789,".contains($0) }
                        
                        let decimalCount = filteredText.components(separatedBy: ",").count - 1
                        if decimalCount > 1 {
                            filteredText = String(filteredText.dropLast())
                        }
                        
                        if let dotIndex = filteredText.firstIndex(of: ",") {
                            let decimalPortion = filteredText.suffix(from: dotIndex)
                            if decimalPortion.count > 3 {
                                filteredText = String(filteredText.dropLast())
                            }
                        }
                        
                        subscriptionPrice = "$" + filteredText
                    }
                
                // Start day
                DatePickerComponent(subscriptionStartDay: $subscription.startDay)
                
                // Susbcription Cycle
                PickerComponent(optionSelected: $subscription.cycle, title: "Subscription Cycle", options: subscriptionCycle)
                
                // Notes
                TextFieldAndLabel(labelName: "Notes", placeholder: "Enter a description", textVariable: $subscription.descriptionText, bigContainer: true)
                
                // Reminder - Reminder time
                ToggleComponent(title: "Add Reminder", toggleOption: $subscription.reminder)
                
                PickerComponent(optionSelected: $subscription.reminderTime, title: "Reminder Time", options: reminderOptions)
                    .disabled(!subscription.reminder)
                
                // Disable
                ToggleComponent(title: "Disable",toggleOption: $subscription.disableService)
                    .tint(.red)
                
                Button {
                    dismiss()
                    
                    var formattedPrice: Float {
                      
                        let removingMoneySign = subscriptionPrice.replacingOccurrences(of: "$", with: "")
                        
                        let replacingCommas = removingMoneySign.replacingOccurrences(of: ",", with: ".")
                        
                        // Convertir el texto limpio a un valor Float
                        if let floatValue = Float(replacingCommas) {
                            return floatValue
                        } else {
                            return 0.0
                        }
                    }
                    
                    subscription.price = formattedPrice
                    
                } label: {
                    ButtonCustom(title: "Save", color: Color("buttonBackgroundColor"))
                }
                
                Button {
                    subscriptionToDelete = self.subscription
                    showingAlertDelete.toggle()
                } label: {
                    Text("Delete")
                        .font(.system(size: 18))
                        .underline()
                        .foregroundStyle(.red)
                        .padding(.top, 15)
                        .padding(.bottom, 30)
                }
            }

            
        }
        .onAppear {
            self.subscriptionPrice = String(subscription.price).replacingOccurrences(of: ".", with: ",")
            print("METADATA: \(subscription.subscriptionMetadata!.logo)")
        }
        
        .alert("Are you sure you want to delete?", isPresented: $showingAlertDelete) {
            Button("Cancel", role: .cancel) { print("Cancelling") }
            
            Button("Delete", role: .destructive) {
                dismiss()
                viewModel.deleteSubscription(subscription: subscriptionToDelete!)
            }
            
        }
    }
}
