//
//  PaymentDelegate.swift
//  Khawi
//
//  Created by Karim Amsha on 15.11.2023.
//

import PaymentSDK
import UIKit

class PaymentDelegate: PaymentManagerDelegate {
    @Published var paymentSuccess: Bool = false
    @Published var paymentError = ""
    weak var paymentState: PaymentState? // Add a weak reference to PaymentState

    init(paymentState: PaymentState) {
        self.paymentState = paymentState
    }

    func paymentManager(didFinishTransaction transactionDetails: PaymentSDKTransactionDetails?, error: Error?) {
        if let transactionDetails = transactionDetails, transactionDetails.isSuccess() {
            // Handle payment success
            handlePaymentSuccess(transactionDetails: transactionDetails)
        } else if let error = error {
            // Handle payment error
            handlePaymentError(error: error)
        }
    }
    
    func handlePaymentSuccess(transactionDetails: PaymentSDKTransactionDetails) {
        self.paymentSuccess = true
        self.paymentError = ""
        // Print the response details
        print("Transaction Reference: \(transactionDetails.transactionReference ?? "")")
        print("Transaction Type: \(transactionDetails.transactionType ?? "")")
        print("Cart ID: \(transactionDetails.cartID ?? "")")
        
        // Notify PaymentState about the success
        notifyPaymentStatus()
    }

    func handlePaymentError(error: Error) {
        self.paymentSuccess = false
        // Handle the payment error here
        self.paymentError = error.localizedDescription
        print("Payment Error: \(error.localizedDescription)")
        // Notify PaymentState about the success
        notifyPaymentStatus()
    }
    
    private func notifyPaymentStatus() {
        DispatchQueue.main.async {
            self.paymentState?.updatePaymentSuccess(paymentSuccess: self.paymentSuccess, paymentError: self.paymentError)
        }
    }

    func paymentManager(didCancelPayment error: Error?) {
        self.paymentError = error?.localizedDescription ?? ""
        print("Payment error: \(error?.localizedDescription)")
        // Notify PaymentState about the success
        notifyPaymentStatus()
    }
    
    func paymentManager(didRecieveValidation error: Error?) {
        self.paymentError = error?.localizedDescription ?? ""
        print("Payment error: \(error?.localizedDescription)")
        // Notify PaymentState about the success
        notifyPaymentStatus()
    }
    
    func paymentManager(didStartPaymentTransaction rootViewController: UIViewController) {
        print(rootViewController)
    }
}
