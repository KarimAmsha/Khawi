//
//  RoutingView.swift
//  RouterWithNavigationStack
//
//  Created by Ihor Vovk on 07/02/2023.
//

import SwiftUI
import PopupView

struct RoutingView<Content: View>: View {
    
    @StateObject var router: Router
    private let content: Content
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var settings: UserSettings
    
    init(router: Router, @ViewBuilder content: @escaping () -> Content) {
        _router = StateObject(wrappedValue: router)
        self.content = content()
    }
    
    var body: some View {
        NavigationStack(path: router.navigationPath) {
            content
                .navigationDestination(for: ViewSpec.self) { spec in
                    router.view(spec: spec, route: .navigation, appState: appState, settings: settings)
                }
        }.sheet(item: router.presentingSheet) { spec in
            router.view(spec: spec, route: .sheet, appState: appState, settings: settings)
        }.fullScreenCover(item: router.presentingFullScreen) { spec in
            router.view(spec: spec, route: .fullScreenCover, appState: appState, settings: settings)
        }.modal(item: router.presentingModal) { spec in
            router.view(spec: spec, route: .modal, appState: appState, settings: settings)
        }.popup(item: router.presentingToastPopup) { spec in
            router.view(spec: spec, route: .toastPopup, appState: appState, settings: settings)
        } customize: {
            $0
                .type(.toast)
                .position(.bottom)
                .animation(.spring())
                .closeOnTapOutside(true)
                .closeOnTap(false)
                .backgroundColor(Color.black.opacity(0.80))
                .isOpaque(true)
                .useKeyboardSafeArea(true)
        }
    }
}
