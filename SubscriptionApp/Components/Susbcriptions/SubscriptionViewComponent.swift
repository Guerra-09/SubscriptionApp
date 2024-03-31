//
//  SubscriptionView.swift
//  SubscriptionApp
//
//  Created by José Guerra on 30-03-24.
//

import SwiftUI

struct SubscriptionViewComponent: View {
    
    var logo: String
    var logoColor: String
    var backgroundColor: String
    
    var name: String
    var price: Int
    
    var startDay: Date
    var cycle: String
    var descriptionText: String
    var reminder: Bool
    var reminderTime: String
    var disableService: Bool
    
    
    var body: some View {
        ZStack {
            Color("backgroundColor")
                .ignoresSafeArea()
            
            VStack {
                
                HStack {
                    Image(logo)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50)
                        .foregroundStyle(Color(hex: logoColor))

                    
                    VStack(alignment: .leading) {
                        Text(name)
                            .font(.title)
                        
                        Text("$\(price)/month")
                            .font(.callout)
                    }
                    .padding(.leading, 10)
                    
                    Spacer()
                    
                    Text("Inactive")
                        .fontWeight(.bold)
                }
                .padding(10)
                .frame(width: 370, height: 80)
                .background(Color(hex: backgroundColor))
                .clipShape(Rectangle())
                .cornerRadius(15)
                
                    
                
//                Text("$\(String(price))")
//                
//                Text(startDay.formatted(.dateTime))
//                
//                Text(cycle)
//                
//                Text(descriptionText)
//                
//                Text("\(reminder)")
//                
//                Text(reminderTime)
//                
//                Text("\(disableService)")
            }
            .foregroundStyle(.white)
        }
    }
}

#Preview {
    SubscriptionViewComponent(logo: "spotify_logo.svg", logoColor: "FFFFFF", backgroundColor: "26AC5C", name: "Netflix", price: 12, startDay: Date(), cycle: "Monthly", descriptionText: "For my son", reminder: true, reminderTime: "the same day", disableService: false)
}
