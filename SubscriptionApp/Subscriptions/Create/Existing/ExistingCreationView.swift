//
//  ExistingCreationView.swift
//  SubscriptionApp
//
//  Created by José Guerra on 11-03-24.
//

import SwiftUI

struct ExistingCreationView: View {
    
//    @Environment(ExistingCreationViewModel.self) var viewModel
    @ObservedObject var viewModel: SubscriptionsViewModel

    @Binding var showingSheet: Bool
    
    let susbcriptionModel: SubscriptionModel
    
    
    let subscriptionCycle: [String] = ["weekly", "monthly", "each 3 months", "each 6 months", "yearly"]
    let reminderOptions: [String] = ["The same day","1 day before", "2 days before", "3 days before", "1 week before", "2 weeks befores"]
    
    @State var subscriptionName: String 
    @State var subscriptionPrice: String = ""
    @State var subscriptionStartDay: Date = Date()
    @State var subscriptionCycleSelected: String = "monthly"
    @State var subscriptionDescription: String = ""
    @State var subscriptionReminderToggle: Bool = true
    @State var subscriptionReminderSelected: String = "The same day"
    @State var subcriptionIsDisable: Bool = false
    
    
    var body: some View {
        ZStack {
            Color("backgroundColor")
                .ignoresSafeArea()
            
            ScrollView {
                Image(susbcriptionModel.logo)
                    .resizable()
                    .modifier(ImageWithLogoModifier())
                    
                
                // Name
                TextFieldAndLabel(labelName: "Name", placeholder: "Subscription Name", textVariable: $subscriptionName, bigContainer: false)

                // Price
                TextFieldAndLabel(labelName: "Price", placeholder: "$0.00", textVariable: $subscriptionPrice, bigContainer: false)
                
                // Start day
                DatePickerComponent(subscriptionStartDay: $subscriptionStartDay)
                
                // Subscription Cycle
                PickerComponent(optionSelected: $subscriptionCycleSelected, title: "Subscription Cycle", options: subscriptionCycle)
                
                // Notes
                TextFieldAndLabel(labelName: "Notes", placeholder: "Enter a description", textVariable: $subscriptionDescription, bigContainer: true)
                
                
                ToggleComponent(title: "Add Reminder", toggleOption: $subscriptionReminderToggle)
                
                
                PickerComponent(optionSelected: $subscriptionReminderSelected, title: "Reminder Time", options: reminderOptions)
                    .disabled(!subscriptionReminderToggle)

                
                ToggleComponent(title: "Disable",toggleOption: $subcriptionIsDisable)
                    .tint(.red)

                
                Button {
                    
                    let metaData = SubscriptionMetadata(
                        id: .init(),
                        logo: susbcriptionModel.logo,
                        logoColor: susbcriptionModel.logoColor,
                        backgroundColor: susbcriptionModel.backgroundColor,
                        textColor: susbcriptionModel.textColor
                    )
                    
                    let newSub = Subscription(id: .init(), 
                                              name: subscriptionName,
                                              price: Float(subscriptionPrice) ?? 0.0,
                                              startDay: subscriptionStartDay,
                                              cycle: subscriptionCycleSelected,
                                              descriptionText: subscriptionDescription,
                                              reminder: subscriptionReminderToggle,
                                              reminderTime: subscriptionReminderSelected,
                                              disableService: subcriptionIsDisable,
                                              subscriptionMetadata: metaData)
                    
                    
                    viewModel.addSubscription(subscription: newSub)
                    
                    showingSheet.toggle()

     
                } label: {
                    ButtonCustom(title: "Save", color: Color("buttonBackgroundColor"))
                }
                
                
            }
        }
    }
}

