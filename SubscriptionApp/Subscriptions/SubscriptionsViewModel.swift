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
    
    func getClosestPaymentSusbcription(currentDate now: Date = Date()) -> (days: Int, subscription: Subscription)? {
        
        let newsub: Subscription = Subscription(id: UUID(), name: "nil", price: 0.0, startDay: Date(), cycle: "monthly", descriptionText: "", reminder: true, reminderTime: "The same day", disableService: false, customSubscription: false, subscriptionMetadata: SubscriptionMetadata(id: UUID(), logo: "netflix_logo", logoColor: "e50914", backgroundColor: "ffffff", textColor: "e50914"))
        
        guard !subscriptions.isEmpty else { return (days: 0, subscription: newsub) }
        
        let dateCalculator = DateCalculator()
        var daysUntilNextPayment: [Int: Subscription] = [:]
        
        for subscription in subscriptions {
            let daysUntilNextPaymentDate = dateCalculator.daysUntilMonthly(startDate: subscription.startDay)
            print("[D] days until next payment for subscription \(daysUntilNextPaymentDate) : \(subscription.name)")
            daysUntilNextPayment[daysUntilNextPaymentDate] = subscription
        }
        
        if let closestDays = daysUntilNextPayment.keys.min() {
            let closestSubscription = daysUntilNextPayment[closestDays]!
            print("[D] closest subscription is \(closestSubscription.name) with \(closestDays) days until next payment")
            return (days: closestDays, subscription: closestSubscription)
        } else {
            print("[D] No subscriptions found with future payment dates")
            return (days: 0, subscription: newsub)
        }
    }
}
