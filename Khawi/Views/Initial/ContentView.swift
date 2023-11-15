//
//  ContentView.swift
//  Khawi
//
//  Created by Karim Amsha on 19.10.2023.
//

import SwiftUI

struct ContentView: View {
    @State var isActive: Bool = false
    @EnvironmentObject var settings: UserSettings
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
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(UserSettings())
}

