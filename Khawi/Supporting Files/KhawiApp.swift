//
//  KhawiApp.swift
//  Khawi
//
//  Created by Karim Amsha on 19.10.2023.
//

import SwiftUI

import SwiftUI

@main
struct KhawiApp: App {
    @StateObject var languageManager = LanguageManager()
    @StateObject var appState = AppState()
    @StateObject var settings = UserSettings()
    
    init() {
        UserDefaults.standard.set([LanguageManager().currentLanguage.identifier], forKey: "AppleLanguages")
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(languageManager)
                .environment(\.locale, languageManager.currentLanguage)
                .environment(\.layoutDirection, languageManager.isRTL ? .rightToLeft : .leftToRight)
                .environmentObject(appState)
                .environmentObject(settings)
                .preferredColorScheme(.light)
        }
    }
}

//@main
//struct KhawiApp: App {
//
//    @StateObject var languageManager = LanguageManager()
//
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//                .environmentObject(languageManager)
//                .environment(\.locale, AppLanguage.arabic.locale)
////                .environment(\.locale, AppLanguage.arabic.locale)
////                .environmentObject(languageManager)
////                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
////                .environment(\.layoutDirection, languageManager.isRTL ? .rightToLeft : .leftToRight)
//                .preferredColorScheme(.light)
//        }
//    }
//}

class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        configureNotifications(application)
        return true
    }

//    func configureNotifications(_ application:UIApplication){
//        Messaging.messaging().delegate = self
//
//        UNUserNotificationCenter.current().delegate = self
//        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//        UNUserNotificationCenter.current().requestAuthorization(
//            options: authOptions,
//            completionHandler: {(granted, error) in })
//        application.registerForRemoteNotifications()
//    }
}
//
//extension AppDelegate: UNUserNotificationCenterDelegate {
//    //Receive displayed notifications for iOS 10 devices.
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                willPresent notification: UNNotification,
//                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler([.banner, .badge, .sound])
//    }
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                didReceive response: UNNotificationResponse,
//                                withCompletionHandler completionHandler: @escaping () -> Void) {
//
//        if let userInfo = response.notification.request.content.userInfo as? [String: Any] {
//            completionHandler()
//        }
//    }
//}
//
//extension AppDelegate : MessagingDelegate {
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
//                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        completionHandler(UIBackgroundFetchResult.newData)
//    }
//
//    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) { }
//
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        Messaging.messaging().apnsToken = deviceToken
//    }
//
//
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
////        print(fcmToken)
//    }
//
//    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
//
//        if settings.loggedIn {
//            userViewModel.updateUser(settings.uid, [Constant.fcmToken: fcmToken])
//        }
//        Messaging.messaging().isAutoInitEnabled = true
//    }
//}
//
