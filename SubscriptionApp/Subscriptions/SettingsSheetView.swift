//
//  SettingsSheetView.swift
//  SubscriptionApp
//
//  Created by José Guerra on 19-08-24.
//

import SwiftUI

struct SubscriptionsSettingsSheet: View {
    

    @Environment(\.dismiss) var dismiss
    
    var tags: [String] = ["all", "music", "streaming", "gaming"]
    
    let viewModel: SubscriptionsViewModel
    @AppStorage("showInactive") var showInactive: Bool = true
    
    
    let notificationCenter = NotificationCenter()
    
    var body: some View {
        ZStack {
            Color("backgroundColor")
                .ignoresSafeArea()
            
            VStack {
                
                Toggle(isOn: $showInactive, label: {
                    Text("Show disabled subscriptions")
                        .foregroundStyle(.white)
                })
                .padding()
                
                                
                
                Spacer()
                
                Button(action: {
                    dismiss()
                    viewModel.deleteAllSubscriptions()
                    notificationCenter.deleteAllNotifications()
                    
                }, label: {
                    Text("DELETE ALL DEVELOPER OPTION")
                        .foregroundStyle(.red)
                })
//                
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

