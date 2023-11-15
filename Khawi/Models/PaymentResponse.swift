//
//  PaymentResponse.swift
//  Khawi
//
//  Created by Karim Amsha on 14.11.2023.
//

import Foundation

struct PaymentResponse: Decodable {
    let tranRef: String?
    let tranType: String?
    let cartID: String?
    let cartDescription: String?
    let cartCurrency: String?
    let cartAmount: String?
    let tranCurrency: String?
    let tranTotal: String?
    let returnURL: String?
    let customerDetails: CustomerDetails?
    let paymentResult: PaymentResult?
    let paymentInfo: PaymentInfo?
    let serviceId: Int?
    let token: String?
    let profileId: Int?
    let merchantId: Int?
    let trace: String?

    enum CodingKeys: String, CodingKey {
        case tranRef = "tran_ref"
        case tranType = "tran_type"
        case cartID = "cart_id"
        case cartDescription = "cart_description"
        case cartCurrency = "cart_currency"
        case cartAmount = "cart_amount"
        case tranCurrency = "tran_currency"
        case tranTotal = "tran_total"
        case returnURL = "return"
        case customerDetails = "customer_details"
        case paymentResult = "payment_result"
        case paymentInfo = "payment_info"
        case serviceId
        case token
        case profileId
        case merchantId
        case trace
    }
}

struct CustomerDetails: Decodable {
    let name: String?
    let email: String?
    let phone: String?
    let street1: String?
    let city: String?
    let state: String?
    let country: String?
    let zip: String?
    let ip: String?
}

struct PaymentResult: Decodable {
    let responseStatus: String?
    let responseCode: String?
    let responseMessage: String?
    let transactionTime: String?

    enum CodingKeys: String, CodingKey {
        case responseStatus = "response_status"
        case responseCode = "response_code"
        case responseMessage = "response_message"
        case transactionTime = "transaction_time"
    }
}

struct PaymentInfo: Decodable {
    let paymentMethod: String?
    let cardType: String?
    let cardScheme: String?
    let paymentDescription: String?
    let expiryMonth: Int?
    let expiryYear: Int?

    enum CodingKeys: String, CodingKey {
        case paymentMethod = "payment_method"
        case cardType = "card_type"
        case cardScheme = "card_scheme"
        case paymentDescription = "payment_description"
        case expiryMonth
        case expiryYear
    }
}
