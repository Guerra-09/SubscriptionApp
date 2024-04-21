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
    
    func formatPriceFromFloatToString(currency: String) -> String {
        let formatter = NumberFormatter()
        formatter.currencyCode = currency
        
        // Verificar si el código de moneda es USD
        if currency == "USD" {
            formatter.numberStyle = .currency
            formatter.maximumFractionDigits = 2 // Máximo 2 decimales para USD
            formatter.currencySymbol = "$" // Cambiar el símbolo de moneda a $
        } else {
            formatter.numberStyle = .currency // Estilo de moneda para otras monedas
            formatter.maximumFractionDigits = 0 // Sin decimales para otras monedas
            formatter.currencySymbol = "$" // Establecer el símbolo de moneda a $
        }
        
        // Cambiar el separador de decimales a un punto para CLP
        if currency == "CLP" {
            formatter.decimalSeparator = "." // Usar punto como separador decimal para CLP
            formatter.currencySymbol = "$" // Establecer el símbolo de moneda a $
        }
        
        let formattedPrice = formatter.string(from: NSNumber(value: self)) ?? ""
        
        return formattedPrice
    }
}
