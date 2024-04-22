//
//  PersonalInformationView.swift
//  SubscriptionApp
//
//  Created by José Guerra on 11-03-24.
//

import SwiftUI

struct PersonalInformationView: View {
    
    @AppStorage("profileName") var profileName: String = "Guest"
    @Environment(\.dismiss) var dismiss
    @Binding var showToolbar: Bool
    
    var body: some View {
        ZStack {
            Color("backgroundColor")
                .ignoresSafeArea()
            
            VStack {
                
                TextFieldAndLabel(labelName: "Display name", placeholder: "\(profileName)", textVariable: $profileName, bigContainer: false)
                    .padding(.bottom, 20)
                
                Spacer()
                
                Button {
                    // Aqui deberia guardar los datos
                    dismiss()
                } label: {
                    ButtonCustom(title: "Save", color: Color("buttonBackgroundColor"))
                }
                .padding(.bottom, 10)

                
                Text("Soon more options...")
                    .font(.caption)
                    .foregroundStyle(.white)

                
               
                
            }
            .onAppear {
                showToolbar = false
            }
            .padding(.top, 15)
            .navigationTitle("Personal information")
            .toolbarTitleDisplayMode(.inline)
            .navigationBarTitleTextColor(.white)
            
            
        }
    }
}


