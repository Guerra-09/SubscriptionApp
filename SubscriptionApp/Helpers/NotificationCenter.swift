//
//  NotificationCenter.swift
//  SubscriptionApp
//
//  Created by José Guerra on 13-04-24.
//

import Foundation
import SwiftUI
import UserNotifications
import SwiftDate


/// Clase encargada de crear, editar y borrar notificaciones de subscripciones.
///
/// Esta clase es llamada principalmente cuando se quiere gestionar las notificaciones, siempre y cuando el usuario desee activarlas y haya aceptado las notificaciones por parte de la aplicacion.
///
/// - Parameters:
///     - notificationHourString:
///     Este variable se encarga de obtener el horario escogido por el usuario a traves de PreferencesView. Es de tipo `String` (e.g: "09:30")
///
///     - timeFormatter:
///     Encargado de establecer un formato al tiempo de tipo "HH:mm" y un timezone. Usado para horas.
///
///     - dateFormatter:
///     Encargado de establecer un formato de "d-MM-yyyy" y un timezone. Usado para fechas.
///
///
///
///
/// - Experiment: Hay un bug con cambiar el horario de notificacion. Tambien deberia cambiarse el formato de "d-mm-yyyy" a otros desde las preferencias.
///
///
class NotificationCenter: ObservableObject {
    
    @AppStorage("notificationHourString") private var notificationHourString: String = ""
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone.current
        return formatter
    }()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d-MM-yyyy"
        formatter.timeZone = TimeZone.current
        return formatter
    }()
    
    /// Encargado de almacenar los dias antes que tiene que notificar, es decir si la subscripcion tiene seleccionado la notificacion "2 Dias antes", este deberia ser un 2.
    var daysBefore: Int = 0
    
    
    let dateCalculator = DateCalculator()
    
    
    /// Funcion encargada de crear notificaciones.
    ///
    /// Lo que hace esta funcion es crear alertas dentro de las queue de notificaciones del iPhone. Para el caso del pago mensual es muy facil ya que es automatico, sin embargo para notificaciones de 3, 6 y 12 meses hay que ir creando notificaciones de manera manual.
    ///
    /// - Parameters:
    ///     - subcriptionName: Nombre de la subscripcion
    ///     - reminderTime: Cuando recordar, el mismo dia, 1 dia antes, 2 dias antes, etc.
    ///     - startDate: Fecha del primer pago, para calcular el siguiente.
    ///     - cycle: Ciclo de la subcripcion, mensual, trimestral, etc.
    ///     - metadata: Conjunto de variables que definen la personalizacion del logo y ademas tienen el ID de la notificacion (como no esta creado aun esta como un optional).
    ///
    func createNotification(
        subscriptionName: String,
        reminderTime: String,
        startDate: Date?,
        cycle: String,
        metadata: SubscriptionMetadata) -> () {
            
            
            guard let startDate = startDate else { print("[D] Problema con starDate") ; return }
            
            var message = ""
            
            switch reminderTime {
                
            case "The same day":
                daysBefore = 0
                message = "today"
                
            case "One day before":
                daysBefore = 1
                message = "tomorrow"
                
            case "Two days before":
                daysBefore = 2
                message = "in two days"
                
            case "Three days before":
                daysBefore = 3
                message = "in three days"
                
            case "One week before":
                daysBefore = 7
                message = "in one week"
                
            default:
                daysBefore = 0
                message = "ERROR"
            }
            
            let calendar = Calendar.current
            
            let content = UNMutableNotificationContent()
            content.title = "Geld Reminder: \(subscriptionName)"
            content.subtitle = "Payment is due \(message)"
            content.sound = UNNotificationSound.defaultCritical
            
            if cycle == "monthly" {
            
                
                let nextPaymentDate = calendar.date(byAdding: .month, value: 1, to: startDate)!
                        
                let reminderDate = calendar.date(byAdding: .day, value: -daysBefore, to: nextPaymentDate)!
                        
                
                var reminderDateComponents = calendar.dateComponents([.day, .hour, .minute], from: reminderDate)
                
                
                // Hora a la que notificar desde @AppStorage
                if let notificationHourDate = timeFormatter.date(from: notificationHourString) {
                    let hourComponents = Calendar.current.dateComponents([.hour, .minute], from: notificationHourDate)
                    reminderDateComponents.hour = hourComponents.hour
                    reminderDateComponents.minute = hourComponents.minute
                } else {
                    // Hora predeterminada si no se puede leer de @AppStorage
                    reminderDateComponents.hour = 12
                    reminderDateComponents.minute = 34
                }
                
                let identifier = UUID().uuidString
                let trigger = UNCalendarNotificationTrigger(dateMatching: reminderDateComponents, repeats: true)
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request) { error in
                    
                    if let error = error {
                        print("[D] Error al agregar la solicitud de notificación: \(error.localizedDescription)")
                        
                    } else {
                        let formattedDate = self.dateFormatter.string(from: Calendar.current.date(from: reminderDateComponents)!)
                        print("[D] La solicitud de notificación se agregó correctamente para el \(formattedDate) a las \(self.notificationHourString)")
                        
                        
                        print("[D] identifier created = \(identifier)")
                        
                        
                        metadata.notificationIdentifier = identifier
                            
                    }
                    
                }
                
                
                
            } else if cycle == "each three months" {
                print("[D] Cada 3 meses")
                
                // Configurar el número de repeticiones (por ejemplo, para los próximos 3 años)
                    let numberOfRepetitions = 12 // 3 años, una notificación cada tres meses

                    for i in 0..<numberOfRepetitions {
                        // Calcular la fecha del próximo trimestre
                        let nextPaymentDate = calendar.date(byAdding: .month, value: i * 3, to: startDate)!
                        
                        // Restar los días antes a la fecha del próximo pago
                        let reminderDate = calendar.date(byAdding: .day, value: -daysBefore, to: nextPaymentDate)!
                        
                        // Crear componentes de la fecha para el recordatorio
                        var reminderDateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: reminderDate)
                        
                        // Hora a la que notificar desde @AppStorage
                        if let notificationHourDate = timeFormatter.date(from: notificationHourString) {
                            let hourComponents = calendar.dateComponents([.hour, .minute], from: notificationHourDate)
                            reminderDateComponents.hour = hourComponents.hour
                            reminderDateComponents.minute = hourComponents.minute
                        } else {
                            // Hora predeterminada si no se puede leer de @AppStorage
                            reminderDateComponents.hour = 12
                            reminderDateComponents.minute = 34
                        }
                        
                        let identifier = UUID().uuidString
                        // Crear un trigger que no se repite (repeticiones manuales)
                        let trigger = UNCalendarNotificationTrigger(dateMatching: reminderDateComponents, repeats: false)
                        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                        
                        UNUserNotificationCenter.current().add(request) { error in
                            if let error = error {
                                print("[D] Error al agregar la solicitud de notificación: \(error.localizedDescription)")
                            } else {
                                let formattedDate = self.dateFormatter.string(from: calendar.date(from: reminderDateComponents)!)
                                print("[D] La solicitud de notificación se agregó correctamente para el \(formattedDate) a las \(self.notificationHourString)")
                                
                                metadata.notificationIdentifier = identifier
                            }
                        }
                    }
                
                
                
                
            } else if cycle == "each six months" {
                print("[D] Cada 6 meses")
                
                // Configurar el número de repeticiones (por ejemplo, para los próximos 3 años)
                let numberOfRepetitions = 6 // 3 años, una notificación cada seis meses

                var addedRepetitions = 0 // Contador para las notificaciones realmente añadidas
                var monthOffset = 6 // Inicializar con el primer semestre

                while addedRepetitions < numberOfRepetitions {
                    // Calcular la fecha del próximo semestre
                    let nextPaymentDate = calendar.date(byAdding: .month, value: monthOffset, to: startDate)!
                    
                    // Restar los días antes a la fecha del próximo pago
                    let reminderDate = calendar.date(byAdding: .day, value: -daysBefore, to: nextPaymentDate)!
                    
                    // Verificar que la fecha de recordatorio no sea en el pasado
                    if reminderDate > Date() {
                        // Crear componentes de la fecha para el recordatorio
                        var reminderDateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: reminderDate)
                        
                        // Hora a la que notificar desde @AppStorage
                        if let notificationHourDate = timeFormatter.date(from: notificationHourString) {
                            let hourComponents = calendar.dateComponents([.hour, .minute], from: notificationHourDate)
                            reminderDateComponents.hour = hourComponents.hour
                            reminderDateComponents.minute = hourComponents.minute
                        } else {
                            // Hora predeterminada si no se puede leer de @AppStorage
                            reminderDateComponents.hour = 12
                            reminderDateComponents.minute = 34
                        }
                        
                        let identifier = UUID().uuidString
                        // Crear un trigger que no se repite (repeticiones manuales)
                        let trigger = UNCalendarNotificationTrigger(dateMatching: reminderDateComponents, repeats: false)
                        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                        
                        UNUserNotificationCenter.current().add(request) { error in
                            if let error = error {
                                print("[D] Error al agregar la solicitud de notificación: \(error.localizedDescription)")
                            } else {
                                let formattedDate = self.dateFormatter.string(from: calendar.date(from: reminderDateComponents)!)
                                print("[D] La solicitud de notificación se agregó correctamente para el \(formattedDate) a las \(self.notificationHourString)")
                                
                                metadata.notificationIdentifier = identifier
                            }
                        }
                        addedRepetitions += 1
                    }
                    monthOffset += 6 // Incrementar el semestre
                }
            } else if cycle == "yearly" {
                
                print("[D] Cada año")
                
                // Configurar el número de repeticiones (por ejemplo, para los próximos 10 años)
                let numberOfRepetitions = 3 // 10 años, una notificación cada año

                var addedRepetitions = 0 // Contador para las notificaciones realmente añadidas
                var yearOffset = 1 // Inicializar con el primer año

                while addedRepetitions < numberOfRepetitions {
                    // Calcular la fecha del próximo año
                    let nextPaymentDate = calendar.date(byAdding: .year, value: yearOffset, to: startDate)!
                    
                    // Restar los días antes a la fecha del próximo pago
                    let reminderDate = calendar.date(byAdding: .day, value: -daysBefore, to: nextPaymentDate)!
                    
                    // Verificar que la fecha de recordatorio no sea en el pasado
                    if reminderDate > Date() {
                        // Crear componentes de la fecha para el recordatorio
                        var reminderDateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: reminderDate)
                        
                        // Hora a la que notificar desde @AppStorage
                        if let notificationHourDate = timeFormatter.date(from: notificationHourString) {
                            let hourComponents = calendar.dateComponents([.hour, .minute], from: notificationHourDate)
                            reminderDateComponents.hour = hourComponents.hour
                            reminderDateComponents.minute = hourComponents.minute
                        } else {
                            // Hora predeterminada si no se puede leer de @AppStorage
                            reminderDateComponents.hour = 12
                            reminderDateComponents.minute = 34
                        }
                        
                        let identifier = UUID().uuidString
                        // Crear un trigger que no se repite (repeticiones manuales)
                        let trigger = UNCalendarNotificationTrigger(dateMatching: reminderDateComponents, repeats: false)
                        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                        
                        UNUserNotificationCenter.current().add(request) { error in
                            if let error = error {
                                print("[D] Error al agregar la solicitud de notificación: \(error.localizedDescription)")
                            } else {
                                let formattedDate = self.dateFormatter.string(from: calendar.date(from: reminderDateComponents)!)
                                print("[D] La solicitud de notificación se agregó correctamente para el \(formattedDate) a las \(self.notificationHourString)")
                                
                                metadata.notificationIdentifier = identifier
                            }
                        }
                        addedRepetitions += 1
                    }
                    yearOffset += 1 // Incrementar el año
                }
                
            } else {
                print("[D] cycle ELSE")
            }
        }
    
    
    func modifyNotification(
        subscriptionName: String,
        reminderTime: String,
        startDate: Date?,
        cycle: String,
        metadata: SubscriptionMetadata) {
            
           
            
            if let identifier = metadata.notificationIdentifier {
                
                print("[D] identifier: \(identifier)")

                
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
                
                createNotification(subscriptionName: subscriptionName, reminderTime: reminderTime, startDate: startDate, cycle: cycle, metadata: metadata)
                
                print("[D] Se modifico la notificacion a la nueva fecha. :D")
                
                
                
            } else {
                print("[D1] Error deleting notification \(metadata.notificationIdentifier)")
            }
            
            
            
        }
    
    
    
    func changeNotificationTime(newHour: Int, newMinute: Int) {
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            
            for request in requests {
                if let trigger = request.trigger as? UNCalendarNotificationTrigger {
                    var newDateComponents = trigger.dateComponents
                    newDateComponents.hour = newHour
                    newDateComponents.minute = newMinute
                    
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [request.identifier])
                    
                    let newTrigger = UNCalendarNotificationTrigger(dateMatching: newDateComponents, repeats: false)
                    let newRequest = UNNotificationRequest(identifier: request.identifier, content: request.content, trigger: newTrigger)
                    
                    UNUserNotificationCenter.current().add(newRequest) { error in
                        if let error = error {
                            print("[D] Error al modificar la notificación: \(error.localizedDescription)")
                        } else {
                            print("[D] Notificación modificada correctamente con nuevo horario: \(newHour):\(newMinute)")
                        }
                    }
                }
            }
        }
    }
    
    
    
    
    
    func deleteAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        print("Todas las notificaciones pendientes han sido eliminadas.")
    }
    
}
