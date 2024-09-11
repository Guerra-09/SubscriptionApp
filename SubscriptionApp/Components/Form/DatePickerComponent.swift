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
 
            HStack {
                
                Text("Start day")
                    .foregroundStyle(.white)
                    .frame(minWidth: 120, maxWidth: 210, alignment: .leading)
                    .fontWeight(.bold)
                    .font(.system(size: 20))
                    .multilineTextAlignment(.center)
                    
                
            
                    
                DatePicker("", selection: $subscriptionStartDay,
                           in: ...Date(),
                           displayedComponents: .date)
                    
                    .fixedSize()
                    .datePickerStyle(.compact)
                    .foregroundStyle(.white)
                    .colorInvert()
                    .padding(5)
                    .colorMultiply(.white)
                    .clipShape(Rectangle())
                    
                        
                    
                
                
            }
            .padding(.vertical, 10)
        
        
        
    }
}

#Preview {
    ZStack {
        Color("backgroundColor")
        
        DatePickerComponent(subscriptionStartDay: .constant(Date()))
        

    }
}
