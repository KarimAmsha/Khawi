//
//  APIErrorHandling.swift
//  Khawi
//
//  Created by Karim Amsha on 6.11.2023.
//

import Foundation
import Alamofire

class ErrorHandling {
    func handleAPIError(_ error: APIClient.APIError) -> String {
        switch error {
        case .networkError(let afError):
            return handleNetworkError(afError)
        case .badRequest:
            return LocalizedError.badRequest
        case .unauthorized:
            return LocalizedError.unauthorized
        case .invalidData:
            return LocalizedError.invalidData
        case .decodingError(let decodingError):
            return "\(LocalizedError.decodingError): \(decodingError.localizedDescription)"
        case .notFound:
            return LocalizedError.resourceNotFound
        case .serverError:
            return LocalizedError.serverError
        case .customError(message: let message):
            return message
        case .requestError(let afError):
            return handleAlamofireRequestError(afError)
        }
    }

    func handleNetworkError(_ error: AFError) -> String {
        switch error {
        case .sessionTaskFailed(let sessionError as URLError):
            switch sessionError.code {
            case .notConnectedToInternet:
                return LocalizedError.noInternetConnection
            default:
                return LocalizedError.unknownError
            }
        default:
            return LocalizedError.unknownError
        }
    }
    
    private func handleAlamofireRequestError(_ afError: AFError) -> String {
        // You can handle Alamofire-specific errors here
        switch afError {
        case .invalidURL:
            return LocalizedError.invalidURL
        case .responseValidationFailed(reason: let reason):
            return "\(LocalizedError.responseValidationFailed): \(reason)"
        // Handle other Alamofire-specific errors as needed
        default:
            return LocalizedError.unknownError
        }
    }
}
