//
//  AuthViewModel.swift
//  Khawi
//
//  Created by Karim Amsha on 22.10.2023.
//

import Foundation
import SwiftUI
import Combine

class AuthViewModel: ObservableObject {
    @Published var shouldAnimating: Bool = false
    @Published var monitor = Monitor() // Add monitor property here
    private var cancellables = Set<AnyCancellable>()
    @Published var errorTitle: String = LocalizedStringKey.error
    @Published var errorMessage: String = ""
    @Published var showErrorPopup: Bool = false // Control the popup from the view model

    init() {
        // Inject the network monitor instance
        monitor.$status
            .sink { [weak self] status in
                // Handle network status changes if needed
                if status == .disconnected {
                    self?.handleNetworkDisconnected()
                }
            }
            .store(in: &cancellables)
    }
    
    private func handleNetworkDisconnected() {
        // Handle what should happen when the network is disconnected
        // For example, you can set an error message or take other actions
        self.errorMessage = LocalizedStringKey.noInternetConnection
        self.showErrorPopup = true
    }
    
    private func validView() -> String? {
        guard monitor.status == .connected else {
            return LocalizedStringKey.noInternetConnection
        }
        
        return nil
    }
    
    func login(onsuccess: @escaping () -> Void) {
        onsuccess()
    }
    
    func verify(onsuccess: @escaping () -> Void) {
        onsuccess()
    }
    
    func register(onsuccess: @escaping () -> Void) {
        onsuccess()
    }
}
