//
//  PaymentType.swift
//  Khawi
//
//  Created by Karim Amsha on 15.11.2023.
//

import Foundation
import PaymentSDK

enum PaymentType {
    case card
    case applePay
    // Add more payment methods as needed...

    var configuration: PaymentSDKConfiguration {
        switch self {
        case .card:
            return PaymentSDKConfiguration(profileID: "88646",
                                           serverKey: "SZJN2DKWTG-JDHMTD6T2L-KZJKMN6GKH",
                                           clientKey: "C7KMQQ-R7BR6D-HN7DG7-KQKMRQ",
                                           currency: "SAR",
                                           amount: 5.0,
                                           merchantCountryCode: "SA")
                .cartDescription("Flowers")
                .cartID("1234")
                .screenTitle(LocalizedStringKey.payWithCard)
                .theme(PaymentSDKTheme.default)
                .billingDetails(PaymentSDKBillingDetails(name: "John Smith",
                                                          email: "email@test.com",
                                                          phone: "+97311111111",
                                                          addressLine: "Street1",
                                                          city: "Riyad",
                                                          state: "Riyad",
                                                          countryCode: "sa",
                                                          zip: "12345"))
        case .applePay:
            return PaymentSDKConfiguration(profileID: "88646",
                                           serverKey: "SZJN2DKWTG-JDHMTD6T2L-KZJKMN6GKH",
                                           clientKey: "C7KMQQ-R7BR6D-HN7DG7-KQKMRQ",
                                           currency: "SAR",
                                           amount: 5.0,
                                           merchantCountryCode: "SA")
                .cartDescription("Flowers")
                .cartID("1234")
                .screenTitle(LocalizedStringKey.payWithApplePay)
                .merchantName("Flowers Store")
                .merchantAppleBundleID("merchant.com.bundleID")
                .simplifyApplePayValidation(true)
        }
    }
}

