//
//  SubscriptionViewModel.swift
//  SubscriptionApp
//
//  Created by José Guerra on 27-03-24.
//

import Foundation

class SubscriptionViewModel: ObservableObject {
    @Published var subscriptions = [Subscription]()
    
    init() {
        loadData()
    }

    
    func loadData() {
            if let url = Bundle.main.url(forResource: "SubscriptionsExisting", withExtension: "json") {
                print("URL del archivo JSON:", url)
                
                do {
                    let data = try Data(contentsOf: url)
                    print("Datos del archivo JSON:", String(data: data, encoding: .utf8) ?? "No se pudieron convertir los datos a UTF-8")
                    
                    let subs = try JSONDecoder().decode([Subscription].self, from: data)
                    self.subscriptions = subs
                } catch {
                    print("Error al cargar los datos del archivo JSON:", error)
                }
            } else {
                print("No se encontró el archivo JSON")
            }
        }
}
