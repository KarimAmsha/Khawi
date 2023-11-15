//
//  ViewSpec.swift
//  RouterWithNavigationStack
//
//  Created by Ihor Vovk on 07/02/2023.
//

import Foundation
import SwiftUI

enum ViewSpec: Equatable, Hashable {
    static func == (lhs: ViewSpec, rhs: ViewSpec) -> Bool {
        switch (lhs, rhs) {
        case (.register, .register):
            return true
        case let (.smsVerification(lhsID, lhsMobile), .smsVerification(rhsID, rhsMobile)):
            return lhsID == rhsID && lhsMobile == rhsMobile
        case (.personalInfo, .personalInfo):
            return true
        case (.main, .main):
            return true
        case (.list, .list):
            return true
        case let (.detail(lhsDesc), .detail(rhsDesc)):
            return lhsDesc == rhsDesc
        case (.joiningRequestOrderDetailsView, .joiningRequestOrderDetailsView):
            return true
        case (.deliveryRequestOrderDetailsView, .deliveryRequestOrderDetailsView):
            return true
        case (.deliveryOfferView, .deliveryOfferView):
            return true
        case (.joiningToTripView, .joiningToTripView):
            return true
        case (.selectDestination, .selectDestination):
            return true
        case let (.alert(lhsAlert), .alert(rhsAlert)):
            return lhsAlert.message == rhsAlert.message
        case let (.toastPopup(lhsView), .toastPopup(rhsView)):
            return lhsView == rhsView
        case (.editProfile, .editProfile):
            return true
        case (.wallet, .wallet):
            return true
        case (.newJoinRequest, .newJoinRequest):
            return true
        case (.driverJoinRequestDetails, .driverJoinRequestDetails):
            return true
        case (.showOfferDetails, .showOfferDetails):
            return true
        case (.newDeliveryRequest, .newDeliveryRequest):
            return true
        case (.showOnMap, .showOnMap):
            return true
        default:
            return false
        }
    }

    case register
    case smsVerification(String, String)
    case personalInfo
    case main
    case list
    case detail(String)
    case joiningRequestOrderDetailsView(String)
    case deliveryRequestOrderDetailsView(String)
    case deliveryOfferView(Order)
    case joiningToTripView(Order)
    case selectDestination
    case alert(AlertModel)
    case toastPopup(PopupView)
    case editProfile
    case wallet
    case newJoinRequest
    case driverJoinRequestDetails
    case showOfferDetails(Order, Offer)
    case newDeliveryRequest
    case showOnMap(Order)
    case constant(ConstantItem)
    case addBalance
    case paymentView(PaymentType)
    case addComplain
}

extension ViewSpec: Identifiable {
    
    var id: Self { self }
}

