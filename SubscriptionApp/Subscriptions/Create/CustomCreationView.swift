//
//  CustomCreation.swift
//  SubscriptionApp
//
//  Created by José Guerra on 11-03-24.
//

import SwiftUI

struct CustomCreationView: View {
    var body: some View {
        ZStack {
            Color("backgroundColor")
                .ignoresSafeArea()
            
            VStack {
                Text("Creating an existing subscription")
                    .foregroundStyle(.white)
            }
        }
    }
}

#Preview {
    CustomCreationView()
}
