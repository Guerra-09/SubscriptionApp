//
//  PersonalInformationView.swift
//  SubscriptionApp
//
//  Created by José Guerra on 11-03-24.
//

import SwiftUI

struct PersonalInformationView: View {
    var body: some View {
        ZStack {
            Color("backgroundColor")
                .ignoresSafeArea()
            
            VStack {
                
                Text("Personal Information View")
                    .foregroundStyle(.white)
                
            }
            
        }
    }
}

#Preview {
    PersonalInformationView()
}
