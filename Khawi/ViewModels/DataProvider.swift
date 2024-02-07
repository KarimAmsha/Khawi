//
//  DataProvider.swift
//  Khawi
//
//  Created by Karim Amsha on 5.11.2023.
//

import Foundation
import Alamofire
import Combine

class DataProvider {
    static let shared = DataProvider()
    
    private let apiClient = APIClient.shared
    
    enum Endpoint {
        case getWelcome
        case getConstants
        case getConstantDetails(_id: String)
        case register(params: [String: Any])
        case verify(params: [String: Any])
        case resend(params: [String: Any])
        case updateUserDataWithImage(params: [String: Any], imageData: Data?, carFrontImageData: Data?, carBackImageData: Data?, carRightImageData: Data?, carLeftImageData: Data?, carIDImageData: Data?, carLicanseImageData: Data?, token: String)
        case getUserProfile(token: String)
        case logout(userID: String, token: String)
        case addOrder(params: [String: Any], token: String)
        case addOfferToOrder(orderId: String, params: [String: Any], token: String)
        case updateOfferStatus(orderId: String, params: [String: Any], token: String)
        case updateOrderStatus(orderId: String, params: [String: Any], token: String)
        case map(params: [String: Any], token: String)
        case getOrders(status: String?, page: Int?, limit: Int?, token: String)
        case getOrderDetails(orderId: String, token: String)
        case addReview(orderID: String, params: [String: Any], token: String)
        case getNotifications(page: Int?, limit: Int?, token: String)
        case readNotification(token: String)
        case getWallet(page: Int?, limit: Int?, token: String)
        case addBalanceToWallet(params: [String: Any], token: String)
        case addComplain(params: [String: Any], token: String)
        case createReferal(token : String)
        case checkCoupon(params: [String: Any], token: String)
        case notificationCount(token: String)
        case guest
        case deleteAccount(id: String, token: String)

        // Map your custom Endpoint to APIEndpoint
        func toAPIEndpoint() -> APIEndpoint {
            switch self {
            case .getWelcome:
                return .getWelcome
            case .getConstants:
                return .getConstants
            case .getConstantDetails( let _id):
                return .getConstantDetails(_id: _id)
            case .register(let params):
                return .register(params: params)
            case .verify(let params):
                return .verify(params: params)
            case .resend(let params):
                return .resend(params: params)
            case .updateUserDataWithImage(let params, let imageData, let carFrontImageData, let carBackImageData, let carRightImageData, let carLeftImageData, let carIDImageData, let carLicanseImageData, let token):
                return .updateUserDataWithImage(params: params, imageData: imageData, carFrontImageData: carFrontImageData, carBackImageData: carBackImageData, carRightImageData: carRightImageData, carLeftImageData: carLeftImageData, carIDImageData: carIDImageData, carLicanseImageData: carLicanseImageData, token: token)
            case .getUserProfile(let token):
                return .getUserProfile(token: token)
            case .logout(let userID, let token):
                return .logout(userID: userID, token: token)
            case .addOrder(let params, let token):
                return .addOrder(params: params, token: token)
            case .map(let params, let token):
                return .map(params: params, token: token)
            case .addOfferToOrder(let orderId, let params, let token):
                return .addOfferToOrder(orderId: orderId, params: params, token: token)
            case .updateOfferStatus(let orderId, let params, let token):
                return .updateOfferStatus(orderId: orderId, params: params, token: token)
            case .updateOrderStatus(let orderId, let params, let token):
                return .updateOrderStatus(orderId: orderId, params: params, token: token)
            case .getOrders(let status, let page, let limit, let token):
                return .getOrders(status: status, page: page, limit: limit, token: token)
            case .getOrderDetails(let orderId, let token):
                return .getOrderDetails(orderId: orderId, token: token)
            case .addReview(let orderID, let params, let token):
                return .addReview(orderID: orderID, params: params, token: token)
            case .getNotifications(let page, let limit, let token):
                return .getNotifications(page: page, limit: limit, token: token)
            case .readNotification(let token):
                return .readNotification(token: token)
            case .getWallet(let page, let limit, let token):
                return .getWallet(page: page, limit: limit, token: token)
            case .addBalanceToWallet(let params, let token):
                return .addBalanceToWallet(params: params, token: token)
            case .addComplain(let params, let token):
                return .addComplain(params: params, token: token)
            case .createReferal(let token):
                return .createReferal(token: token)
            case .checkCoupon(let params, let token):
                return .checkCoupon(params: params, token: token)
            case .notificationCount(token: let token):
                return .notificationCount(token: token)
            case .guest:
                return .guest
            case .deleteAccount(let id, let token):
                return .deleteAccount(id: id, token: token)
            }
        }
    }
    
    // Use a Combine Publisher for API calls
    func request<T: Decodable>(endpoint: Endpoint, responseType: T.Type) -> AnyPublisher<T, APIClient.APIError> {
        let apiEndpoint = endpoint.toAPIEndpoint()
        return apiClient.requestPublisher(endpoint: apiEndpoint)
    }
    
//    func requestMultipart<T: Decodable>(endpoint: Endpoint, imageFiles: [(Data, String)]?, responseType: T.Type) -> AnyPublisher<T, APIClient.APIError> {
//        let apiEndpoint = endpoint.toAPIEndpoint()
//        return apiClient.requestMultipartPublisher(endpoint: apiEndpoint, imageFiles: imageFiles)
//    }
    
    func requestMultipart<T: Decodable>(endpoint: Endpoint, imageFiles: [(Data, String)]?, responseType: T.Type) -> AnyPublisher<(T, Double), APIClient.APIError> {
        let apiEndpoint = endpoint.toAPIEndpoint()
        return apiClient.requestMultipartPublisherWithProgress(endpoint: apiEndpoint, imageFiles: imageFiles)
    }
}
