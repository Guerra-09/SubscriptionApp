//
//  ProfileView.swift
//  SubscriptionApp
//
//  Created by José Guerra on 11-03-24.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color("backgroundColor")
                    .ignoresSafeArea()
                
                VStack {
                    Text("Profile View")
                        .foregroundStyle(Color(.white))
                    
                    NavigationLink("To personal info"){
                      PersonalInformationView()
                    }
                    NavigationLink("To notifications set up"){
                      NotificationsView()
                    }
                    
                }
                
            }
        }
    }
}

#Preview {
    ProfileView()
}
