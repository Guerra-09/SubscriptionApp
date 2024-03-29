//
//  PreferencesView.swift
//  SubscriptionApp
//
//  Created by José Guerra on 29-03-24.
//

import SwiftUI

struct PreferencesView: View {
    
    let languages: [String] = ["English", "Spanish"]
    
    @State var selectedLanguage = "English"
    
    var body: some View {
        ZStack {
            Color("backgroundColor")
                .ignoresSafeArea()
            
            VStack {
                
                Picker("Languages", selection: $selectedLanguage) {
                    ForEach(languages, id: \.self) { value in
                        Text(value)
                    }
                }
                
                
                Button {
                    
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
