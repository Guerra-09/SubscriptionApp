//
//  DatePickerComponent.swift
//  SubscriptionApp
//
//  Created by José Guerra on 29-03-24.
//

import SwiftUI

struct DatePickerComponent: View {
    
    @Binding var subscriptionStartDay: Date
    
    var body: some View {
        
        ZStack {
            Color("backgroundColor")
                .ignoresSafeArea()
            
            
            VStack {
                
                Text("Start day")
                    .foregroundStyle(.white)
                    .frame(width: 350,alignment: .leading)
                    .fontWeight(.bold)
                    .font(.system(size: 20))
                
                HStack {
                    
                    DatePicker("", selection: $subscriptionStartDay,
                               in: ...Date(),
                               displayedComponents: .date)
                        .padding()
                        .fixedSize()
                        .datePickerStyle(.compact)
                        .foregroundStyle(.white)
                        .colorInvert()
                        .colorMultiply(.white)
                        .frame(width: 370, height: 58, alignment: .leading)
                        .background(Color("subViewsBackgroundColor"))
                        .clipShape(Rectangle())
                        .cornerRadius(15)
                        
                    
                        Spacer()
                }
                
                
            }
            .padding(10)
        }
        
        
        
    }
}

//#Preview {
//    DatePickerComponent()
//}
