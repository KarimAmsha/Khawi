//
//  AuthViewModel.swift
//  Khawi
//
//  Created by Karim Amsha on 22.10.2023.
//

import Foundation
import SwiftUI
import Combine
import Alamofire

class AuthViewModel: ObservableObject {
    @Published var user: User?
    @Published var referal: Referal?
    @Published var loggedIn: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorTitle: String = LocalizedStringKey.error
    @Published var errorMessage: String?
    @Published var showErrorPopup: Bool = false
    private var cancellables = Set<AnyCancellable>()
    private let errorHandling: ErrorHandling
    @Published var userSettings = UserSettings.shared

    init(errorHandling: ErrorHandling) {
        self.errorHandling = errorHandling
    }

    func registerUser(params: [String: Any], onsuccess: @escaping (String) -> Void) {
        isLoading = true
        errorMessage = nil
        let endpoint = DataProvider.Endpoint.register(params: params)
        
        DataProvider.shared.request(endpoint: endpoint, responseType: SingleAPIResponse<User>.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    // Use the centralized error handling component
                    self.handleAPIError(error)
                }
            }, receiveValue: { [weak self] (response: SingleAPIResponse<User>) in
                if response.status {
                    self?.user = response.items
                    self?.handleVerificationStatus(isVerified: response.items?.isVerify ?? false)
                    self?.errorMessage = nil
                    if let userId = response.items?._id {
                        onsuccess(userId)
                    } else {
                        onsuccess("") 
                    }
                } else {
                    // Use the centralized error handling component
                    self?.handleAPIError(.customError(message: response.message))
                }
                self?.isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func verify(params: [String: Any], onsuccess: @escaping (Bool, Bool) -> Void) {
        isLoading = true
        errorMessage = nil
        let endpoint = DataProvider.Endpoint.verify(params: params)
        
        DataProvider.shared.request(endpoint: endpoint, responseType: SingleAPIResponse<User>.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    // Use the centralized error handling component
                    self.handleAPIError(error)
                }
            }, receiveValue: { [weak self] (response: SingleAPIResponse<User>) in
                if response.status {
                    self?.user = response.items
                    self?.handleVerificationStatus(isVerified: response.items?.isVerify ?? false)
                    self?.errorMessage = nil
                    let profileCompleted = !(self?.user?.full_name?.isEmpty ?? false)
                    onsuccess(profileCompleted, response.items?.isApprove ?? false)
                } else {
                    // Use the centralized error handling component
                    self?.handleAPIError(.customError(message: response.message))
                }
                self?.isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func resend(params: [String: Any], onsuccess: @escaping () -> Void) {
        isLoading = true
        errorMessage = nil
        let endpoint = DataProvider.Endpoint.resend(params: params)
        
        DataProvider.shared.request(endpoint: endpoint, responseType: SingleAPIResponse<User>.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    // Use the centralized error handling component
                    self.handleAPIError(error)
                }
            }, receiveValue: { [weak self] (response: SingleAPIResponse<User>) in
                if response.status {
                    self?.user = response.items
                    self?.handleVerificationStatus(isVerified: response.items?.isVerify ?? false)
                    self?.errorMessage = nil
                    onsuccess()
                } else {
                    // Use the centralized error handling component
                    self?.handleAPIError(.customError(message: response.message))
                }
                self?.isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func createReferal(onsuccess: @escaping () -> Void) {
        guard let token = userSettings.token else {
            self.handleAPIError(.customError(message: LocalizedStringKey.tokenError))
            return
        }

        isLoading = true
        errorMessage = nil
        let endpoint = DataProvider.Endpoint.createReferal(token: token)
        
        DataProvider.shared.request(endpoint: endpoint, responseType: SingleAPIResponse<Referal>.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    // Use the centralized error handling component
                    self.handleAPIError(error)
                }
            }, receiveValue: { [weak self] (response: SingleAPIResponse<Referal>) in
                if response.status {
                    self?.referal = response.items
                    self?.errorMessage = nil
                    onsuccess()
                } else {
                    // Use the centralized error handling component
                    self?.handleAPIError(.customError(message: response.message))
                }
                self?.isLoading = false
            })
            .store(in: &cancellables)
    }


    func logoutUser(onsuccess: @escaping () -> Void) {
        guard let token = userSettings.token else {
            self.handleAPIError(.customError(message: LocalizedStringKey.tokenError))
            return
        }

        isLoading = true
        errorMessage = nil
        let endpoint = DataProvider.Endpoint.logout(userID: userSettings.id ?? "", token: token)
        
        DataProvider.shared.request(endpoint: endpoint, responseType: SingleAPIResponse<User>.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    // Use the centralized error handling component
                    self.handleAPIError(error)
                }
            }, receiveValue: { [weak self] (response: SingleAPIResponse<User>) in
                if response.status {
                    self?.user = response.items
                    self?.userSettings.logout()
                    self?.errorMessage = nil
                    onsuccess()
                } else {
                    // Use the centralized error handling component
                    self?.handleAPIError(.customError(message: response.message))
                }
                self?.isLoading = false
            })
            .store(in: &cancellables)
    }

    func logout() {
        // Perform the logout operation
//        userSettings.id = 0
//        userSettings.access_token = ""
        // ... Reset other user-related properties ...

//        updateLoginStatus()
    }

    // Other authentication-related functions

    // You can include user profile management functions here as well.
}

extension AuthViewModel {
    private func handleAPIError(_ error: APIClient.APIError) {
        let errorDescription = errorHandling.handleAPIError(error)
        errorMessage = errorDescription
    }
        
    func handleVerificationStatus(isVerified: Bool) {
        guard isVerified, let user = self.user else {
            // User is not verified or user data is nil
            errorMessage = nil
            return
        }

        let isUserVerified = user.isVerify ?? false
        let isUserApproved = user.isApprove ?? false

        if isUserVerified && isUserApproved {
            // User is both verified and approved
            UserSettings.shared.login(user: user, id: user._id ?? "", token: user.token ?? "")
        } else {
            // User is either not verified or not approved
            UserSettings.shared.registerToken(token: user.token ?? "")
        }
    }

}
