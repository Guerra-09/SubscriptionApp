//
//  ExistingCreationViewModel.swift
//  SubscriptionApp
//
//  Created by José Guerra on 30-03-24.
//

import Foundation
import SwiftData

@Observable
final class ExistingCreationViewModel: ObservableObject {
    let container = try! ModelContainer(for: Subscription.self)
    
    @MainActor
    var modelContext: ModelContext {
        container.mainContext
    }

    @MainActor
    func addSubscription(subscription: Subscription) {
        modelContext.insert(subscription)
    }
    
}
