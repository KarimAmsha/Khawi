//
//  MainView.swift
//  Khawi
//
//  Created by Karim Amsha on 23.10.2023.
//

import SwiftUI
import PopupView

struct MainView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var settings: UserSettings
    @State var showPopUp = false
    @StateObject private var router: MainRouter
    
    init(router: MainRouter) {
        _router = StateObject(wrappedValue: router)
    }

    var body: some View {
        RoutingView(router: router) {
            ZStack {
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(.clear)
                    .background(showPopUp ? Color.black.opacity(0.2) : .white)

                GeometryReader { geometry in
                    VStack(spacing: 0) {
                        Spacer()
                        switch appState.currentPage {
                        case .home:
                            HomeView(showPopUp: $showPopUp, router: router)
                        case .orders:
                            OrdersView()
                        case .notifications:
                            NotificationsView()
                        case .settings:
                            SettingsView(settings: settings, router: router)
                        }
                        
                        ZStack {
                            if showPopUp {
                                PlusMenu(widthAndHeight: 47, appState: appState, showPopUp: $showPopUp, onJoiningRequest: {
                                    router.presentViewSpec(viewSpec: .newJoinRequest)
                                }, onDeliveryRequest: {
                                    router.presentViewSpec(viewSpec: .newDeliveryRequest)
                                })
                                .offset(y: -geometry.size.height/6)
                            }

                            VStack {
                                HStack {
                                    TabBarIcon(appState: appState, assignedPage: .home, width: geometry.size.width/5, height: geometry.size.height/38, iconName: "ic_home", tabName: LocalizedStringKey.home, isAddButton: false)
                                    TabBarIcon(appState: appState, assignedPage: .orders, width: geometry.size.width/5, height: geometry.size.height/38, iconName: "ic_orders", tabName: LocalizedStringKey.orders, isAddButton: false)

                                    Spacer()
                                    MiddleButtonView(showPopUp: $showPopUp)
                                        .offset(y: -40)
                                        .zIndex(1)
                                    Spacer()

                                    TabBarIcon(appState: appState, assignedPage: .notifications, width: geometry.size.width/5, height: geometry.size.height/38, iconName: "ic_bells", tabName: LocalizedStringKey.notifications, isAddButton: false)
                                    TabBarIcon(appState: appState, assignedPage: .settings, width: geometry.size.width/5, height: geometry.size.height/38, iconName: "ic_settings", tabName: LocalizedStringKey.settings, isAddButton: false)
                                }
                                .frame(width: geometry.size.width, height: geometry.size.height/8)
                            }
                            .background(
                                Rectangle()
                                    .foregroundColor(showPopUp ? .clear : .white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: geometry.size.height/8)
                                    .cornerRadius(16)
                                    .shadow(color: .black.opacity(0.06), radius: 2, x: 0, y: -2)
                            )
                        }                    }
                }
                .edgesIgnoringSafeArea(.bottom)
            }
            .toolbarColorScheme(.light, for: .navigationBar)
            .toolbarBackground(Color.white,for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
        }
        .accentColor(.black)
    }
}

#Preview {
    MainView(router: MainRouter(isPresented: .constant(.main)))
        .environmentObject(UserSettings())
}
