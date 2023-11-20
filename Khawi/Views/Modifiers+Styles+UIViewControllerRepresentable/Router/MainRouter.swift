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
    
    func presentAlert(alertModel: AlertModel) {
        presentModal(.alert(alertModel))
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
        case .register:
            RegisterView(router: self)
        case .smsVerification(let id, let mobile):
            SMSVerificationView(id: id, mobile: mobile, router: self)
        case .personalInfo:
            PersonalInfoView(router: self)
        case .list:
            EmptyView()
//            ListView(router: router(route: route))
        case .detail(let description):
            EmptyView()
        case .joiningRequestOrderDetailsView(let orderID):
            JoiningRequestOrderDetailsView(settings: settings, orderID: orderID, router: self)
        case .deliveryRequestOrderDetailsView(let orderID):
            DeliveryRequestDetailsView(settings: settings, orderID: orderID, router: self)
        case .deliveryOfferView(let order):
            DeliveryOfferView(order: order, router: self)
        case .joiningToTripView( let order):
            JoiningToTripView(order: order, router: self)
        case .selectDestination:
            SelectDestinationView(router: self)
        case .alert(let model):
            AlertView(alertModel: model)
        case .toastPopup(let view):
            switch view {
            case .joining(let order):
                JoiningPopupView(settings: settings, order: order, router: self)
            case .delivery(let order):
                DeliveryPopupView(settings: settings, order: order, router: self)
            case .deliverySuccess(let orderID, let message):
                SuccessDeliveryOfferRequestView(orderID: orderID, message: message, router: self)
            case .joiningSuccess(let orderID, let message):
                SuccessJoiningRequestView(orderID: orderID, message: message, router: self)
            case .review(let order):
                ReviewPopupView(order: order, settings: settings, router: self)
            case .error(let title, let message):
                GeneralErrorToastView(title: title, message: message)
            case .createJoiningSuccess(let orderID, let message):
                JoinRequestSuccessView(orderID: orderID, message: message, router: self)
            case .createDeliverySuccess(let orderID, let message):
                DeliveryRequestSuccessView(orderID: orderID, message: message, router: self)
            case .alert(let model):
                AlertView(alertModel: model)
            case .inputAlert(let model):
                InputAlertView(alertModel: model)
            }
        case .editProfile:
            EditProfileView(settings: settings, router: self)
        case .wallet:
            WalletView(settings: settings, router: self)
        case .newJoinRequest:
            NewJoiningRequestView(router: self)
//        case .driverJoinRequestDetails:
//            DeliveryRequestDetailsView(settings: settings, router: self)
        case .showOfferDetails(let order, let offer):
            ShowOfferDetailsView(order: order, offer: offer, settings: settings, router: self)
        case .newDeliveryRequest:
            NewDeliveryRequestView(router: self)
        case .showOnMap(let order, let driverLocation):
            ShowOnMapView(order: order, driverLocation: driverLocation)
        case .showOfferOnMap(let offer):
            ShowOfferOnMapView(offer: offer)
        case .constant(let item):
            ConstantView(item: item)
        case .addComplain:
            AddComplainView(settings: settings, router: self)
//        case .paymentView(let paymentType):
//            PaymentView(configuration: paymentType.configuration, isPresented: .constant(false), handlePaymentSuccess: {})
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
