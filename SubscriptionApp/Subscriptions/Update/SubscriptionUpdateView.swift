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
    
    
    @State var subscriptionPrice: String = ""
    
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
                VStack {
                    Text("Price")
                        .modifier(TextFieldLabelCommonModifier())
                    
                    TextField("Price", text: $subscriptionPrice)
                        .modifier(TextFieldCommonModifier(bigContainer: false))
                        .onChange(of: subscriptionPrice) { oldValue, newValue in
                            subscription.price = Float(newValue) ?? 0.0
                        }
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
                } label: {
                    ButtonCustom(title: "Save", color: Color("buttonBackgroundColor"))
                }
                
                Button {
                    dismiss()
                    viewModel.deleteSubscription(subscription: subscription)
                } label: {
                    ButtonCustom(title: "Delete", color: Color(.red))
                }
            }

            
        }
        .onAppear {
            self.subscriptionPrice = String(subscription.price)
            print("METADATA: \(subscription.subscriptionMetadata!.logo)")
        }
    }
}

//#Preview {
//    SubscriptionUpdateView()
//}
