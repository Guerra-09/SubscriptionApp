//
//  FloatExtension.swift
//  SubscriptionApp
//
//  Created by José Guerra on 02-04-24.
//

import Foundation
import SwiftUI

extension Float {
    func decimals(_ nbr: Int) -> String {
        String(self.formatted(.number.precision(.fractionLength(nbr))))
    }
}
