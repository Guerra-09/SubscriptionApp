//
//  PickerComponent.swift
//  SubscriptionApp
//
//  Created by José Guerra on 01-04-24.
//

import SwiftUI

struct PickerComponent: View {
    
    @Binding var optionSelected: String
    var title: String
    var options: [String]
    
    var body: some View {
        VStack {
            Text(title)
                .foregroundStyle(.white)
                .frame(width: 350,alignment: .leading)
                .fontWeight(.bold)
                .font(.system(size: 20))
            
            
            Picker("Select", selection: $optionSelected) {
                ForEach(options, id: \.self) {
                    Text($0)
                }
            }
            .accentColor(.white)
            .padding()
            .frame(width: 370, height: 58, alignment: .leading)
            .background(Color("subViewsBackgroundColor"))
            .clipShape(Rectangle())
            .cornerRadius(15)
        }
    }
}

#Preview {
    PickerComponent(optionSelected: .constant("the same day"), title: "Title of view", options: ["the same day", "other day", "never"])
}
