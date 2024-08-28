//
//  SettingsSheetView.swift
//  SubscriptionApp
//
//  Created by José Guerra on 19-08-24.
//

import SwiftUI

struct SubscriptionsSettingsSheet: View {
    
    @ObservedObject var viewModel: SubscriptionsViewModel // Solo para pruebas, despues deberia borrarse el viewmodel y la opcion de borrar todo
    @Environment(\.dismiss) var dismiss
    
    var tags: [String] = ["all", "music", "streaming", "gaming"]
    
    @AppStorage("showInactive") var showInactive: Bool = true
//    @AppStorage("whiteTheme") var whiteTheme: Bool = false
//    @AppStorage("showAproximateDate") var showAproximateDate: Bool = false
    @AppStorage("tag") var tag: String = "all"
    
    
    let notificationCenter = NotificationCenter()
    
    var body: some View {
        ZStack {
            Color("backgroundColor")
                .ignoresSafeArea()
            
            VStack {
                
                Toggle(isOn: $showInactive, label: {
                    Text("Show inactives")
                        .foregroundStyle(.white)
                })
                .padding()
                
//                Toggle(isOn: $showAproximateDate, label: {
//                    Text("Show aproximate date")
//                        .foregroundStyle(.white)
//                    Text("Example: instead of 8 days -> next week")
//                        .font(.caption)
//                        .foregroundStyle(.white)
//                })
//                .padding()
                
//                Toggle(isOn: $whiteTheme, label: {
//                    Text("Show white theme")
//                        .foregroundStyle(.white)
//                })
//                .disabled(true)
//                .padding()
                
                PickerComponent(optionSelected: $tag, title: "Tag Filtering", options: tags)
                    .disabled(true)
                
                
                Spacer()
                
                Button(action: {
                    dismiss()
                    viewModel.deleteAllSubscriptions()
                    notificationCenter.deleteAllNotifications()
                    
                }, label: {
                    Text("DELETE ALL DEVELOPER OPTION")
                        .foregroundStyle(.red)
                })
                
                Button(action: {
                    dismiss()
                }, label: {
                    ButtonCustom(title: "Save", color: .buttonBackground)
                })
            }
            .padding(.top, 30)

        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitleTextColor(.white)
        
    }
}

