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
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 70, height: 70)
                    .font(.system(size: 70))
                    .frame(width: 120, height: 135)
                    .background(Color("subViewsBackgroundColor"))
                    .foregroundStyle(.white)
                    .clipShape(.circle)
                    
                
                
                TextFieldAndLabel(labelName: "Name", placeholder: "Subscription Name", textVariable: subscriptionName, bigContainer: false)

                
                TextFieldAndLabel(labelName: "Price", placeholder: "$0.00", textVariable: subscriptionPrice, bigContainer: false)
                
                
                DatePickerComponent(subscriptionStartDay: subscriptionStartDay)
                
                
                VStack {
                    Text("Susbcription Cycle")
                        .foregroundStyle(.white)
                        .frame(width: 350,alignment: .leading)
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                    
                    
                    Picker("Select", selection: $subscriptionCycleSelected) {
                        ForEach(subscriptionCycle, id: \.self) {
                            Text($0)
                        }
                    }
                    .accentColor(.white)
                    .padding()
                    .frame(width: 370, height: 58, alignment: .leading)
                    .background(Color("subViewsBackgroundColor"))
                    .clipShape(Rectangle())
                    .cornerRadius(15)
                }
                
                
                TextFieldAndLabel(labelName: "Notes", placeholder: "Enter a description", textVariable: subscriptionDescription, bigContainer: true)
                
                

                Toggle(isOn: $subscriptionReminderToggle) {
                    Text("Add reminder")
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                        
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                
                
                
                VStack {
                    
                    Picker("Select", selection: $subscriptionReminderSelected) {
                        ForEach(reminderOptions, id: \.self) {
                            Text($0)
                        }
                    }
                    .accentColor(.white)
                    .padding()
                    .frame(width: 370, height: 58, alignment: .leading)
                    .background(Color("subViewsBackgroundColor"))
                    .clipShape(Rectangle())
                    .cornerRadius(15)
                    .disabled(!subscriptionReminderToggle)
                }

                
                Toggle(isOn: $subcriptionIsDisable) {
                    Text("Disable service")
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 15)

                
                Button {
                
                    
                    let metaData = SubscriptionMetadata(id: .init(), logo: susbcriptionModel.logo, logoColor: susbcriptionModel.logoColor, backgroundColor: susbcriptionModel.backgroundColor)
                    
                    let newSub = Subscription(id: .init(), 
                                              name: subscriptionName,
                                              price: Int(subscriptionPrice) ?? 0,
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
                    Text("Save")
                        .frame(width: 350, height: 46)
                        .background(Color("buttonBackgroundColor"))
                        .clipShape(Rectangle())
                        .cornerRadius(18)
                        .foregroundStyle(.white)
                }
                
                
            }
        }
    }
}

