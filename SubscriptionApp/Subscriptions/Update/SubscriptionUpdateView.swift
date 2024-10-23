//
//  SubscriptionUpdateView.swift
//  SubscriptionApp
//
//  Created by José Guerra on 01-04-24.
//

import SwiftUI
import SwiftData

struct SubscriptionUpdateView: View {
    
    let subscriptionCycle: [String] = ["monthly", "each three months", "each six months", "yearly"]
    let reminderOptions: [String] = ["The same day", "One day before", "Two days before", "Three days before", "One week before", "Two weeks before"]
    
    @ObservedObject var viewModel: SubscriptionsViewModel
    @State var showingAlertDelete: Bool = false
    @State var subscriptionPrice: String = ""
    @State var subscriptionToDelete: Subscription?
    @FocusState var priceFocus: Bool
    @Binding var showToolbar: Bool
    @Environment(\.dismiss) var dismiss
    @AppStorage("currencySelected") var currencySelected: String = "USD"
    @Bindable var subscription: Subscription
    
    // Variables para manejar el logo
    @State var selectedIcon: String = ""
    @State var tintColor: String = ""
    @State var backgroundColor: String = ""
    @State var selectIconSheet: Bool = false
    
    let notificationCenter = NotificationCenter()
//    var modelContext: ModelContext
    
    // Modifica el init para inicializar viewModel y showToolbar
//    init(subscriptionID: PersistentIdentifier, in container: ModelContainer, viewModel: SubscriptionsViewModel, showToolbar: Binding<Bool>) {
//        
//        // Inicializa viewModel y showToolbar al principio
//        self.viewModel = viewModel
//        self._showToolbar = showToolbar
//        
//        // Inicializa el contexto del modelo
//        modelContext = ModelContext(container)
//        modelContext.autosaveEnabled = false
//        
//        // Inicializa la suscripción
//        subscription = modelContext.model(for: subscriptionID) as? Subscription ?? Subscription(id: UUID(), name: "New subscription", price: 5.5, startDay: Date(), cycle: "monthly", descriptionText: "", reminder: false, reminderTime: "The same day", disableService: true, customSubscription: true, subscriptionMetadata: SubscriptionMetadata(id: UUID(), logo: "bills", tintColor: "#AAAAAA", backgroundColor: "#FFFFFF", notificationIdentifier: nil))
//        
//    }
    
    
    var body: some View {
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
                TextFieldAndLabel(labelName: "Name", placeholder: "Editar", textVariable: $subscription.name, bigContainer: false)
                                    
                
                // Price
                TextFieldAndLabel(labelName: "Price", placeholder: "$0.00", textVariable: $subscriptionPrice, bigContainer: false)
                    .focused($priceFocus)
                    // Por ahora como solo soporta USD y CLP, dejo esto asi, luego deberia incluir un enum o algo asi
                    .keyboardType(currencySelected == "USD" ? .decimalPad : .numberPad)
                    .onChange(of: subscriptionPrice) { oldValue, newValue in
                                                
                        var filteredText: String = ""
                        
                        if currencySelected == "USD" {
                            filteredText = decimalPriceFormat(newValue: newValue)
                            
                        } else if currencySelected == "CLP" {
                            
                            filteredText = wholeNumberPriceFormat(newValue: newValue)
                            
                        } else {
                            filteredText = "ERROR"
                        }
                        
                       
                        subscriptionPrice = "$" + filteredText
                        

                    }
                
                // Start day
                DatePickerComponent(subscriptionStartDay: $subscription.startDay)
                
                // Susbcription Cycle
                PickerComponent(optionSelected: $subscription.cycle, title: "Cycle", options: subscriptionCycle)
                
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
                    saveData()
                    
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
            .onAppear {
                self.selectedIcon = subscription.subscriptionMetadata?.logo ?? ""
                
                self.tintColor = subscription.subscriptionMetadata?.tintColor ?? ""
                
                self.backgroundColor = subscription.subscriptionMetadata?.backgroundColor ?? ""
                
            }
            .onChange(of: selectedIcon) { _, newValue in
                self.subscription.subscriptionMetadata?.logo = newValue
            }
            
            .onChange(of: tintColor) { _, newValue in
                self.subscription.subscriptionMetadata?.tintColor = newValue
            }
            .onChange(of: backgroundColor) { _, newValue in
                self.subscription.subscriptionMetadata?.backgroundColor = newValue
            }
            
            
            .scrollDismissesKeyboard(.immediately)
            .sheet(isPresented: $selectIconSheet) {
                IconSelectionView(
                    iconSelected: $selectedIcon,
                    subscriptionName: $subscription.name,
                    startDate: $subscription.startDay,
                    tintColor: $tintColor,
                    backgroundColor: $backgroundColor
                )

            }

            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        saveData()
                    }
                }
            }
            

            
        }
        .onAppear {
            
            showToolbar = false
            
            self.subscriptionPrice = String(subscription.price).replacingOccurrences(of: ".", with: ",")
            formatPrice()
        }

        
        .alert("Are you sure you want to delete?", isPresented: $showingAlertDelete) {
            Button("Cancel", role: .cancel) { print("Cancelling") }
            
            Button("Delete", role: .destructive) {
                notificationCenter.deleteRequest(identifier: subscription.subscriptionMetadata?.notificationIdentifier ?? "")
                
                viewModel.deleteSubscription(subscription: subscriptionToDelete!)

                dismiss()
            }
            
        }
    }

    func saveData() -> Void {
        
        var valueToSave: Float {

            let replacingMoneySing = self.subscriptionPrice.replacingOccurrences(of: "$", with: "")
            
            let newValue = replacingMoneySing.replacingOccurrences(of: ",", with: ".")
            
            return Float(newValue) ?? 0.0
        }
        
        self.subscription.price = valueToSave
        
        notificationCenter.modifyNotification(subscriptionName: subscription.name, reminderTime: subscription.reminderTime, startDate: subscription.startDay, cycle: subscription.cycle, metadata: subscription.subscriptionMetadata!) // UNSAFE UNWRAPPING
        
        
        dismiss()
        
    }
    
    
    func formatPrice() -> Void {
        
        let removingMoneySign = subscriptionPrice.replacingOccurrences(of: "$", with: "")

        var replacingCommas = removingMoneySign
        
        replacingCommas = replacingCommas.replacingOccurrences(of: ",", with: ".")
       

        // Convertir el texto limpio a un valor Float
        if let floatValue = Float(replacingCommas) {
            self.subscription.price = floatValue
        } else {
            self.subscription.price = 0.0
        }
    }

    
    func decimalPriceFormat(newValue: String) -> String {
        
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
        
        return filteredText
    }
    
    
    func wholeNumberPriceFormat(newValue: String) -> String {
        var filteredText = newValue.filter { "0123456789,".contains($0) }
        
        if let commaIndex = filteredText.firstIndex(of: ",") {
            filteredText = String(filteredText.prefix(upTo: commaIndex))
        }

        return filteredText
        
    }

}
