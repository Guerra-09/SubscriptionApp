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
    
        
        var daysUntilPayment: Int = 0
        
        // Si el ciclo es mensual
        if cycle == "monthly" {
            daysUntilPayment = daysUntilMonthly(startDate: startDay)
            
        } else if cycle == "each three months" {
            daysUntilPayment = daysUntilThreeMonths(startDate: startDay)
            
        } else if cycle == "each six months" {
            daysUntilPayment = daysUntilSixMonths(startDate: startDay)
            
        } else if cycle == "yearly" {
            daysUntilPayment = daysUntilYear(startDate: startDay)
            
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
    
    // Esta funcion retorna los dias cuando el ciclo es mensual
    // Revisar -> 01-02-2024
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
        
//        print("[D] nextPayment: \((result / secondsInDay).rounded(.up))")
//        print("[D] ----------------------------")
        
        
        return Int((result / secondsInDay).rounded(.up))

    }
    
    
    func daysUntilThreeMonths(startDate: Date) -> Int {

  
        let calendar = Calendar.current
        let componentMonth = calendar.dateComponents([.month], from: startDate, to: Date())
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
   
        var dayOfPayment: Int = startDate.day
        var yearOfPayment: Int = Date().year
        var monthOfPayment = Date().month
        
        
        
        if componentMonth.month! % 3 == 0 {
            
            // Si es el mismo dia con 3 meses de diferencia es porque se paga ese dia
            if startDate.day == Date().day {
                print("[D] Restos 0: Se paga hoy")
                
            } else {
                print("[D] Restos 0: Se paga en 3 meses")
                monthOfPayment += 3 // Agregando los 3 meses.
            }
            
        
        } else if componentMonth.month! % 3 == 1 {
            print("[D] Restos 1: Se paga en 2 meses")
            monthOfPayment += 2 // Agregando los 3 meses.
            
        } else if componentMonth.month! % 3 == 2 {
            
            // Si el dia de inicio es mayor al actual, significa que se paga este mes en unos dias.
            if startDate.day > Date().day {
                print("[D] Restos 2: En unos dias")
                
            } else {
                print("[D] Restos 2: Se paga en 1 mes")
                monthOfPayment += 1 // Agregando los 3 meses.
            }
  
        } else {
            print("[D] Restos ELSE")
        }
        
        // Si los meses dan mas de 12, le resto esos meses y agrego un año
        if monthOfPayment > 12 {
            monthOfPayment -= 12
            yearOfPayment += 1
        }

    
        
        
        // Creando formater para la fecha de facturacion
        let nextPayment = "\(dayOfPayment)-0\(monthOfPayment)-\(yearOfPayment)"
        var date = dateFormatter.date(from: nextPayment)
        
        if date == nil {
            // Ajustar el día hasta que la fecha sea válida, pero no menos de 27
            var newDay = dayOfPayment
            while newDay > 27 && date == nil {
                newDay -= 1
                let adjustedPayment = "\(newDay)-0\(monthOfPayment)-\(yearOfPayment)"
                date = dateFormatter.date(from: adjustedPayment)
            }
        }
        

        let result = Date().distance(to: date ?? Date())
        

        print("[D] StartDatePayment: \(startDate.toFormat("dd-MM-yyyy"))")
        print("[D] NextPaymentDate \(date!.toFormat("dd-MM-yyyy"))")
        print("[D] nextPayment in days: \((result / secondsInDay).rounded(.up))")
        print("[D] --------------------------------")
        
        

        return Int((result / secondsInDay).rounded(.up))
    }
    
    
    func daysUntilSixMonths(startDate: Date) -> Int {
            
        let calendar = Calendar.current
        let componentMonth = calendar.dateComponents([.month], from: startDate, to: Date())
            
        var dayOfPayment: Int = startDate.day
        var yearOfPayment: Int = Date().year
        var monthOfPayment = Date().month
            
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "us_US")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "UTC") // Establecer la zona horaria según sea necesario
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Establecer la configuración regional en inglés para usar el calendario gregoriano

            
        if componentMonth.month! % 6 == 0 {
                
            // Si es el mismo dia con 3 meses de diferencia es porque se paga ese dia
            if startDate.day == Date().day {
                print("[D] Restos 0: Se paga hoy")
                    
            } else {
                print("[D] Restos 0: Se paga en 6 meses")
                monthOfPayment += 6 // Agregando los 3 meses.
            }
                
                
        } else if componentMonth.month! % 6 == 1 {
            print("[D] Restos 1: Se paga en 5 meses")
            
            monthOfPayment += 5 // Agregando los 5 meses.
                
        } else if componentMonth.month! % 6 == 2 {
                
            // Si el dia de inicio es mayor al actual, significa que se paga este mes en unos dias.
            print("[D] Restos 2: Se paga en 4 meses")
            monthOfPayment += 4 // Agregando los 4 meses.
                
        } else if componentMonth.month! % 6 == 3 {
            print("[D] Restos 3: Se paga en 3 meses")
            monthOfPayment += 3
                
        } else if componentMonth.month! % 6 == 4 {
            print("[D] Restos 4: Se paga en 2 meses")
            monthOfPayment += 2
                
        } else if componentMonth.month! % 6 == 5 {
                
            if startDate.day > Date().day {
                print("[D] Restos 5: Se paga en unos dias")

                // monthOfPayment += 1// ERROR
                    
            } else {
                print("[D] Restos 5: Se paga en 1 mes")
                monthOfPayment += 1
            }
        } else {
                
            print("[D] Restos ELSE \(componentMonth.month! % 6)")
        }
            
        // Si los meses dan mas de 12, le resto esos meses y agrego un año
        if monthOfPayment > 12 {
            monthOfPayment -= 12
            yearOfPayment += 1
        }

            
        // Creando formater para la fecha de facturacion
        let monthString = monthOfPayment < 10 ? "0\(monthOfPayment)" : "\(monthOfPayment)"
        let dayString = dayOfPayment < 10 ? "0\(dayOfPayment)" : "\(dayOfPayment)"
        let nextPayment = "\(yearOfPayment)-\(monthString)-\(dayString)"
            
        var date = dateFormatter.date(from: nextPayment)
            
        if date == nil {
            // Ajustar el día hasta que la fecha sea válida, pero no menos de 27
            var newDay = dayOfPayment
            while newDay > 27 && date == nil {
                newDay -= 1
                let adjustedPayment = "\(yearOfPayment)-\(monthString)-\(newDay)"
                date = dateFormatter.date(from: adjustedPayment)
            }
        }


        let result = Date().distance(to: date ?? Date())

        print("[D] StartDatePayment: \(startDate.toFormat("dd-MM-yyyy"))")
        print("[D] NextPaymentDate \(date?.toFormat("dd-MM-yyyy") ?? "ERROR")")
        print("[D] nextPayment in days: \((result / secondsInDay).rounded(.up))")
        print("[D] --------------------------------")

        return Int((result / secondsInDay).rounded(.up))
    }

    
    func daysUntilYear(startDate: Date) -> Int {
            
        let calendar = Calendar.current
        let componentYear = calendar.dateComponents([.year], from: startDate, to: Date())
        
        var yearsToAdd = 0
        
        if (startDate.day == Date().day) && (startDate.month == Date().month) {
            print("[D] Se paga hoy")
        } else {
            yearsToAdd = componentYear.year! + 1
            print("[D] Se paga en un tiempo mas")
        }
        
        var result = TimeInterval()
        
        print("[D] years to add \(yearsToAdd) ")
        
        let nextPayment = startDate.dateByAdding(yearsToAdd, .year)
        
        if (startDate.day == Date().day) && (startDate.month == Date().month) {
            result = TimeInterval(integerLiteral: 0)
            
        } else {
            result = Date().distance(to: nextPayment.date)
            
        }
        
    
        
        print("[D] yearly")
        print("[D] nextPayment \(nextPayment.toFormat("dd-MM-yyyy"))")
        print("[D] nextPayment in days: \((result / secondsInDay).rounded(.up))")
        
        print("[D] ------- ")
        
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
 
