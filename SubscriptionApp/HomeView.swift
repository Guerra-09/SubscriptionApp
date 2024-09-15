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
    @State var sub: (days: Int, subscription: Subscription)? = nil
    
    //Animation variables
    
    @State private var isVisible = true
    @State private var offset: CGFloat = 0
    
    var body: some View {
        ZStack {
            Color("backgroundColor")
                .ignoresSafeArea()
            
                
            VStack {
                if let sub = sub {
                    HStack {
                        VStack(alignment: .leading) {
                            
                            HStack {
                                Text("Renewing Soon")
                                    .font(.title)
                                    .bold()
                                
                                Spacer()
                            }
                            
                            
                            HStack {
                                if let logo = sub.subscription.subscriptionMetadata?.logo {
                                    
                                    Image(logo)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .padding(10)
                                        .background(Color(hex: "293638"))
                                        .cornerRadius(15)
                                }
                                
                                
                                
                                
                                
                                VStack {
                                    
                                    HStack {
                                        Text(sub.subscription.name)
                                        Spacer()
                                    }
                                    
                                    
                                    
                                    
                                    HStack {
                                        Text("Renew in \(sub.days) days")
                                        Spacer()
                                    }
                                    
                                    HStack {
                                        Text("$\(String(format: "%.2f", sub.subscription.price))")
                                        Spacer()
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
                        
                    }
                    Spacer()
                } else {
                    Spacer()
                    Text("There's no data to show here\n go add some subscriptions in subscriptions tab")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .padding(5)
                        
                    
                    Spacer()
                    
                    
                    
                    Image(systemName: "arrow.down")
                        .resizable()
                        .scaledToFit()
                        .frame(minWidth: 40, maxWidth: 80, minHeight: 40, maxHeight: 80)
                        .padding(.bottom, 15)
                        .opacity(isVisible ? 1 : 0)
                        .offset(y: offset)
                        .onAppear {
                            let baseAnimation = Animation.easeInOut(duration: 0.8)
                            let repeated = baseAnimation.repeatForever(autoreverses: true)
                            withAnimation(repeated) {
                                isVisible.toggle()
                                offset = offset == 0 ? 10 : 0
                            }
                        }
                    
                        
                    
                }
            }
            .padding(.top, 15)
            
            
            
        }
        .foregroundStyle(.white)
        .onAppear {
            viewModel.getSubscriptions()
            self.sub = viewModel.getClosestPaymentSusbcription()
//            viewModel.getClosestPaymentSusbcription()
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
