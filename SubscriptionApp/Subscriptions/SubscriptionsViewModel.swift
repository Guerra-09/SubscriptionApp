//
//  SubscriptionsViewModel.swift
//  SubscriptionApp
//
//  Created by José Guerra on 30-03-24.
//

import Foundation
import SwiftData

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
}
