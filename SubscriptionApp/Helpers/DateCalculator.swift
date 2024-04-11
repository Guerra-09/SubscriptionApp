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
        
        
        
        
        let newCalendar = Calendar.current
        let componentsDays = newCalendar.dateComponents([.day], from: Date(), to: Date())
    
        var dayOfPayment: Int = startDate.day // Si el mes tiene menos dias, tiene que ser el ultimo
        var monthOfPayment = Date().month
        var yearOfPayment: Int = Date().year

        
        
        // Si entra en este caso significa que toca pagar este mes
        if components.month! % 3 == 0 && components.month == Date().month {
            monthOfPayment += 3
            print("[D] faltan tres meses para pagar! [0]")
            
        } else if components.month! % 3 == 0 {
            
            
            if startDate.day < Date().day {
                print("[D] Se paga en tres meses [1]")
                monthOfPayment += 3
                
            } else if startDate.day == Date().day {
                
                
                if startDate.month == Date().month && startDate.year != Date().year {
                    
                    print("[D] Se paga hoy [2]")
                    
                } else if startDate.month == Date().month && startDate.year == Date().year {
                    print("[D] Se paga hoy [2.1]")
                            
                } else {
                    monthOfPayment += 3
                    print("[D] Se paga en tres meses [3]")
                }
                
                
            } else {
                monthOfPayment += 2
                print("[D] Se paga en dos meses [4]")
            }
            
        } else if components.month! % 3 == 1 {
            
            if startDate.day < Date().day {
                print("[D] Se paga en un mes [5]")
                monthOfPayment += 1
                
            } else if startDate.day == Date().day {
                print("[D] Se paga en un mes [6]")
                monthOfPayment += 1
                
            } else {
                print("[D] Faltan un mes para pagar [7]")
                monthOfPayment += 1
            }
            
            
            
        } else if components.month! % 3 == 2 {
//            print("[D] Se paga en un mes ")
            
            if startDate.day > Date().day {
                print("[D] Se paga este mes [8]")
                monthOfPayment = Date().month
                
            } else {
                print("[D] Se paga en dos meses [9]")
                monthOfPayment+=2
            }
        
        
        }
        

        // revisar xd
        if (startDate.month != 0) || Date().month >= 10 {
            yearOfPayment += 1
            monthOfPayment = 1
            
        } else if (startDate.month != 0) || Date().month == 11 {
            yearOfPayment += 1
            monthOfPayment = 2
            
        } else if (startDate.month != 0) || Date().month == 12 {
            yearOfPayment += 1
            monthOfPayment = 3
        }


        let monthsLater = Date().dateByAdding(1, .month)
        let nextMonthLastDay = monthsLater.date.lastDateOfPreviousMonth
        var lastDay = nextMonthLastDay!.day
        
        if lastDay <= dayOfPayment {
            dayOfPayment = lastDay
        }
        
        // Creando formater para la fecha de facturacion
        let nextPayment = "\(dayOfPayment)-\(monthOfPayment)-\(yearOfPayment)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date = dateFormatter.date(from: nextPayment)

        let result = Date().distance(to: date!)
        
        
        
//        print("[D] Components: \(components.month!)")
        print("[D] Restos: \(components.month! % 3)")
//        print("[D] NextPayment: \(componentsDays)")
        print("[D] NextPaymentDate \(date!.toFormat("dd-MM-yyyy"))")
        print("[D] nextPayment: \((result / secondsInDay).rounded(.up))")
        print("[D] --------------------------------")
        
        
        

        return Int((result / secondsInDay).rounded(.up))
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
        
//        print("[D] nextPayment: \((result / secondsInDay).rounded(.up))")
//        print("[D] ----------------------------")
        
        
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
 
