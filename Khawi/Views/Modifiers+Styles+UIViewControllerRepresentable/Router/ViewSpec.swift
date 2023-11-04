//
//  ViewSpec.swift
//  RouterWithNavigationStack
//
//  Created by Ihor Vovk on 07/02/2023.
//

import Foundation

enum ViewSpec: Equatable, Hashable {

    case main
    case list
    case detail(String)
    case joiningRequestOrderDetailsView
    case deliveryRequestOrderDetailsView
    case deliveryOfferView
    case joiningToTripView
    case selectDestination
    case alert
    case toastPopup(PopupView)
    case editProfile
    case wallet
    case newJoinRequest
    case driverJoinRequestDetails
    case showJoiningDetails
    case newDeliveryRequest
    case showOnMap
}

extension ViewSpec: Identifiable {
    
    var id: Self { self }
}
