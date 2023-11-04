//
//  MainRouter.swift
//  RouterWithNavigationStack
//
//  Created by Ihor Vovk on 08/02/2023.
//

import SwiftUI

class MainRouter: Router {
    
    func presentList() {
        presentSheet(.list)
    }
    
    func presentDetail(description: String) {
        navigateTo(.detail(description))
    }
    
    func presentViewSpec(viewSpec: ViewSpec) {
        navigateTo(viewSpec)
    }
    
    func presentAlert() {
        presentModal(.alert)
    }
    
    func presentToastPopup(view: PopupView) {
        presentToastPopup(.toastPopup(view))
    }
    
    override func view(spec: ViewSpec, route: Route, appState: AppState, settings: UserSettings) -> AnyView {
        AnyView(buildView(spec: spec, route: route, appState: appState, settings: settings))
    }
}

private extension MainRouter {
    
    @ViewBuilder
    func buildView(spec: ViewSpec, route: Route, appState: AppState, settings: UserSettings) -> some View {
        switch spec {
        case .list:
            EmptyView()
//            ListView(router: router(route: route))
        case .detail(let description):
            EmptyView()
//            DetailView(description: description, router: router(route: route))
        case .joiningRequestOrderDetailsView:
            JoiningRequestOrderDetailsView(settings: settings, router: self)
        case .deliveryRequestOrderDetailsView:
            DeliveryRequestDetailsView(settings: settings, router: self)
        case .deliveryOfferView:
            DeliveryOfferView(router: self)
        case .joiningToTripView:
            JoiningToTripView(router: self)
        case .selectDestination:
            SelectDestinationView(router: self)
        case .alert:
            AlertView(message: .constant("ssss"))
        case .toastPopup(let view):
            switch view {
            case .joining:
                if let trip = appState.selectedTrip {
                    JoiningPopupView(settings: settings, trip: trip, router: self)
                }
            case .delivery:
                if let trip = appState.selectedTrip {
                    DeliveryPopupView(settings: settings, trip: trip, router: self)
                }
            case .deliverySuccess:
                SuccessDeliveryOfferRequestView(router: self)
            case .joiningSuccess:
                SuccessJoiningRequestView(router: self)
            case .review:
                ReviewPopupView(settings: settings, router: self)
            case .error:
                GeneralErrorToastView(title: appState.toastTitle, message: appState.toastMessage)
            case .createJoiningSuccess:
                JoinRequestSuccessView(router: self)
            case .createDeliverySuccess:
                DeliveryRequestSuccessView(router: self)
            }
        case .editProfile:
            EditProfileView(settings: settings, router: self)
        case .wallet:
            WalletView(settings: settings, router: self)
        case .newJoinRequest:
            NewJoiningRequestView(router: self)
        case .driverJoinRequestDetails:
            DriverJoiningRequestDetailsView(settings: settings, router: self)
        case .showJoiningDetails:
            ShowJoiningDetailsView(settings: settings, router: self)
        case .newDeliveryRequest:
            NewDeliveryRequestView(router: self)
        case .showOnMap:
            if let startCoordinate = appState.startCoordinate, let endCoordinate = appState.endCoordinate {
                ShowOnMapView(startCoordinate: .constant(startCoordinate), endCoordinate: .constant(endCoordinate))
            }
        default:
            EmptyView()
        }
    }
            
    func router(route: Route) -> MainRouter {
        switch route {
        case .navigation:
            return self
        case .sheet:
            return MainRouter(isPresented: presentingSheet)
        case .fullScreenCover:
            return MainRouter(isPresented: presentingFullScreen)
        case .modal:
            return self
        case .toastPopup:
            return MainRouter(isPresented: presentingToastPopup)
        }
    }
}
