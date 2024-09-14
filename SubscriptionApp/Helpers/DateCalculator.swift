//
//  DateCalculator.swift
//  SubscriptionApp
//
//  Created by José Guerra on 07-04-24.
//

import Foundation
import SwiftDate

/// Clase encargada de convertir una fecha actual, en dias hasta el siguiente pago.
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
    
    /// Funcion encargada de retornar la fecha hasta el siguiente pago.
    ///
    ///- Parameters:
    ///     - startDay: Este parametro recibe el dia de inicio
    ///     - cycle: Este parametro recibe el ciclo de la subscripcion, mensual, trimetral, etc.
    ///     - aproximateDate: Este parametro recibe un `Boolean`, dependiendo si se quiere obtener una fecha "aproximada" ejemplo: "Hoy", "Esta semana", "En dos semanas", "En un mes", etc. Si se quiere obtener los numeros perse para el pago se puede dejar como false.
    ///
    ///- Returns: Retorna un `String` con los dias faltantes para el siguiente pago, ya sea en dias o en un aproximado.
    ///
    /// Important:
    /// Warning:
    /// Experiment:
    /// Tip:
    ///
    ///
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
    
    

    /// Funcion encargada de retornar la fecha de la siguiente facturacion segun fecha de inicio cuando la subscripcion tiene un ciclo mensual.
    ///
    /// Esta funcion no es usada como tal, ya que se llama desde la funcion `daysUntilMonthly`.
    ///
    ///- Parameters:
    ///     - startDate: Este parametro recibe la fecha de inicio de la subscripcion.
    ///     - testDate: Este parametro solo debe ser usado en testing y se usa para simular una fecha diferente a la actual.
    ///
    ///
    /// - Returns: Retorna un `Date` con la fecha que deberia ser el siguiente pago.
    func getNextPaymentDateMonthly(startDate: Date, testDate now: Date = Date()) -> Date {
        
        let firstPaymentDay = calendar.component(.day, from: startDate)
        
        let components = calendar.dateComponents([.year, .month, .day], from: now)
        let actualDay = components.day!
        var actualMonth = components.month!
        var actualYear = components.year!
        
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
            
            // Verificando si la fecha que se va a crear existe.
            if dateFormatter.date(from: "\(creationComponents.day!)-\(creationComponents.month!)-\(creationComponents.year!)") != nil {
                
                let date = calendar.date(from: creationComponents)
                
                return date!
                
                
            } else {
                print("[F] FAILED AL CREAR DATE ")
                
                var date = dateFormatter.date(from: "\(String(describing: creationComponents.day))-\(actualMonth)-\(String(describing: creationComponents.year))")
                

                var newDay = paymentDay
                while newDay > 27 && date == nil {
                    newDay -= 1
                    date = dateFormatter.date(from: "\(newDay)-\(creationComponents.month!)-\(creationComponents.year!)")
                
                    
                }
                

                return date ?? Date()
            }
            
            
            
            
            
            
        }
        return now // En caso de falla, retorna la fecha actual (esto debería ser manejado de otra manera)
    }
        
    
    
    /// Funcion encargada de retornar los dias restantes hasta la siguiente facturacion segun fecha de inicio cuando la subscripcion tiene un ciclo de pago mensual. Retorna un Int, que son los dias que faltan.
    ///
    ///- Parameters:
    ///     - startDate: Este parametro recibe la fecha de inicio de la subscripcion.
    ///     -  now: Este parametro tiene por defecto la fecha actual y solo se usa en caso de querer testear la funcion y simular una fecha distinta.
    ///
    /// - Returns: Retorna un `Int` que equivalen a los dias faltantes para la siguiente facturacion.
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
                monthOfPayment += 2
                
            // Si es el mismo dia con 3 meses de diferencia es porque se paga ese dia
            } else if startDate.day != now.day {
                
                monthOfPayment += 3 // Agregando los 3 meses.
                
            } else {
            }
            
        
        } else if componentMonth.month! % 3 == 1 {
            
            if startDate.day >= now.day {
                monthOfPayment += 1
                
            } else {
                monthOfPayment += 2 // Agregando los 3 meses.
            }
            
            
            
            
            
        } else if componentMonth.month! % 3 == 2 {
            
            // Si el dia de inicio es mayor al actual, significa que se paga este mes en unos dias.
            if startDate.day > now.day {
                
            } else if startDate.day == now.day {
                monthOfPayment += 1
                
            } else {
                monthOfPayment += 1 // Agregando los 3 meses.
            }
  
        } else {
            print("[D] Restos ELSE")
        }
        
        
        // Si los meses dan mas de 12, le resto esos meses y agrego un año.
        if monthOfPayment > 12 {
            monthOfPayment -= 12
            yearOfPayment += 1
            
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
    }
    
    
    /// Funcion encargada de retornar los dias restantes hasta la siguiente facturacion segun fecha de inicio cuando la subscripcion tiene un ciclo de pago de 3 meses. Retorna un Int, que son los dias que faltan.
    func daysUntilThreeMonths(startDate: Date, testDate now: Date = Date()) -> Int {
        
        let date = getNextPaymentDateThreeMonths(startDate: startDate, testDate: now)

        let result = now.distance(to: date)
        
        

        return Int((result / secondsInDay).rounded(.up))
    }
    

    
    
    /// Funcion encargada de retornar la fecha de la siguiente facturacion segun fecha de inicio cuando la subscripcion tiene un ciclo de pago de 6 meses. Retorna un tipo Date
    func getNextPaymentDateSixMonths(startDate: Date, testDate now: Date = Date()) -> Date {
        
        let calendar = Calendar.current
        let componentMonth = calendar.dateComponents([.month], from: startDate, to: now)
            
        let dayOfPayment: Int = startDate.day
        var yearOfPayment: Int = now.year
        var monthOfPayment = now.month

            
        if componentMonth.month! % 6 == 0 {
                
            // Si es el mismo dia con 3 meses de diferencia es porque se paga ese dia
            if startDate.day == now.day {
                print("[D] TESTING 1: getNextPaymentDateSixMonths")
                        
            } else {
                monthOfPayment += 5
            }
                
                
        } else if componentMonth.month! % 6 == 1 {
            
            monthOfPayment += 4 // Agregando los 5 meses.
                
        } else if componentMonth.month! % 6 == 2 {

            monthOfPayment += 3 // Agregando los 4 meses.
                
        } else if componentMonth.month! % 6 == 3 {
            monthOfPayment += 2
                
        } else if componentMonth.month! % 6 == 4 {
            monthOfPayment += 1
                
        } else if componentMonth.month! % 6 == 5 {
                
            if startDate.day > now.day {

                // monthOfPayment += 1// ERROR
            } else {
                monthOfPayment += 1
            }
        } else {
                
            print("[D] TESTING 2: getNextPaymentDateSixMonths")
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
            
        } else {
            yearsToAdd = componentYear.year! + 1
            
        }
        
        var result = TimeInterval()
        
        
        let nextPayment = startDate.dateByAdding(yearsToAdd, .year)
        
        if (startDate.day == Date().day) && (startDate.month == Date().month) {
            result = TimeInterval(integerLiteral: 0)
            
        } else {
            result = Date().distance(to: nextPayment.date)
            
        }
        
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
 
