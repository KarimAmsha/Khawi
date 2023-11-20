//
//  ContentView.swift
//  Khawi
//
//  Created by Karim Amsha on 19.10.2023.
//

import SwiftUI
import FirebaseDynamicLinks

struct ContentView: View {
    @State var isActive: Bool = false
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var appState: AppState
    @StateObject private var router = MainRouter(isPresented: .constant(.main))
    @ObservedObject var monitor = Monitor()

    var body: some View {
        VStack {
            if self.isActive {
                if settings.loggedIn {
                    AnyView(
                        withAnimation {
                            MainView(router: router)
                                .transition(.scale)
                        }
                    )
                } else {
                    AnyView(
                        WelcomeView(router: router)
                            .transition(.scale)
                    )
                }
            } else {
                // Show spalsh view
                SplashView()
            }
        }
        .onChange(of: monitor.status) { status in
            if status == .disconnected {
                router.presentToastPopup(view: .error(LocalizedStringKey.error, LocalizedError.noInternetConnection))
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    // Change the state of 'isActive' to show home view
                    self.isActive = true
                }
            }
            
            checkForReferralLink()
        }
        .onOpenURL { url in
            // User 2: Handle dynamic link when the app is opened by a URL
            handleDynamicLink(url)
        }
    }
    
    private func handleDynamicLink(_ url: URL) {
        guard let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) else {
            return
        }

        if let referrerID = dynamicLink.url?.valueOf("referrerID") {
            print("referrerID \(referrerID)")
        }
    }
    
    private func checkForReferralLink() {
        // Check for an existing referral link when the app starts
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let url = windowScene.userActivity?.webpageURL {
            appState.referalUrl = url
            handleDynamicLink(url)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(UserSettings())
        .environmentObject(AppState())
}

