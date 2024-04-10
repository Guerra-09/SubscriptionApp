//
//  DateCalculator.swift
//  SubscriptionApp
//
//  Created by José Guerra on 07-04-24.
//

import Foundation
import SwiftDate


class DateCalculator {
    
    let secondsInDay: TimeInterval = 24 * 60 * 60


    
    func getPaymentDay(startDay: Date, cycle: String, aproximateDate: Bool) -> String {
    
//        print("[D] cycle: \(cycle)")
        
        var daysUntilPayment: Int = 0
        
        // Si el ciclo es mensual
        if cycle == "monthly" {
            daysUntilPayment = daysUntilMonthly(startDate: startDay)
            
        } else if cycle == "each three months" {
            daysUntilPayment = daysUntilThreeMonths(startDate: startDay)
            
        } else {
            return "Aun no esta hecho xD"
        }
        
        
        
        
        if aproximateDate {
                        
            return getAproximateDate(daysUntilPayment: daysUntilPayment)
            
        } else {
            
            if daysUntilPayment == 1  {
                return "\(Int(daysUntilPayment)) day"
            } else {
                return "\(Int(daysUntilPayment)) days"
            }
            
        }
        
        
        

    }
    
    
    func daysUntilThreeMonths(startDate: Date) -> Int {


        
        let calendar = Calendar.current
        // Obtener la cantidad de meses entre el primer pago hasta hoy
        let components = calendar.dateComponents([.month], from: startDate, to: Date())
        
        let nextPaymentDate = Date()

        // Si entra en este caso significa que toca pagar este mes
        if components.month! % 3 == 0 && components.month == Date().month {
            print("[D] faltan 3 meses para pagar!")
            
        } else if components.month! % 3 == 0 {
            print("[D] toca pagar!!")
            
        } else if components.month! % 3 == 1 {
            print("[D] Faltan 2 meses para pagar")
            
        } else if components.month! % 3 == 2 {
            print("[D] el proximo mes se paga")
        }
            
        
        print("[D] components: \(components.month!)")
        print("[D] restos: \(components.month! % 3)")
        

        return 0
    }
    
    
//     Esta funcion retorna los dias cuando el ciclo es mensual
    func daysUntilMonthly(startDate: Date) -> Int {
        
        // StartDate
        let firstPaymentDay = startDate.day

        // Current
        let actualDay = Date().day
        let actualMonth = Date().month
        let actualYear = Date().year
        
        
        // Creating fixing date
        var month = actualMonth
        var day = firstPaymentDay
        let monthLater = Date().dateByAdding(1, .month)
        let nextMonthLastDay = monthLater.date.lastDateOfPreviousMonth

        
        // Si el mes siguiente tiene menos meses, se toma el ultimo dia del mes
        if nextMonthLastDay!.day < firstPaymentDay {
            day = nextMonthLastDay!.day
        } else {
            day = firstPaymentDay
        }
        
        // Si el dia actual es mayor al dia de pago, se le suma un mes porque ya se se pago, de lo contrario es el mismo mes, pero falta para que llegue el dia para pagar
        if actualDay > day {
            month += 1
        }
        
        // Creando formater para la fecha de facturacion
        let nextPayment = "\(day)-\(month)-\(actualYear)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date = dateFormatter.date(from: nextPayment)

        let result = Date().distance(to: date!)
        
        print("[D] nextPayment: \((result / secondsInDay).rounded(.up))")
        print("[D] ----------------------------")
        
        
        return Int((result / secondsInDay).rounded(.up))

    }
    


    /// Mejorar: Transformar String a [String] para pasar dos parametros y manejar mejor el texto de la vista.
    func getAproximateDate(daysUntilPayment :Int) -> String {
        
        
        if daysUntilPayment == 0 {
            return "today"
        }
    
        // Si son menos de 7 dias retorna el numero de dias
        else if daysUntilPayment < 7 {
            return "\(daysUntilPayment)"
            
        // Si son entre 8 y 13 dias retorna la next week
        } else if daysUntilPayment > 7 && daysUntilPayment < 14 {
            return "next week"
        
        // Si son entre 14 y 20 dias retorna en dos semanas
        } else if daysUntilPayment >= 14 && daysUntilPayment < 30 {
            return "more than two weeks"
            
        } else if daysUntilPayment >= 30 && daysUntilPayment < 60 {
            return "more than one month"
            
        } else if daysUntilPayment >= 60 && daysUntilPayment < 90 {
            return "more than two months"
        
            
        } else if daysUntilPayment >= 90 {
            return "more than three months"
            
        } else {
            return "ERROR"
        }
  
    }
 

}
 
