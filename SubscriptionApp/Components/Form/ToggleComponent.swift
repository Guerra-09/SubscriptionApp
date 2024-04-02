//
//  ToggleComponent.swift
//  SubscriptionApp
//
//  Created by José Guerra on 01-04-24.
//

import SwiftUI

struct ToggleComponent: View {
    
    var title: String
    @Binding var toggleOption: Bool
    
    var body: some View {
        VStack {
            
            Toggle(isOn: $toggleOption) {
                Text(title)
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                    .font(.system(size: 20))
                    
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            
        }
    }
}

#Preview {
    ToggleComponent(title: "Title", toggleOption: .constant(true))
}
