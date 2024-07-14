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
    @State var sub: (days: Int, subscription: Subscription)?


    
    var body: some View {
        ZStack {
            Color("backgroundColor")
                .ignoresSafeArea()
            
            
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        
                        HStack {
                            Text("Renewing Soon")
//                                .font(.system(size: 25))
                                .font(.title)
                                .bold()
                            
                            Spacer()
                        }
                        
                        
                        
                        HStack {
                            
                            if let logo = sub?.subscription.subscriptionMetadata?.logo {
                                Image(logo)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .padding(10)
                                    .background(Color(hex: "293638"))
                                    .cornerRadius(15)
                                
                            } else {
                                Text("Error loading logo")
                            }
                            
                            VStack {
                                if let name = sub?.subscription.name {
                                    HStack {
                                        Text(name)
                                        Spacer()
                                    }
                                } else {
                                    Text("Error loading name")
                                }
                                
                                
                                if let days = sub?.days {
                                    HStack {
                                        Text("Renew in \(days) days")
                                        Spacer()
                                    }
                                } else {
                                    Text("Error calculating days")
                                }
                                
                            }
                            Spacer()
                        }
                        .padding(.bottom, 20)

                        
                        
                        Text("Stats")
                            .font(.title)
                            .bold()
                            .padding(.bottom, 10)
                        
                        
                        
                        Text("You have \(viewModel.subscriptions.count) subscriptions")
                            
                        
                        Section {
                            Text("Monthly Spent \n \(Float(monthlySpent)?.formatPriceFromFloatToString(currency: currencySelected) ?? "ERROR")")
                                .font(.title2)
                                .bold()

                            
                            Text("Yearly Spent \n  \(Float(yearlySpent)?.formatPriceFromFloatToString(currency: currencySelected) ?? "ERROR")")
                                .font(.title2)
                                .bold()
                            
                        }
                        .padding(.top, 15)
                        
                    }
                    .frame(width: 350)
//                    .background(.red)
             
                }
                Spacer()
            }
            .padding(.top, 15)
            
        }
        .onAppear {
            viewModel.getSubscriptions()
            self.sub = viewModel.getClosestPaymentSusbcription()
            getExpenses()
        }
        
        .navigationTitle("Welcome \(profileName)")
        .navigationBarTitleTextColor(.white)
            
        
    }

    
    
    func getExpenses() {
        
        let monthlyPrice = viewModel.getTotalPrice()
        
        self.monthlySpent = String(monthlyPrice)
        self.yearlySpent = String(monthlyPrice * 12)

    }
    
    
}
