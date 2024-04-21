//
//  MainView.swift
//  SubscriptionApp
//
//  Created by José Guerra on 11-03-24.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var viewModel: SubscriptionsViewModel
    @AppStorage("profileName") var profileName: String = "Guest"
    @State var monthlySpent: String = ""
    @State var yearlySpent: String = ""
    @AppStorage("currencySelected") var currencySelected: String = "USD"
    
    var body: some View {
        ZStack {
            Color("backgroundColor")
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Text("Average Monthly Expenses: \(Float(monthlySpent)?.formatPriceFromFloatToString(currency: currencySelected) ?? "ERROR")")
                    .foregroundStyle(.white)
                
                Text("Average Yearly Expenses: \(Float(yearlySpent)?.formatPriceFromFloatToString(currency: currencySelected) ?? "ERROR")")
                    .foregroundStyle(.white)
            }
            
            
        }
        .onAppear {
            viewModel.getSubscriptions()
            getMonthlyAmount()
        }
        
        .navigationTitle("Welcome \(profileName)")
        .navigationBarTitleTextColor(.white)
            
        
    }

    
    
    func getMonthlyAmount() {

        var counter: Float = 0.0
        
        for sub in viewModel.subscriptions {
            
            if sub.disableService == false {
                
                if sub.cycle == "monthly" {
                    counter += sub.price
                    
                } else if sub.cycle == "each three months" {
                    counter += (sub.price / 3)
                    
                } else if sub.cycle == "each six months" {
                    counter += (sub.price / 6)
                    
                } else if sub.cycle == "yearly" {
                    counter += (sub.price / 12)
                    
                }
            }
            
        }
        
        self.monthlySpent = String(counter)
        self.yearlySpent = String(counter*12)

    }
    
    
}


#Preview {
    NavigationStack {
        HomeView()
    }
}

