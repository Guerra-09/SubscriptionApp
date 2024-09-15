//
//  SubscriptionView.swift
//  SubscriptionApp
//
//  Created by José Guerra on 30-03-24.
//

import SwiftUI

struct SubscriptionViewComponent: View {
    
    var logo: String
    var tintColor: String
    var backgroundColor: String
    
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
                        .foregroundStyle(Color(hex: tintColor))
                        
                    
                    VStack(alignment: .leading) {
                        Text(name)
                            .font(.system(size: 21))
                        
                        Text("\(price.formatPriceFromFloatToString(currency: "\(currencySelected)"))")
                                .font(.callout)
                        
                        
                    }
                    .padding(.leading, 10)
                    
                    Spacer()
                    
                    VStack {
                        
                        if let nextPayment = Int(dateCalculator.getPaymentDay(startDay: startDay, cycle: self.cycle, aproximateDate: showAproximateDate)) {
                            
                            if nextPayment == 0 {
                                Text("Today")
                                Text("is the payment")
                                    .font(.caption)
                                
                            } else if nextPayment == 1 {
                                
                                
                                Text("\(nextPayment) day")
                                Text("to the next payment")
                                    .font(.caption)
                                
                            } else {
                                Text("\(nextPayment) days")
                                Text("to the next payment")
                                    .font(.caption)
                            }
                            
                        } else {
                            Text("Error INT()")
                        }

                        
                    }
                    
                }
                .padding(10)
                .frame(width: 370, height: 80)
                .background(Color(hex: backgroundColor))
                .clipShape(Rectangle())
                .cornerRadius(15)


            }
            .foregroundStyle(Color(hex: tintColor))
        }
        .onAppear {
            print(logo)
        }
    }
        

    
    
}

