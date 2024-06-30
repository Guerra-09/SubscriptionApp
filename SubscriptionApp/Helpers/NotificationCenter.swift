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

// DE MOMENTO: Crea la notificacion de manera mensual de manera correcta.
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
    
    var daysBefore: Int = 0
    
    
    let dateCalculator = DateCalculator()
    
    func createNotification(
        subscriptionName: String,
        reminderTime: String,
        startDate: Date?,
        cycle: String,
        metadata: SubscriptionMetadata) -> () {
            
            
            guard let startDate = startDate else { return }
            
            
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
            
//            let nextPaymentDate: Date
            
            let content = UNMutableNotificationContent()
            content.title = "Geld Reminder: \(subscriptionName)"
            content.subtitle = "Payment is due \(message)"
            content.sound = UNNotificationSound.defaultCritical
            
            if cycle == "monthly" {
                
                let calendar = Calendar.current
                
                let nextPaymentDate = calendar.date(byAdding: .month, value: 1, to: startDate)!
                        
                let reminderDate = calendar.date(byAdding: .day, value: -daysBefore, to: nextPaymentDate)!
                        
                
                var reminderDateComponents = calendar.dateComponents([.day, .hour, .minute], from: reminderDate)
                        
                
//                reminderDateComponents.day! = startDate.day
                // reminderDateComponents.month! += 1
                
                
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
                        
                        
                        metadata.notificationIdentifier = identifier
                    }
                }
                
                
                
            } else {
                
            }
            
            
            
            
            
            
            
            
            
            
            
            
        }
    
    
    func modifyNotification(
        subscriptionName: String,
        reminderTime: String,
        startDate: Date?,
        cycle: String,
        metadata: SubscriptionMetadata) {
            if let identifier = metadata.notificationIdentifier {
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
            }
            
            print("[D] Se borro la notificacion.")
            
            
            createNotification(subscriptionName: subscriptionName, reminderTime: reminderTime, startDate: startDate, cycle: cycle, metadata: metadata)
            
            print("[D] Se modifico la notificacion a la nueva fecha.")
        }
    
    
    
    
    /// BUG: Modifica las horas de notificaciones futuras, es decir que las ya creadas permaneceran con la hora anterior, las que se creen luego de cambiarlo se cambiaran.
    func changeNotificationTime(newHour: Int, newMinute: Int) {
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            
            for request in requests {
                if let trigger = request.trigger as? UNCalendarNotificationTrigger {
                    var newDateComponents = trigger.dateComponents
                    newDateComponents.hour = newHour
                    newDateComponents.minute = newMinute
                    
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
