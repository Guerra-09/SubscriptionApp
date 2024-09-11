//
//  CustomCreation.swift
//  SubscriptionApp
//
//  Created by José Guerra on 11-03-24.
//

import SwiftUI

struct CreationView: View {
    
    @ObservedObject var viewModel: SubscriptionsViewModel

    @Binding var showingSheet: Bool
    
    let subscriptionCycle: [String] = ["monthly", "each three months", "each six months", "yearly"]
    let reminderOptions: [String] = ["The same day","One day before", "Two days before", "Three days before", "One week before"]
    
    
    @State var subscriptionName: String = ""
    @State var logo: String = ""
    @State var tintColor: String = "000000"
    @State var backgroundColor: String = "5C6362"
    @State var selectIconSheet: Bool = false
    @State var selectedIcon: String = "bills"
    
    @State var subscriptionPrice: String = ""
    @State var subscriptionStartDay: Date = Date()
    @State var subscriptionCycleSelected: String = "monthly"
    @State var subscriptionDescription: String = ""
    @AppStorage("notifications") var subscriptionReminderToggle = false
    @State var subscriptionReminderSelected: String = "The same day"
    @State var subcriptionIsDisable: Bool = false

    
    let notificationCenter = NotificationCenter()
    let dateCalculator = DateCalculator()
    @State var metaData: SubscriptionMetadata?
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                Color("backgroundColor")
                    .ignoresSafeArea()
                
                ScrollView {
                    Image(selectedIcon)
                        .resizable()
                        .modifier(ImageWithLogoModifier(backgroundColor: backgroundColor, tintColor: tintColor))
                        .onTapGesture {
                            selectIconSheet.toggle()
                        }
                    
                    Text("Press on icon to change it")
                        .font(.caption)
                        .foregroundStyle(.white)
                    
                    
                    // Name
                    TextFieldAndLabel(labelName: "Name", placeholder: "Subscription Name", textVariable: $subscriptionName, bigContainer: false)
                
                    
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
                    DatePickerComponent(subscriptionStartDay: $subscriptionStartDay)
                        
                    
                    // Subscription Cycle
                    PickerComponent(optionSelected: $subscriptionCycleSelected, title: "Cycle", options: subscriptionCycle)
                    
                    // Notes
                    TextFieldAndLabel(labelName: "Notes", placeholder: "Enter a description", textVariable: $subscriptionDescription, bigContainer: true)
                    
                    
                    
                    ToggleComponent(title: "Add Reminder", toggleOption: $subscriptionReminderToggle)
                    
                    
                    PickerComponent(optionSelected: $subscriptionReminderSelected, title: "Reminder", options: reminderOptions)
                        .disabled(!subscriptionReminderToggle)
                    
                    
                    ToggleComponent(title: "Disable",toggleOption: $subcriptionIsDisable)
                        .tint(.red)
                    
                    
                    Button {
                        
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
                        
                        
                        var metaData = SubscriptionMetadata(
                            id: .init(),
                            logo: selectedIcon,
                            tintColor: tintColor,
                            backgroundColor: backgroundColor,
                            notificationIdentifier: ""
                        )
                        
                        if !subcriptionIsDisable && subscriptionReminderToggle {
                            
                            notificationCenter.createNotification(
                                subscriptionName: subscriptionName,
                                reminderTime: subscriptionReminderSelected,
                                startDate: subscriptionStartDay,
                                cycle: subscriptionCycleSelected,
                                metadata: metaData)
                        }
                        
                        let newSub = Subscription(id: .init(),
                                                  name: subscriptionName,
                                                  price: Float(formattedPrice),
                                                  startDay: subscriptionStartDay,
                                                  cycle: subscriptionCycleSelected,
                                                  descriptionText: subscriptionDescription,
                                                  reminder: subscriptionReminderToggle,
                                                  reminderTime: subscriptionReminderSelected,
                                                  disableService: subcriptionIsDisable,
                                                  customSubscription: true,
                                                  subscriptionMetadata: metaData)
                        
                        
                        viewModel.addSubscription(subscription: newSub)
                        
                    
                        
                        
                        
                        
                        
                        
                        showingSheet.toggle()
                        
                        
                    } label: {
                        ButtonCustom(title: "Save", color: Color("buttonBackgroundColor"))
                            .padding(.bottom, 30)
                    }
                    
                    
                }
                .sheet(isPresented: $selectIconSheet) {
                    IconSelectionView(iconSelected: $selectedIcon, subscriptionName: self.$subscriptionName, startDate: self.$subscriptionStartDay, tintColor: $tintColor, backgroundColor: $backgroundColor)
                }
            }
            .navigationTitle("Create Subscription")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showingSheet.toggle()
                    } label: {
                        Text("Cancel")
                            
                    }

                }
            }
            
        }
        }
}

