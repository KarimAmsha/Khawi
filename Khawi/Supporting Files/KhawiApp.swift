//
//  KhawiApp.swift
//  Khawi
//
//  Created by Karim Amsha on 19.10.2023.
//

import SwiftUI
import Firebase
import FirebaseMessaging

@main
struct KhawiApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var languageManager = LanguageManager()
    @StateObject var appState = AppState()
    @StateObject private var authViewModel = AuthViewModel(errorHandling: ErrorHandling())
    @StateObject private var userViewModel = UserViewModel(errorHandling: ErrorHandling())
    @StateObject private var settings = UserSettings.shared

    init() {
        UserDefaults.standard.set([languageManager.currentLanguage.identifier], forKey: "AppleLanguages")
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(languageManager)
                .environment(\.locale, languageManager.currentLanguage)
                .environment(\.layoutDirection, languageManager.isRTL ? .rightToLeft : .leftToRight)
                .environmentObject(appState)
                .environmentObject(authViewModel)
                .environmentObject(settings)
                .preferredColorScheme(.light)
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureNotifications(application)
        return true
    }

    func configureNotifications(_ application:UIApplication){
        Messaging.messaging().delegate = self

        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {(granted, error) in })
        application.registerForRemoteNotifications()
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    //Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .badge, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {

        if let userInfo = response.notification.request.content.userInfo as? [String: Any] {
            print("userInfo \(userInfo)")

            if let notificationTypeRawValue = userInfo["notificationType"] as? Int,
               let notificationType = NOTIFICATION_TYPE(rawValue: notificationTypeRawValue) {

                switch notificationType {
                case .ORDERS:
                    // Handle orders notification
                    handleOrdersNotification(userInfo)
                case .COUPON:
                    // Handle coupon notification
                    handleCouponNotification(userInfo)
                case .GENERAL:
                    // Handle general notification
                    handleGeneralNotification(userInfo)
                }
            }
            
            completionHandler()
        }
    }
    
    func handleOrdersNotification(_ userInfo: [AnyHashable: Any]) {
        print("userInfo \(userInfo)")
        // Extract relevant information from userInfo and take appropriate action
    }

    func handleCouponNotification(_ userInfo: [AnyHashable: Any]) {
        // Extract relevant information from userInfo and take appropriate action
    }

    func handleGeneralNotification(_ userInfo: [AnyHashable: Any]) {
        // Extract relevant information from userInfo and take appropriate action
    }
}

extension AppDelegate : MessagingDelegate {
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("userInfo2 \(userInfo)")

        if let notificationTypeRawValue = userInfo["notificationType"] as? Int,
           let notificationType = NOTIFICATION_TYPE(rawValue: notificationTypeRawValue) {

            switch notificationType {
            case .ORDERS:
                // Handle orders notification
                handleOrdersNotification(userInfo)
            case .COUPON:
                // Handle coupon notification
                handleCouponNotification(userInfo)
            case .GENERAL:
                // Handle general notification
                handleGeneralNotification(userInfo)
            }

            completionHandler(UIBackgroundFetchResult.newData)
        } else {
            completionHandler(UIBackgroundFetchResult.noData)
        }
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) { }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }


    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//        print(fcmToken)
    }

    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        Messaging.messaging().isAutoInitEnabled = true
    }
}

