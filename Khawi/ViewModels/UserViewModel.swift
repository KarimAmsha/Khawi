//
//  UserViewModel.swift
//  Khawi
//
//  Created by Karim Amsha on 5.11.2023.
//

import SwiftUI
import Combine

class UserViewModel: ObservableObject {
    @Published var user: User?
    private var cancellables = Set<AnyCancellable>()
    @Published var errorTitle: String = LocalizedStringKey.error
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    private let errorHandling: ErrorHandling
    private let dataProvider = DataProvider.shared
    @Published var uploadProgress: Double? // Use an optional Double
    @Published var userSettings = UserSettings.shared // Use the shared instance of UserSettings

    init(errorHandling: ErrorHandling) {
        self.errorHandling = errorHandling
    }
    
    func updateUploadProgress(newProgress: Double) {
        uploadProgress = newProgress
    }
    
    func startUpload() {
        isLoading = true
    }

    func finishUpload() {
        isLoading = false
    }

    func updateUserDataWithImage(imageData: Data?, carFrontImageData: Data?, carBackImageData: Data?, carRightImageData: Data?, carLeftImageData: Data?, carIDImageData: Data?, carLicenseImageData: Data?, additionalParams: [String: Any], onsuccess: @escaping (Bool, String) -> Void) {
        guard let token = userSettings.token else {
            self.handleAPIError(.customError(message: LocalizedStringKey.tokenError))
            return
        }
        
        self.updateUploadProgress(newProgress: 0)
        startUpload()

        let imageFiles = [
            (imageData, "image"),
            (carFrontImageData, "carFrontImage"),
            (carBackImageData, "carBackImage"),
            (carRightImageData, "carRightImage"),
            (carLeftImageData, "carLeftImage"),
            (carIDImageData, "identityImage"),
            (carLicenseImageData, "licenseImage")
        ].compactMap { (data, fieldName) in
            data.map { ($0, fieldName) } // Unwrap optional Data and create tuple
        }

        let endpoint: DataProvider.Endpoint = .updateUserDataWithImage(
            params: additionalParams,
            imageData: imageData,
            carFrontImageData: carFrontImageData,
            carBackImageData: carBackImageData,
            carRightImageData: carRightImageData,
            carLeftImageData: carLeftImageData,
            carIDImageData: carIDImageData,
            carLicanseImageData: carLicenseImageData,
            token: token
        )

        dataProvider.requestMultipart(endpoint: endpoint, imageFiles: imageFiles, responseType: SingleAPIResponse<User>.self)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.updateUploadProgress(newProgress: 1.0) // Set progress to 100% when the upload is complete
                    self?.finishUpload()
                case .failure(let error):
                    // Handle the error
                    self?.handleAPIError(error)
                    self?.finishUpload()
                }
            }, receiveValue: { (response, uploadProgress) in
                if response.status {
                    // Handle the successful response, if needed
                    self.updateUploadProgress(newProgress: uploadProgress) // The upload progress (0.0 to 1.0)
                    self.user = response.items // The user object
                    self.handleVerificationStatus(isVerified: response.items?.isVerify ?? false, isApprove: response.items?.isApprove ?? false)
                    self.handleUserData()
                    self.errorMessage = nil
                    onsuccess((self.user?.hasCar ?? false) ? true : false, (self.user?.hasCar ?? false) ? response.message : "")
                } else {
                    // Use the centralized error handling component
                    self.handleAPIError(.customError(message: response.message))
                }

            })
            .store(in: &cancellables)
    }

//    func updateUserDataWithImage2(hasCar: Bool, imageData: Data?, carFrontImageData: Data?, carBackImageData: Data?, carRightImageData: Data?, carLeftImageData: Data?, carIDImageData: Data?, carLicanseImageData: Data?, additionalParams: [String: Any], onsuccess: @escaping () -> Void) {
//        guard let token = userSettings.token else {
//            self.handleAPIError(.customError(message: LocalizedStringKey.tokenError))
//            return
//        }
//        
//        self.updateUploadProgress(newProgress: 0) // Initialize the progress to 0%
//        startUpload()
//
//        var endpoint: DataProvider.Endpoint
//        var imageFiles: [(Data, String)] = []
//        if let imageData = imageData {
//            if hasCar, let carFrontImageData = carFrontImageData, let carBackImageData = carBackImageData, let carRightImageData = carRightImageData, let carLeftImageData = carLeftImageData, let carIDImageData = carIDImageData, let carLicanseImageData = carLicanseImageData {
//                endpoint = .updateUserDataWithImage(params: additionalParams, imageData: nil, carFrontImageData: carFrontImageData, carBackImageData: carBackImageData, carRightImageData: carRightImageData, carLeftImageData: carLeftImageData, carIDImageData: carIDImageData, carLicanseImageData: carLicanseImageData, token: token)
//                imageFiles.append((imageData, "image"))
//                imageFiles.append((carFrontImageData, "carFrontImage"))
//                imageFiles.append((carBackImageData, "carBackImage"))
//                imageFiles.append((carRightImageData, "carRightImage"))
//                imageFiles.append((carLeftImageData, "carLeftImage"))
//                imageFiles.append((carIDImageData, "identityImage"))
//                imageFiles.append((carLicanseImageData, "licenseImage"))
//            } else {
//                endpoint = .updateUserDataWithImage(params: additionalParams, imageData: imageData, carFrontImageData: nil, carBackImageData: nil, carRightImageData: nil, carLeftImageData: nil, carIDImageData: nil, carLicanseImageData: nil, token: token)
//                imageFiles.append((imageData, "image"))
//            }
//        } else {
//            // In this case, you still want to send a request with additionalParams
//            if hasCar, let carFrontImageData = carFrontImageData, let carBackImageData = carBackImageData, let carRightImageData = carRightImageData, let carLeftImageData = carLeftImageData, let carIDImageData = carIDImageData, let carLicanseImageData = carLicanseImageData {
//                imageFiles.append((carFrontImageData, "carFrontImage"))
//                imageFiles.append((carBackImageData, "carBackImage"))
//                imageFiles.append((carRightImageData, "carRightImage"))
//                imageFiles.append((carLeftImageData, "carLeftImage"))
//                imageFiles.append((carIDImageData, "identityImage"))
//                imageFiles.append((carLicanseImageData, "licenseImage"))
//            } else {
//                endpoint = .updateUserDataWithImage(params: additionalParams, imageData: nil, carFrontImageData: nil, carBackImageData: nil, carRightImageData: nil, carLeftImageData: nil, carIDImageData: nil, carLicanseImageData: nil, token: token)
//            }
//        }
//        
//        dataProvider.requestMultipart(endpoint: endpoint, imageFiles: imageFiles, responseType: SingleAPIResponse<User>.self)
//            .sink(receiveCompletion: { [weak self] completion in
//                switch completion {
//                case .finished:
//                    self?.updateUploadProgress(newProgress: 1.0) // Set progress to 100% when the upload is complete
//                    self?.finishUpload()
//                case .failure(let error):
//                    // Handle the error
//                    self?.handleAPIError(error)
//                    self?.finishUpload()
//                }
//            }, receiveValue: { (response, uploadProgress) in
//                if response.status {
//                    // Handle the successful response, if needed
//                    self.updateUploadProgress(newProgress: uploadProgress) // The upload progress (0.0 to 1.0)
//                    self.user = response.items // The user object
//                    self.handleUserData()
//                    self.errorMessage = nil
//                    onsuccess()
//                } else {
//                    // Use the centralized error handling component
//                    self.handleAPIError(.customError(message: response.message))
//                }
//
//            })
//            .store(in: &cancellables)
//    }
    
    func fetchUserData(onsuccess: @escaping () -> Void) {
        guard let token = userSettings.token else {
            self.handleAPIError(.customError(message: LocalizedStringKey.tokenError))
            return
        }

        isLoading = true
        errorMessage = nil
        let endpoint = DataProvider.Endpoint.getUserProfile(token: token)
        
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
    
    func addReview(orderID: String, params: [String: Any], onsuccess: @escaping (String) -> Void) {
        guard let token = userSettings.token else {
            self.handleAPIError(.customError(message: LocalizedStringKey.tokenError))
            return
        }

        isLoading = true
        errorMessage = nil
        let endpoint = DataProvider.Endpoint.addReview(orderID: orderID, params: params, token: token)
        
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
                    self?.errorMessage = nil
                    onsuccess(response.message)
                } else {
                    // Use the centralized error handling component
                    self?.handleAPIError(.customError(message: response.message))
                }
                self?.isLoading = false
            })
            .store(in: &cancellables)
    }    
    
    func addComplain(params: [String: Any], onsuccess: @escaping (String) -> Void) {
        guard let token = userSettings.token else {
            self.handleAPIError(.customError(message: LocalizedStringKey.tokenError))
            return
        }

        isLoading = true
        errorMessage = nil
        let endpoint = DataProvider.Endpoint.addComplain(params: params, token: token)
        
        DataProvider.shared.request(endpoint: endpoint, responseType: SingleAPIResponse<Complain>.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    // Use the centralized error handling component
                    self.handleAPIError(error)
                }
            }, receiveValue: { [weak self] (response: SingleAPIResponse<Complain>) in
                if response.status {
                    self?.errorMessage = nil
                    onsuccess(response.message)
                } else {
                    // Use the centralized error handling component
                    self?.handleAPIError(.customError(message: response.message))
                }
                self?.isLoading = false
            })
            .store(in: &cancellables)
    }
}

extension UserViewModel {
    private func handleAPIError(_ error: APIClient.APIError) {
        let errorDescription = errorHandling.handleAPIError(error)
        errorMessage = errorDescription
    }
    
    func handleUserData() {
        if let user = self.user, let isApprove = user.isApprove, isApprove {
            UserSettings.shared.login(user: user, id: user._id ?? "", token: user.token ?? "")
        }
    }
    
    func handleVerificationStatus(isVerified: Bool, isApprove: Bool) {
        if isVerified && isApprove {
            // User is verified
            if let user = self.user {
                UserSettings.shared.login(user: user, id: user._id ?? "", token: user.token ?? "")
            }
        } else {
            // User is not verified
            errorMessage = nil
        }
    }
}

extension UserViewModel {
    func updateUserLocation(location: FBUserLocation) {
        guard let id = userSettings.id else {
            return
        }

        Constants.userLocationRef.child(id).updateChildValues(location.toDictionary()) { (error, reference) in
            if let error = error {
                self.handleAPIError(.customError(message: error.localizedDescription))
            }
        }
    }
    
    func trackingUserLocation(item: Tracking) {
        Constants.trackingRef.child(item.orderId ?? "").updateChildValues(item.toDictionary()) { (error, reference) in
            if let error = error {
                self.handleAPIError(.customError(message: error.localizedDescription))
            }
        }
    }

    func deleteUserLocation(id: String) {
        Constants.trackingRef.child(id).removeValue { (error, reference) in
            if let error = error {
                self.handleAPIError(.customError(message: error.localizedDescription))
            }
        }
    }
    
    func observeDriverLocation(orderID: String, completion: @escaping (Tracking) -> Void) {
        Constants.trackingRef.child(orderID).observe(.value) { snapshot in
            guard snapshot.exists() else {
                // Handle case when the snapshot does not exist (location not found, etc.)
                return
            }

            let tracking = Tracking(snapshot)
            completion(tracking)
        }
    }
}
