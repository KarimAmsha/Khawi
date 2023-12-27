//
//  NotificationHandler.swift
//  Khawi
//
//  Created by Karim Amsha on 15.11.2023.
//

import UserNotifications
import SwiftUI

class NotificationHandler: ObservableObject {
    static let shared = NotificationHandler()

    @Published var orderID: String?
    @Published var coupunID: String?
    @Published var notificationType: NOTIFICATION_TYPE?
    @Published var orderNotificationReceived = false
    static let orderNotificationUpdateNotification = Notification.Name("OrderNotificationUpdate")

    init() {
        // Set up observers for handling different types of notifications
        NotificationCenter.default.addObserver(self, selector: #selector(handleOrderNotification(_:)), name: NotificationHandler.orderNotificationUpdateNotification, object: nil)
        // Add other observers as needed
    }

    func registerForRemoteNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }

    func handleRemoteNotification(userInfo: [AnyHashable: Any]) {
        NotificationCenter.default.post(name: NotificationHandler.orderNotificationUpdateNotification, object: nil)
    }

    private func handleOrderNotification(data: String) {
        DispatchQueue.main.async {
            self.orderID = data
            self.notificationType = .ORDERS
            // Notify observers about the order notification
        }
        print("Handling orders notification with data: \(data)")
    }

    private func handleCouponNotification(data: String) {
        DispatchQueue.main.async {
            self.coupunID = data
            self.notificationType = .COUPON
        }
        print("Handling coupon notification with data: \(data)")
    }

    private func handleGeneralNotification(data: String) {
        DispatchQueue.main.async {
            self.notificationType = .GENERAL
        }
        print("Handling general notification with data: \(data)")
    }
    
    @objc private func handleOrderNotification(_ notification: Notification) {
        // This method gets called when an order notification is received
        print("Order notification received!")
    }
}
