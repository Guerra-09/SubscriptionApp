//
//  SubscriptionModel.swift
//  SubscriptionApp
//
//  Created by José Guerra on 27-03-24.
//

import Foundation
import SwiftUI

struct SubscriptionModel: Codable, Identifiable {
    
    let id = UUID()
    let name: String
    let textColor: String
    let logo: String
    let logoColor: String
    let backgroundColor: String
}
