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
    var textColor: String
    
    var name: String
    var price: Float
    var cycle: String
    
    var startDay: Date
    var reminder: Bool
    var disableService: Bool
    
    
    @State var priceFormat = ""
    @State var dateCalculator = DateCalculator()
    
    @AppStorage("showAproximateDate") var showAproximateDate: Bool = false
    @AppStorage("currencySelected") var currencySelected: String = "USD"
    
    
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
                        
                        Text("\(price.formatPriceFromFloatToString(currency: "\(currencySelected)"))")
                                .font(.callout)
                        
                        
                    }
                    .padding(.leading, 10)
                    
                    Spacer()
                    
                    VStack {

                            
                        Text("\(dateCalculator.getPaymentDay(startDay: startDay, cycle: self.cycle, aproximateDate: showAproximateDate))")
                        Text("To next payment")
                            .font(.caption)
                        
                    }
                    
                }
                .padding(10)
                .frame(width: 370, height: 80)
                .background(Color(hex: backgroundColor))
                .clipShape(Rectangle())
                .cornerRadius(15)


            }
            .foregroundStyle(Color(hex: textColor))
        }
        .onAppear {
            print(logo)
        }
    }
        

    
}

