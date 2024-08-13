//
//  SubscriptionsViewModel.swift
//  SubscriptionApp
//
//  Created by José Guerra on 30-03-24.
//

import Foundation
import SwiftData
import SwiftDate


@Observable
final class SubscriptionsViewModel: ObservableObject {
    
    let container = try! ModelContainer(for: Subscription.self, SubscriptionMetadata.self)

    
    @MainActor
    var modelContext: ModelContext {
        container.mainContext
        
    }
    
    var subscriptions: [Subscription] = []
    
    @MainActor
    func getSubscriptions() {
        let fetchDescriptor = FetchDescriptor<Subscription>(predicate: nil, sortBy: [SortDescriptor<Subscription>(\.name)])
        subscriptions = try! modelContext.fetch(fetchDescriptor)
        print(subscriptions)
    }
    
    @MainActor
    func addSubscription(subscription: Subscription) {
        modelContext.insert(subscription)
        subscriptions = []
        getSubscriptions()
    }
    
    @MainActor
    func deleteAllSubscriptions() {
        subscriptions.forEach {
            modelContext.delete($0)
        }
        subscriptions = []
        getSubscriptions()
    }
    
    @MainActor
    func deleteSubscription(subscription: Subscription) {
        
        modelContext.delete(subscription)
        getSubscriptions()
    }
    
    @MainActor
    func deleteSubscriptionByLogo(subscription: SubscriptionModel) {

        for sub in subscriptions {
            
            if sub.subscriptionMetadata?.logo == subscription.logo {
                modelContext.delete(sub)
                getSubscriptions()
                return
            }
        }
        
        
    }


    func getTotalPrice() -> Float {
        
        var counter: Float = 0.0
        
        for sub in subscriptions {
            
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
        
        return counter
    }
    
    
    func getClosestPaymentSusbcription() -> (days: Int, subscription: Subscription)? {
        
        var result: (days: Int, subscription: Subscription)? = nil
        let calculator = DateCalculator()
        var closestPayment: Int? = nil
        
        
        for sub in self.subscriptions {
            
            // Obteniendo los dias hasta el siguiente pago en string
            let daysToPayment = calculator.getPaymentDay(startDay: sub.startDay, cycle: sub.cycle, aproximateDate: false)

      
            if let days = Int(daysToPayment) {
                if closestPayment == nil || days < closestPayment! {
                    closestPayment = days
                    result = (days: days, subscription: sub)
                }
            }
            
        }
        return result
       
    }
}
