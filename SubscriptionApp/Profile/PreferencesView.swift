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
//    let languages: [String] = ["English", "Español"]
//    let dateFormats: [String] = ["d-MM-YYYY", "MM-d-YYYY"]

    
    // Luego con un init deberia poner los datos de la DB
    @AppStorage("currencySelected") var currencySelected = "USD"
//    @AppStorage("dateFormatSelected") var dateFormatSelected = "MM-d-YYYY"
//    @AppStorage("languageSelected") var selectedLanguage = "English"
//    @AppStorage("notifications") var notificationsActive = false
    @State var notificationsEnabled: Bool = false
    @Binding var showToolbar: Bool
        
    @AppStorage("notificationHourString") private var notificationHourString: String = ""
    
        
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    @State private var notificationHour: Date = Date()
    private let notificationCenter = NotificationCenter()
    
    @State var title1 = "Currency"

    
    var body: some View {
        ZStack {
            Color("backgroundColor")
                .ignoresSafeArea()
            
            VStack {
                
                PickerComponent(optionSelected: $currencySelected, title: title1, options: currencies)
        

                DatePicker("Notification Time", selection: $notificationHour, displayedComponents: .hourAndMinute)
                    .onChange(of: notificationHour) { oldValue, newValue in
                        notificationHourString = dateFormatter.string(from: newValue)
                        updateNotificationTime()
                    }
                    .foregroundStyle(.white)
                    .colorScheme(.dark)
                    .fontWeight(.bold)
                    .font(.system(size: 20))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                
                
                    Text("This will change the time of ALL your subscriptions")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                        .frame(minWidth: 250, maxWidth: 350, alignment: .leading)
                        .padding(.vertical, 10)
                    
                        
                
                
                
                
                
                Button(action: {
                    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }, label: {
                    if notificationsEnabled {
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
            
            // Aquí asignas la hora guardada previamente si existe
            if let storedDate = dateFormatter.date(from: notificationHourString) {
                notificationHour = storedDate
            } else {
                notificationHour = Date()
            }
            
            
        }
        
        
        /// En desarrollo
        .navigationTitle("Preferences")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitleTextColor(.white)
    }
    
    private func checkNotificationAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            notificationsEnabled = settings.authorizationStatus == .authorized
        }
    }
    
    private func updateNotificationTime() {
        // Cambia la hora de todas las notificaciones aquí
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: notificationHour)
        let newHour = components.hour ?? 0
        let newMinute = components.minute ?? 0
        notificationHourString = dateFormatter.string(from: notificationHour)
                
        notificationCenter.changeNotificationTime(newHour: newHour, newMinute: newMinute)
    }
}
