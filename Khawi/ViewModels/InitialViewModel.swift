//
//  InitialViewModel.swift
//  Khawi
//
//  Created by Karim Amsha on 6.11.2023.
//

import SwiftUI
import Combine
import Alamofire

class InitialViewModel: ObservableObject {
    @Published var welcomeItems: [WelcomeItem]?
    @Published var constantsItems: [ConstantItem]?
    @Published var constantItem: ConstantItem?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    private var cancellables = Set<AnyCancellable>()
    private let errorHandling: ErrorHandling

    init(errorHandling: ErrorHandling) {
        self.errorHandling = errorHandling
    }

    func fetchWelcomeItems() {
        isLoading = true
        errorMessage = nil
        let endpoint = DataProvider.Endpoint.getWelcome
        
        DataProvider.shared.request(endpoint: endpoint, responseType: ArrayAPIResponse<WelcomeItem>.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    // Use the centralized error handling component
                    self.handleAPIError(error)
                }
            }, receiveValue: { [weak self] (response: ArrayAPIResponse<WelcomeItem>) in
                if response.status {
                    self?.welcomeItems = response.items
                    self?.errorMessage = nil
                } else {
                    // Use the centralized error handling component
                    self?.handleAPIError(.customError(message: response.message))
                }
                self?.isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func fetchConstantsItems() {
        isLoading = true
        errorMessage = nil
        let endpoint = DataProvider.Endpoint.getConstants
        
        DataProvider.shared.request(endpoint: endpoint, responseType: ArrayAPIResponse<ConstantItem>.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    // Use the centralized error handling component
                    self.handleAPIError(error)
                }
            }, receiveValue: { [weak self] (response: ArrayAPIResponse<ConstantItem>) in
                if response.status {
                    self?.constantsItems = response.items
                    self?.errorMessage = nil
                } else {
                    // Use the centralized error handling component
                    self?.handleAPIError(.customError(message: response.message))
                }
                self?.isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func fetchConstantItemDetails(_id: String) {
        isLoading = true
        errorMessage = nil
        let endpoint = DataProvider.Endpoint.getConstantDetails(_id: _id)
        
        DataProvider.shared.request(endpoint: endpoint, responseType: SingleAPIResponse<ConstantItem>.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    // Use the centralized error handling component
                    self.handleAPIError(error)
                }
            }, receiveValue: { [weak self] (response: SingleAPIResponse<ConstantItem>) in
                if response.status {
                    self?.constantItem = response.items
                    self?.errorMessage = nil
                } else {
                    // Use the centralized error handling component
                    self?.handleAPIError(.customError(message: response.message))
                }
                self?.isLoading = false
            })
            .store(in: &cancellables)
    }
}

extension InitialViewModel {
    private func handleAPIError(_ error: APIClient.APIError) {
        let errorDescription = errorHandling.handleAPIError(error)
        errorMessage = errorDescription
    }
}
