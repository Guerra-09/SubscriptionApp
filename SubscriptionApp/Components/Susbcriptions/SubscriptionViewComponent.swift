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
    
    var startDay: Date
    var reminder: Bool
    var disableService: Bool
    
    @AppStorage("showAproximateDate") var showAproximateDate: Bool = false
    
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
                        

                        Text("$\(price.decimals(2))")
                            .font(.callout)
                    }
                    .padding(.leading, 10)
                    
                    Spacer()
                    
                    VStack {

                            
                        Text("\(getPaymentDay(startDay: startDay, cycle: "monthly", aproximateDate: showAproximateDate))")
                        Text("To next payment")
                            .font(.caption)
                        
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
            .foregroundStyle(Color(hex: textColor))
        }
    }
    
    func getPaymentDay(startDay: Date, cycle: String, aproximateDate: Bool) -> String {
        
        let actualDate = self.startDay
        let payDate = actualDate.dateByAdding(1, .month)
        
        let payDay = payDate.day
        let payDateMonth = payDate.month
        var nextMonthLastDay = 0
        
        if payDay > 29 {
            
            if payDateMonth == 1 {
                nextMonthLastDay = 31
            } else if payDateMonth == 2 {
                nextMonthLastDay = payDate.isLeapYear ? 29 : 28
            } else if payDateMonth == 3 {
                nextMonthLastDay = 31
            } else if payDateMonth == 4 {
                nextMonthLastDay = 30
            } else if payDateMonth == 5 {
                nextMonthLastDay = 31
            } else if payDateMonth == 6 {
                nextMonthLastDay = 30
            } else if payDateMonth == 7 {
                nextMonthLastDay = 31
            } else if payDateMonth == 8 {
                nextMonthLastDay = 31
            } else if payDateMonth == 9 {
                nextMonthLastDay = 30
            } else if payDateMonth == 10 {
                nextMonthLastDay = 31
            } else if payDateMonth == 11 {
                nextMonthLastDay = 30
            } else if payDateMonth == 12 {
                nextMonthLastDay = 31
            } else {
                print("ERROR CALCULATING LAST DAY")
                return "ERROR"
            }
            
        } else {
            
            let secondsPerDay: TimeInterval = 24 * 60 * 60
            let daysUntilNextBill = Date().distance(to: payDate.date) / secondsPerDay
            
            print("[DEBUG] currentBill: \(actualDate)")
            print("[DEBUG] nextBill: \(payDate.date.formatted(.iso8601))")
            print("[DEBUG] in days: \(Int(daysUntilNextBill.rounded()))")
            
            
            if !aproximateDate {
                return "\(Int(daysUntilNextBill.rounded())) days"
                
            } else {
                var aproximate = getAproximateDate(daysUntilPayment: Int(daysUntilNextBill.rounded()))
                
                return "\(aproximate) days"
            }
   
        }
        return "ERROR"
    }
    
    
    func getAproximateDate(daysUntilPayment :Int) -> String {
        
        // Si son menos de 7 dias retorna el numero de dias
        if daysUntilPayment < 7 {
            return "\(daysUntilPayment)"
            
        // Si son entre 8 y 13 dias retorna la next week
        } else if daysUntilPayment > 7 && daysUntilPayment < 14 {
            return "next week"
        
        // Si son entre 14 y 20 dias retorna en dos semanas
        } else if daysUntilPayment >= 14 && daysUntilPayment < 30 {
            return "more than two weeks"
            
        } else if daysUntilPayment >= 30 && daysUntilPayment < 60 {
            return "more than one month"
            
        } else if daysUntilPayment >= 60 && daysUntilPayment < 90 {
            return "more than two months"
        
            
        } else if daysUntilPayment >= 90 {
            return "more than three months"
            
        } else {
            return "ERROR"
        }
  
    }
 
    
}

#Preview {
    SubscriptionViewComponent(logo: "netflix_logo", logoColor: "FFFFFF", backgroundColor: "D82929", textColor: "FFFFFF", name: "Netflix", price: 12.5, startDay: Date(), reminder: true, disableService: false)
}
