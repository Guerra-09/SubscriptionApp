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

//Falta hacer que se creen notificaciones cada un mes, 3 meses, etc hasta el infito!!!!!

/// Clase encargada de Crear, Eliminar y modificar notificaciones de subscripciones.
class NotificationCenter: ObservableObject {
    
    @AppStorage("notificationHourString") private var notificationHourString: String = ""
    
    /// Variable para obtener un formato de Horas:Minutos.
    private let dateFormatterTime: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            formatter.timeZone = TimeZone.current
            return formatter
    }()
    
    ///Variable para obtener un formato de dia-mes-año.
    private let dateFormatterDate: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "d-MM-yyyy"
            formatter.timeZone = TimeZone.current
            return formatter
    }()
    
    let dateCalculator = DateCalculator()
    
    
    func createNotification(
        subscriptionName: String,
        reminderTime: String,
        startDate: Date?,
        cycle: String,
        metadata: SubscriptionMetadata) -> () {
            

        guard let startDate = startDate else { return }
            
        let nextPaymentDate: Date
        
        if cycle == "monthly" {
            nextPaymentDate = dateCalculator.getNextPaymentDateMonthly(startDate: startDate)
            
        } else if cycle == "each three months" {
            nextPaymentDate = dateCalculator.getNextPaymentDateThreeMonths(startDate: startDate)
            
        } else {
            nextPaymentDate = Date.now
        }

        print("[D] nextPaymentDate: \(nextPaymentDate)")
        var daysBefore: Int
        
        
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
        
        let reminderDate = dateCalculator.getReminderDate(paymentDate: nextPaymentDate, daysBefore: daysBefore)
        

            
        let content = UNMutableNotificationContent()
        content.title = "Geld Reminder: \(subscriptionName)"
        content.subtitle = "Payment is due \(message)"
        content.sound = UNNotificationSound.defaultCritical
        
        
        // MARK: - PARA PRUEBAS
        var reminderDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminderDate)
        

        
        
        // Hora a la que notificar desde @AppStorage
            if let notificationHourDate = dateFormatterTime.date(from: notificationHourString) {
            let hourComponents = Calendar.current.dateComponents([.hour, .minute], from: notificationHourDate)
            reminderDateComponents.hour = hourComponents.hour
            reminderDateComponents.minute = hourComponents.minute
        } else {
            // Hora predeterminada si no se puede leer de @AppStorage
            reminderDateComponents.hour = 12
            reminderDateComponents.minute = 34
        }
        
        let identifier = UUID().uuidString
        let trigger = UNCalendarNotificationTrigger(dateMatching: reminderDateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
           
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("[D] Error al agregar la solicitud de notificación: \(error.localizedDescription)")
            } else {

                
                
                let formattedDate = self.dateFormatterDate.string(from: Calendar.current.date(from: reminderDateComponents)!)
                print("[D] La solicitud de notificación se agregó correctamente para el \(formattedDate) a las \(self.notificationHourString)")
            
                
                metadata.notificationIdentifier = identifier
            }
        }

        
    }
    

    func modifyNotification(
            subscriptionName: String,
            reminderTime: String,
            startDate: Date?,
            cycle: String,
            metadata: SubscriptionMetadata) {
        
                
        deleteNotification(identifier: metadata.notificationIdentifier)
        
        
        createNotification(subscriptionName: subscriptionName, reminderTime: reminderTime, startDate: startDate, cycle: cycle, metadata: metadata)
        
    }
    
    
    func deleteNotification(identifier: String?) -> () {
        
        if let notificationIdentifier = identifier {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationIdentifier])
        }
        
        print("[D] Se borro la notificacion")
    }
    
    
    func deleteAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        print("Todas las notificaciones pendientes han sido eliminadas.")
    }
    
    
    
    
    func changeNotificationTime() {
        
        // Parsear la nueva hora desde String a Date utilizando dateFormatter
        guard let newTime = dateFormatterTime.date(from: notificationHourString) else {
            return  // Asegúrate de manejar el caso en que no se pueda parsear la hora
        }
        
        print("[D] Entre aqui")
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            for request in requests {
                print("[D] Entre aqui 2")
                
                guard let trigger = request.trigger as? UNCalendarNotificationTrigger else {
                    continue  // Solo nos interesan los disparadores de calendario
                }
                
                // Modificar la hora de la notificación
                var newDateComponents = trigger.dateComponents
                newDateComponents.hour = Calendar.current.component(.hour, from: newTime)
                newDateComponents.minute = Calendar.current.component(.minute, from: newTime)
                
                // Crear un nuevo disparador con la nueva hora
                let newTrigger = UNCalendarNotificationTrigger(dateMatching: newDateComponents, repeats: false)
                
                // Crear una nueva solicitud de notificación con el nuevo disparador
                let newRequest = UNNotificationRequest(identifier: request.identifier, content: request.content, trigger: newTrigger)
                

                
                
                // Actualizar la notificación existente con la nueva solicitud
                UNUserNotificationCenter.current().add(newRequest) { error in
                    if let error = error {
                        print("[D] Error al modificar la notificación: \(error.localizedDescription)")
                    } else {
                        print("[D] Notificación modificada correctamente con nuevo horario: \(self.notificationHourString) id: \(request.identifier)")
                    }
                }
                
                print("[D] Entre aqui 3")
            }
        }
    }

    
}
    


