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
                        WelcomeView()
                            .transition(.scale)
                    )
                }
            } else {
                // Show spalsh view
                SplashView()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    // Change the state of 'isActive' to show home view
                    self.isActive = true
                    settings.myInfo = ["image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQCf88fHpbl1Md8FKJYLsEV_S-fyU9BTzmy69XneVmtWdo9X2CNho7HgKfLjBdw5IY6XvM&usqp=CAU", "name": "أحمد"]
//                    settings.loggedIn = true
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(UserSettings())
}

