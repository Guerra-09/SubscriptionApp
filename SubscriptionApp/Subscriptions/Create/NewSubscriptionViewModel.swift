//
//  SubscriptionViewModel.swift
//  SubscriptionApp
//
//  Created by José Guerra on 27-03-24.
//

import Foundation

class NewSubscriptionViewModel: ObservableObject {
    @Published var subscriptions = [SubscriptionModel]()
    
    init() {
        loadData()
    }
    
    func loadData() {
            if let url = Bundle.main.url(forResource: "SubscriptionsExisting", withExtension: "json") {
                
                do {
                    let data = try Data(contentsOf: url)

                    let subs = try JSONDecoder().decode([SubscriptionModel].self, from: data)
                    self.subscriptions = subs
                } catch {
                    print("Error al cargar los datos del archivo JSON:", error)
                }
            } else {
                print("No se encontró el archivo JSON")
            }
        }
    
    
//    func filterAdded(subscriptionsAdded: [String]) -> Void  {
//        
//    }
}
