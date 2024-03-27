//
//  ExistingCreationView.swift
//  SubscriptionApp
//
//  Created by José Guerra on 11-03-24.
//

import SwiftUI

struct ExistingCreationView: View {
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
    ExistingCreationView()
}
