//
//  APIEndpoint.swift
//  Khawi
//
//  Created by Karim Amsha on 5.11.2023.
//

import Foundation
import Alamofire

// Function to get the user's preferred language code
func getUserPreferredLanguageCode() -> String? {
    return Locale.preferredLanguages.first?.components(separatedBy: "-").first
}

enum APIEndpoint {
    case getWelcome
    case getConstants
    case getConstantDetails(_id: String)
    case register(params: [String: Any])
    case verify(params: [String: Any])
    case resend(params: [String: Any])
    case updateUserDataWithImage(params: [String: Any], token: String)
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
    case createReferal(token: String)
    case checkCoupon(params: [String: Any], token: String)
    case notificationCount(token: String)
    case guest
    case deleteAccount(id: String, token: String)

    // Define the base API URL
    private static let baseURL = Constants.baseURL
    
    // Computed property to get the full URL for each endpoint
    var fullURL: String {
        return APIEndpoint.baseURL + path
    }

    var path: String {
        switch self {
        case .getWelcome:
            return "/mobile/constant/welcome"
        case .getConstants:
            return "/mobile/constant/static"
        case .getConstantDetails(let _id):
            return "/mobile/constant/static/\(_id)"
        case .register:
            return "/mobile/user/create_login"
        case .verify:
            return "/mobile/user/verify"
        case .resend:
            return "/mobile/user/resend"
        case .updateUserDataWithImage:
            return "/mobile/user/update-profile"
        case .getUserProfile:
            return "/mobile/user/get-user"
        case .logout(let userID, _):
            return "/mobile/user/logout/\(userID)"
        case .addOrder:
            return "/mobile/order/add"
        case .addOfferToOrder(orderId: let orderId, _ , _):
            return "/mobile/order/offer/\(orderId)"
        case .updateOfferStatus(orderId: let orderId, _, _):
            return "/mobile/order/offer/update/\(orderId)"
        case .updateOrderStatus(orderId: let orderId, _, _):
            return "/mobile/order/update/\(orderId)"
        case .map(let params, _):
            if !params.isEmpty {
                var url = "/mobile/order/map?"
                url += params.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
                return url
            } else {
                return "/mobile/order/map"
            }
        case .getOrders(status: let status, page: let page, limit: let limit, _):
            var params: [String: Any] = [:]

            if let status = status {
                params["status"] = status

            }
            if let page = page {
                params["page"] = page

            }
            if let limit = limit {
                params["limit"] = limit
            }

            if !params.isEmpty {
                var url = "/mobile/order/list?"
                url += params.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
                return url
            } else {
                return "/mobile/order/list"
            }
        case .getOrderDetails(orderId: let orderId, _):
            return "/mobile/order/single/\(orderId)"
        case .addReview(orderID: let orderID, _, _):
            return "/mobile/order/rate/\(orderID)"
        case .getNotifications(page: let page, limit: let limit, _):
            var params: [String: Any] = [:]

            if let page = page {
                params["page"] = page

            }
            if let limit = limit {
                params["limit"] = limit
            }

            if !params.isEmpty {
                var url = "/mobile/notification/get?"
                url += params.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
                return url
            } else {
                return "/mobile/notification/get"
            }
        case .readNotification:
            return "/mobile/notification/delete"
        case .getWallet(page: let page, limit: let limit, _):
            var params: [String: Any] = [:]

            if let page = page {
                params["page"] = page
            }
            if let limit = limit {
                params["limit"] = limit
            }

            if !params.isEmpty {
                var url = "/mobile/transaction/list?"
                url += params.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
                return url
            } else {
                return "/mobile/transaction/list"
            }
        case .addBalanceToWallet:
            return "/mobile/user/wallet"
        case .addComplain:
            return "/mobile/constant/add-complain"
        case .createReferal:
            return "/mobile/user/referal"
        case .checkCoupon:
            return "/mobile/check/coupon"
        case .notificationCount:
            return "/mobile/notification/count"
        case .guest:
            return "/mobile/guest/token"
        case .deleteAccount(let id, _):
            return "/mobile/user/delete/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getWelcome, .getConstants, .getUserProfile, .getConstantDetails, .map, .getOrders, .getOrderDetails, 
                .getNotifications, .getWallet, .notificationCount, .guest:
            return .get
        case .register, .verify, .resend, .updateUserDataWithImage, .logout, .addOrder, .addOfferToOrder, .updateOfferStatus, .updateOrderStatus, .addReview, .readNotification, .addBalanceToWallet, .addComplain, .createReferal, .checkCoupon, .deleteAccount:
            return .post
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .getWelcome, .getConstants, .getConstantDetails, .register, .verify, .resend, .guest:
            var headers = HTTPHeaders()
            headers.add(name: "Accept-Language", value: getUserPreferredLanguageCode() ?? "ar")
            return headers
        case .getUserProfile(let token), .updateUserDataWithImage(_, let token), .logout(_, let token), .addOrder(_, let token), .map(_, let token), .addOfferToOrder(_, _, let token), .updateOfferStatus(_, _, let token), .updateOrderStatus(_, _, let token), .getOrders(_, _, _, token: let token), .getOrderDetails(_, let token), .addReview(_, _, let token), .getNotifications(_, _, let token), .readNotification(let token), .getWallet(_, _, let token), .addBalanceToWallet(_, let token), .addComplain(_ , let token), .createReferal(let token), .checkCoupon(_, let token), .notificationCount(let token), .deleteAccount(_, let token):
            var headers = HTTPHeaders()
            headers.add(name: "Accept-Language", value: getUserPreferredLanguageCode() ?? "ar")
            headers.add(name: "token", value: token)
            return headers
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getWelcome, .getConstants, .getConstantDetails, .getUserProfile, .logout, .map, .getOrders, .getOrderDetails, .getNotifications, .readNotification, .getWallet, .createReferal, .notificationCount, .guest, .deleteAccount:
            return nil
        case .register(let params), .verify(let params), .resend(let params), .updateUserDataWithImage(let params, _), .addOrder(let params, _), .addOfferToOrder(_, let params, _), .updateOfferStatus(_, let params, _), .updateOrderStatus(_, let params, _), .addReview(_, let params, _), .addBalanceToWallet(let params, _), .addComplain(let params, _), .checkCoupon(let params, _):
            return params
        }
    }
}

