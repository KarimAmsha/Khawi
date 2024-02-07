//
//  KhawiApp.swift
//  Khawi
//
//  Created by Karim Amsha on 19.10.2023.
//

import SwiftUI
import Firebase
import FirebaseMessaging
import FirebaseCrashlytics
import goSellSDK

@main
struct KhawiApp: App {
    @StateObject var languageManager = LanguageManager()
    @StateObject var appState = AppState()
    @StateObject private var authViewModel = AuthViewModel(errorHandling: ErrorHandling())
    @StateObject private var userViewModel = UserViewModel(errorHandling: ErrorHandling())
    @StateObject private var settings = UserSettings.shared
    @StateObject private var notificationHandler = NotificationHandler()

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
                .environmentObject(notificationHandler)
                .preferredColorScheme(.light)
        }
    }
}

