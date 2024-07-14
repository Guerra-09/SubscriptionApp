//
//  DateCalculator.swift
//  SubscriptionApp
//
//  Created by José Guerra on 07-04-24.
//

import Foundation
import SwiftDate

// 25-04-24 22:01
// La fecha da uno mas, puede que tenga que cambiarlo desde la vista apra que la fecha que de sea la local del telefono.

/// Funcion creada para calcular fechas entre subscripciones, entre mensuales, cada 3 meses, cada 6 meses y anuales. 
class DateCalculator {
    
    let secondsInDay: TimeInterval = 24 * 60 * 60
    let dateFormatter = DateFormatter()
    var calendar = Calendar.current
    let timeZone = TimeZone.current
    
    
    
    
    init() {
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "d-M-yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        calendar.timeZone = timeZone
    }
    

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
            
            return "\(Int(daysUntilPayment))"
            
        }
                
    }
    
    

    /// Funcion encargada de retornar la fecha de la siguiente facturacion segun fecha de inicio cuando la subscripcion tiene un ciclo mensual. Retorna un tipo Date
    func getNextPaymentDateMonthly(startDate: Date, testDate now: Date = Date()) -> Date {
        
        let firstPaymentDay = calendar.component(.day, from: startDate)
        
        let components = calendar.dateComponents([.year, .month, .day], from: now)
        let actualDay = components.day!
        var actualMonth = components.month!
        var actualYear = components.year!
        
        print("[D] ACTUAL DAY \(actualDay)")
        
        // Añadir un mes a la fecha actual
        var nextMonthComponents = DateComponents()
        nextMonthComponents.month = 1
        
        if let nextMonthDate = calendar.date(byAdding: nextMonthComponents, to: now),
           let range = calendar.range(of: .day, in: .month, for: nextMonthDate) {
            let nextMonthLastDay = range.count
            
            
            // Ajustar el día de pago si el día del primer pago no existe en el próximo mes
            var paymentDay = firstPaymentDay
            if nextMonthLastDay < firstPaymentDay {
                paymentDay = nextMonthLastDay
            }
            
            
            if actualDay > paymentDay {
                actualMonth += 1
                if actualMonth > 12 {
                    actualMonth = 1
                    actualYear += 1
                }
            }
            
            var creationComponents = DateComponents()
            creationComponents.day = paymentDay
            creationComponents.month = actualMonth
            creationComponents.year = actualYear
            
            print("[D] creationComponents \(creationComponents)")
            print("[D] paymentDay \(paymentDay)")
            
            // Verificando si la fecha que se va a crear existe.
            if dateFormatter.date(from: "\(creationComponents.day!)-\(creationComponents.month!)-\(creationComponents.year!)") != nil {
                print("[D] Se crea correctamente")
                
                let date = calendar.date(from: creationComponents)
                
                return date!
                
                
            } else {
                print("[D] FAILED AL CREAR DATE ")
                
                var date = dateFormatter.date(from: "\(String(describing: creationComponents.day))-\(actualMonth)-\(String(describing: creationComponents.year))")
                

                var newDay = paymentDay
                while newDay > 27 && date == nil {
                    newDay -= 1
                    date = dateFormatter.date(from: "\(newDay)-\(creationComponents.month!)-\(creationComponents.year!)")
                
                    
                }
                

                return date ?? Date()
            }
            
            
            
            
            
            
        }
        print("[D] Returning now")
        return now // En caso de falla, retorna la fecha actual (esto debería ser manejado de manera más robusta)
    }
        
    
    
    /// Funcion encargada de retornar los dias restantes hasta la siguiente facturacion segun fecha de inicio cuando la subscripcion tiene un ciclo de pago mensual. Retorna un Int, que son los dias que faltan.
    func daysUntilMonthly(startDate: Date, now: Date = Date()) -> Int {
        
        let date = getNextPaymentDateMonthly(startDate: startDate, testDate: now)
        
        let result = now.distance(to: date)
        
        
        return Int((result / secondsInDay).rounded(.up))

    }
    
    

    
    /// Funcion encargada de retornar la fecha de la siguiente facturacion segun fecha de inicio cuando la subscripcion tiene un ciclo de pago de 3 meses. Retorna un tipo Date
    func getNextPaymentDateThreeMonths(startDate: Date, testDate now: Date = Date()) -> Date {
        
        let calendar = Calendar.current
        let componentMonth = calendar.dateComponents([.month], from: startDate, to: now)
   
        let dayOfPayment: Int = startDate.day
        var yearOfPayment: Int = startDate.year
        var monthOfPayment = now.month
        
        print("[D] testDate \(now)")
        
        if componentMonth.month! % 3 == 0 {
            
            // Si es que el dia es menor y no hay restos, se agregan dos meses
            if startDate.day > now.day {
                print("[D] Restos 0: Se paga en dos meses")
                monthOfPayment += 2
                
            // Si es el mismo dia con 3 meses de diferencia es porque se paga ese dia
            } else if startDate.day != now.day {
                print("[D] Restos 0: Se paga en 3 meses -> \(startDate.day) ? \(now.day)")
                monthOfPayment += 3 // Agregando los 3 meses.
                
            } else {
                print("[D] Restos 0: Se paga hoy")
            }
            
        
        } else if componentMonth.month! % 3 == 1 {
            
            if startDate.day >= now.day {
                print("[D] Restos 1: Se paga en 1 mes")
                monthOfPayment += 1
                
            } else {
                print("[D] Restos 1: Se paga en 2 meses")
                monthOfPayment += 2 // Agregando los 3 meses.
            }
            
            
            
            
            
        } else if componentMonth.month! % 3 == 2 {
            
            // Si el dia de inicio es mayor al actual, significa que se paga este mes en unos dias.
            if startDate.day > now.day {
                print("[D] Restos 2: En unos dias")
                
            } else if startDate.day == now.day {
                print("[D] Restos 2: En dos meses mas")
                monthOfPayment += 1
                
            } else {
                print("[D] Restos 2: Se paga en 1 mes")
                monthOfPayment += 1 // Agregando los 3 meses.
            }
  
        } else {
            print("[D] Restos ELSE")
        }
        
        
        // Si los meses dan mas de 12, le resto esos meses y agrego un año.
        if monthOfPayment > 12 {
            monthOfPayment -= 12
            yearOfPayment += 1
            print("[D] agregando anio quitando meses")
            
        } else if monthOfPayment == 1 || monthOfPayment == 2 {
            yearOfPayment += 1
        }
 
    
        
        // Crear componentes de fecha
        var dateComponents = DateComponents()
        dateComponents.day = dayOfPayment
        dateComponents.month = monthOfPayment
        dateComponents.year = yearOfPayment
        
        
        // Crear la fecha usando el calendario actual
        var date = dateFormatter.date(from: "\(dateComponents.day!)-\(dateComponents.month!)-\(dateComponents.year!)")
        
        
        
        if date == nil {
            print("[D] date nil")
            
            
            // Ajustar el día hasta que la fecha sea válida, pero no menos de 27
            var newDay = dayOfPayment
            while newDay > 27 && date == nil {
                newDay -= 1
                
                let adjustedPayment = "\(newDay)-0\(monthOfPayment)-\(dateComponents.year!)"
                date = self.dateFormatter.date(from: adjustedPayment)
            }
            
            
        }
        
        return date ?? Date()
//        return Date()
    }
    
    
    /// Funcion encargada de retornar los dias restantes hasta la siguiente facturacion segun fecha de inicio cuando la subscripcion tiene un ciclo de pago de 3 meses. Retorna un Int, que son los dias que faltan.
    func daysUntilThreeMonths(startDate: Date, testDate now: Date = Date()) -> Int {
        
        let date = getNextPaymentDateThreeMonths(startDate: startDate, testDate: now)

        let result = now.distance(to: date)
        
        

        return Int((result / secondsInDay).rounded(.up))
    }
    

    
    
    /// Funcion encargada de retornar la fecha de la siguiente facturacion segun fecha de inicio cuando la subscripcion tiene un ciclo de pago de 6 meses. Retorna un tipo Date
    /// Funciona pero falta testear mas casos
    func getNextPaymentDateSixMonths(startDate: Date, testDate now: Date = Date()) -> Date {
        
        let calendar = Calendar.current
        let componentMonth = calendar.dateComponents([.month], from: startDate, to: now)
            
        var dayOfPayment: Int = startDate.day
        var yearOfPayment: Int = now.year
        var monthOfPayment = now.month

            
        if componentMonth.month! % 6 == 0 {
                
            // Si es el mismo dia con 3 meses de diferencia es porque se paga ese dia
            if startDate.day == now.day {
                print("[D] Restos 0: Se paga hoy")
                    
            } else {
                print("[D] Restos 0: Se paga en 6 meses")
                monthOfPayment += 5
            }
                
                
        } else if componentMonth.month! % 6 == 1 {
            print("[D] Restos 1: Se paga en 5 meses")
            
            monthOfPayment += 4 // Agregando los 5 meses.
                
        } else if componentMonth.month! % 6 == 2 {

            print("[D] Restos 2: Se paga en 4 meses")
            monthOfPayment += 3 // Agregando los 4 meses.
                
        } else if componentMonth.month! % 6 == 3 {
            print("[D] Restos 3: Se paga en 3 meses")
            monthOfPayment += 2
                
        } else if componentMonth.month! % 6 == 4 {
            print("[D] Restos 4: Se paga en 2 meses")
            monthOfPayment += 1
                
        } else if componentMonth.month! % 6 == 5 {
                
            if startDate.day > now.day {
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

            
        // Crear componentes de fecha
        var dateComponents = DateComponents()
        dateComponents.day = dayOfPayment
        dateComponents.month = monthOfPayment
        dateComponents.year = yearOfPayment
        
        var date = dateFormatter.date(from: "\(dateComponents.day!)-\(dateComponents.month!)-\(dateComponents.year!)")
            
//        var date = Calendar.current.date(from: dateComponents)
            
        
        
        if date == nil {
            // Ajustar el día hasta que la fecha sea válida, pero no menos de 27
            var newDay = dayOfPayment
            while newDay > 27 && date == nil {
                newDay -= 1
                let adjustedPayment = "\(newDay)-0\(monthOfPayment)-\(yearOfPayment)"
                date = self.dateFormatter.date(from: adjustedPayment)
            }
        }
        
        return date ?? Date()
        
    }

    
    /// Funcion encargada de retornar los dias restantes hasta la siguiente facturacion segun fecha de inicio cuando la subscripcion tiene un ciclo de pago de 6 meses. Retorna un Int, que son los dias que faltan.
    func daysUntilSixMonths(startDate: Date, testDate now: Date = Date()) -> Int {
            
        
        let date = getNextPaymentDateSixMonths(startDate: startDate, testDate: now)

        let result = now.distance(to: date)


        return Int((result / secondsInDay).rounded(.up))
    }

    
    
    func daysUntilYear(startDate: Date, testDate now: Date = Date()) -> Date {
  
    
        return Date()
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

    
    // En evaluacion si incluir o no...
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
    
    func getReminderDate(paymentDate: Date, daysBefore: Int) -> Date {
        
        return Calendar.current.date(byAdding: .day, value: -daysBefore, to: paymentDate)!
    }


}
 
