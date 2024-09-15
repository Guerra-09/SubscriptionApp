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
        HStack {
            Text(title)
                .foregroundStyle(.white)
                .frame(width: 140,alignment: .leading)
                .fontWeight(.bold)
                .font(.system(size: 20))
                .multilineTextAlignment(.center)
            
            
            
            Picker("Select", selection: $optionSelected) {
                ForEach(options, id: \.self) {
                    Text($0)
                }
            }
            .accentColor(.white)
            .frame(minWidth: 120, maxWidth: 190, maxHeight: 26, alignment: .center)
            .padding(5)
            .background(Color("subViewsBackgroundColor").opacity(0.15))
            .cornerRadius(10)
     
            
               
            

        }
        .padding(.vertical, 10)
    }
}

#Preview {
    
    ZStack {
        Color("backgroundColor")
        
        PickerComponent(optionSelected: .constant("Monthly"), title: "Cycle", options: ["Monthly", "Each three months", "each six months", "yearly"])
    }
    
    
}
