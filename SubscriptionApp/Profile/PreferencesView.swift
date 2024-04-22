//
//  PreferencesView.swift
//  SubscriptionApp
//
//  Created by José Guerra on 29-03-24.
//

import SwiftUI
import UserNotifications

struct PreferencesView: View {
    
    @Environment(\.dismiss) var dismiss
    
    let currencies: [String] = ["USD", "CLP"] // Con el tiempo ire agregando mas monedas...
    let languages: [String] = ["English", "Español"]

    
    // Luego con un init deberia poner los datos de la DB
    @AppStorage("currencySelected") var currencySelected = "USD"
    @AppStorage("languageSelected") var selectedLanguage = "English"
//    @AppStorage("notifications") var notificationsActive = false
    @State var notificationsEnabled: Bool = false
    @Binding var showToolbar: Bool
        
    
    var body: some View {
        ZStack {
            Color("backgroundColor")
                .ignoresSafeArea()
            
            VStack {
                
                PickerComponent(optionSelected: $currencySelected, title: "Currency", options: currencies)
                
                PickerComponent(optionSelected: $selectedLanguage, title: "Language", options: languages)
                    .disabled(true)

                
                Button(action: {
                    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }, label: {
                    if !notificationsEnabled {
                        ButtonCustom(title: "Allow Notifications", color: .green)
                    } else {
                        ButtonCustom(title: "Disallow Notifications", color: .red)
                    }
                  
                })
                .padding(.top, 20)
                
                Spacer()
                
                Button {
                    // Aqui deberia guardar los datos
                    dismiss()
                } label: {
                    ButtonCustom(title: "Save", color: Color("buttonBackgroundColor"))
                    
                    
                }
            }
            .padding(.top, 10)
            
            
            
        }
        .onAppear {
            showToolbar = false
            checkNotificationAuthorizationStatus()

            
        }

        
        /// En desarrollo
        .onChange(of: selectedLanguage, { oldValue, newValue in
            
            var localizable = ""
            
            if newValue == "English" {
                localizable = "en"
            } else if newValue == "Español" {
                localizable = "es"
            }

        })
        .navigationTitle("Preferences")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitleTextColor(.white)
    }
    
    private func checkNotificationAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            notificationsEnabled = settings.authorizationStatus == .authorized
        }
    }
}
