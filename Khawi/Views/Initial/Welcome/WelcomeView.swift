//
//  WelcomeView.swift
//  Khawi
//
//  Created by Karim Amsha on 20.10.2023.
//

import SwiftUI

struct WelcomeView: View {
    @State private var currentPage = 0
    @EnvironmentObject var languageManager: LanguageManager
    @EnvironmentObject var settings: UserSettings
    @StateObject private var router: MainRouter
    @StateObject private var viewModel = InitialViewModel(errorHandling: ErrorHandling())
    @StateObject private var authViewModel = AuthViewModel(errorHandling: ErrorHandling())

    init(router: MainRouter) {
        _router = StateObject(wrappedValue: router)
    }

    var body: some View {
        RoutingView(router: router) {
            VStack {
                if viewModel.isLoading {
                    LoadingView()
                } else if let items = viewModel.welcomeItems {
                    TabView(selection: $currentPage) {
                        ForEach(0..<items.count, id: \.self) { index in
                            WelcomeSlideView(item: items[index])
                                .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                }

                WelcomeControlDots(numberOfPages: viewModel.welcomeItems?.count ?? 0, currentPage: $currentPage)
                    .padding(.top, 20)

                Button(action: {
                    if currentPage < (viewModel.welcomeItems?.count ?? 0) - 1 {
                        currentPage += 1 // Go to the next slide
                    } else if currentPage == (viewModel.welcomeItems?.count ?? 0) - 1 {
                        router.presentViewSpec(viewSpec: .register)
                    }
                }) {
                    Text(currentPage == (viewModel.welcomeItems?.count ?? 0) - 1 ? LocalizedStringKey.createNewAccount : LocalizedStringKey.next)
                }
                .buttonStyle(PrimaryButton(fontSize: 18, fontWeight: .book, background: .primary(), foreground: .white, height: 48, radius: 12))
                .padding(.horizontal, 24)
                .padding(.vertical, 24)
            }
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        authViewModel.guest {
                            settings.loggedIn = true
                        }
                    } label: {
                        Text(LocalizedStringKey.skip)
                    }
                    .buttonStyle(PrimaryButton(fontSize: 14, fontWeight: .bold, background: .primary(), foreground: .white, height: 48, radius: 12))
                }
            }
        }
        .accentColor(.black141F1F())
        .onAppear {
            viewModel.fetchWelcomeItems()
        }
        .onChange(of: authViewModel.errorMessage) { errorMessage in
            if let errorMessage = errorMessage {
                router.presentToastPopup(view: .error("", errorMessage, .error))
            }
        }
        .onChange(of: viewModel.errorMessage) { errorMessage in
            if let errorMessage = errorMessage {
                router.presentToastPopup(view: .error("", errorMessage, .error))
            }
        }
    }
}

#Preview {
    WelcomeView(router: MainRouter(isPresented: .constant(.main)))
        .environmentObject(LanguageManager())
}
