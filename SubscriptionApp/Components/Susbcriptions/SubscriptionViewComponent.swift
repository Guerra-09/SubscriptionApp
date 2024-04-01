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
    var reminder: Bool
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
                            .font(.system(size: 21))
                        
                        Text("$\(price)/month")
                            .font(.callout)
                    }
                    .padding(.leading, 10)
                    
                    Spacer()
                    
                    
                    if disableService {
                        Text("Inactive")
                            .fontWeight(.bold)
                    } else {
                        Text("Active")
                            .fontWeight(.bold)
                    }
                    
                }
                .padding(10)
                .frame(width: 370, height: 80)
                .background(Color(hex: backgroundColor))
                .clipShape(Rectangle())
                .cornerRadius(15)
                
                    
                    
//                Text(startDay.formatted(.dateTime))

//                Text("\(reminder)")

            }
            .foregroundStyle(.white)
        }
    }
}

#Preview {
    SubscriptionViewComponent(logo: "netflix_logo", logoColor: "FFFFFF", backgroundColor: "D82929", name: "Netflix", price: 12, startDay: Date(), reminder: true, disableService: false)
}
