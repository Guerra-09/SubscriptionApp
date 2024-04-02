//
//  ButtonCustom.swift
//  SubscriptionApp
//
//  Created by José Guerra on 01-04-24.
//

import SwiftUI

struct ButtonCustom: View {
    
    var title: String
    var color: Color
    
    var body: some View {
        Text(title)
            .frame(width: 350, height: 46)
            .background(color)
            .clipShape(Rectangle())
            .cornerRadius(18)
            .foregroundStyle(.white)
    }
}

#Preview {
    ButtonCustom(title: "title", color: Color("backgroundColor"))
}
