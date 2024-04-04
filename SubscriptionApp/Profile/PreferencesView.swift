//
//  PreferencesView.swift
//  SubscriptionApp
//
//  Created by José Guerra on 29-03-24.
//

import SwiftUI

struct PreferencesView: View {
    
    @Environment(\.dismiss) var dismiss
    
    let currencies: [String] = ["USD", "CLP", "EUR", "CAD", "AUD"]
    let languages: [String] = ["English", "Spanish"]

    
    
    // Luego con un init deberia poner los datos de la DB
    @AppStorage("currencySelected") var currencySelected = "USD"
    @AppStorage("languageSelected") var selectedLanguage = "English"
    @AppStorage("notifications") var notificationsActive = false
    var body: some View {
        ZStack {
            Color("backgroundColor")
                .ignoresSafeArea()
            
            VStack {
                
                PickerComponent(optionSelected: $currencySelected, title: "Currency", options: currencies)
                
                PickerComponent(optionSelected: $selectedLanguage, title: "Language", options: languages)
                
                ToggleComponent(title: "Notifications", toggleOption: $notificationsActive)
                    
                Spacer()
                
                Button {
                    // Aqui deberia guardar los datos
                    dismiss()
                } label: {
                    ButtonCustom(title: "Save", color: Color("buttonBackgroundColor"))
                        
            
                }
            }
            
            
            
        }
        .navigationTitle("Preferences")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitleTextColor(.white)
    }
}

#Preview {
    NavigationStack {
        PreferencesView()
    }
}
