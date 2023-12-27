//
//  AppState.swift
//  Khawi
//
//  Created by Karim Amsha on 22.10.2023.
//

import SwiftUI
import MapKit

class AppState: ObservableObject {
    @Published var currentPage: Page = .home
    @Published var currentAddSelection: RequestType = .joiningRequest
    @Published var shouldAnimating: Bool = false
    @Published var showingSucessToastStatus: Bool = false
    @Published var showingErrorToastStatus: Bool = false
    @Published var showingLogoutView: Bool = false
    @Published var toastTitle: String = ""
    @Published var toastMessage: String = ""
    @Published var selection = 0
    @Published var selectedOrder: Order?
    @Published var startPoint: Mark?
    @Published var endPoint: Mark?
    @Published var showingDatePicker = false
    @Published var showingTimePicker = false
    @Published var startCoordinate: CLLocationCoordinate2D? = CLLocationCoordinate2D(latitude: 24.1136, longitude: 46.3753)
    @Published var endCoordinate: CLLocationCoordinate2D? = CLLocationCoordinate2D(latitude: 24.7136, longitude: 46.6753)
    @Published var referalUrl: URL?
    @Published var notificationCountString: String?
    

    init() {
        
    }

    func showingActivityIndicator(_ status: Bool) {
        shouldAnimating = status
    }
    
    func showSuccessToast(_ title: String, _ msg: String) {
        shouldAnimating = false
        showingSucessToastStatus = true
        showingErrorToastStatus = false
        toastTitle = ""
        toastMessage = msg
    }
    
    func showErrorToast(_ title: String,_ msg: String) {
        shouldAnimating = false
        showingErrorToastStatus = true
        showingSucessToastStatus = false
        toastTitle = title
        toastMessage = msg
    }

    func cleanToasts() {
        showingSucessToastStatus = false
        showingErrorToastStatus = false
        toastTitle = ""
        toastMessage = ""
    }
    
    func clearMarks() {
        startPoint = nil
        endPoint = nil
    }
}
