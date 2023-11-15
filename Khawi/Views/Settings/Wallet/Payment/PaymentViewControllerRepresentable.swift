//
//  PaymentViewControllerRepresentable.swift
//  Khawi
//
//  Created by Karim Amsha on 14.11.2023.
//

import SwiftUI
import PaymentSDK

// PaymentViewControllerRepresentable.swift

struct PaymentViewControllerRepresentable: UIViewControllerRepresentable {
    let configuration: PaymentSDKConfiguration
    @Binding var isPresented: Bool
    var handlePaymentSuccess: () -> Void

    class Coordinator: NSObject, PaymentManagerDelegate {
        var parent: PaymentViewControllerRepresentable

        init(parent: PaymentViewControllerRepresentable) {
            self.parent = parent
        }

        func paymentManager(didFinishTransaction transactionDetails: PaymentSDKTransactionDetails?, error: Error?) {
            if let transactionDetails = transactionDetails, transactionDetails.isSuccess() {
                // Handle payment success
                print("Payment successful! \(transactionDetails)")
                parent.handlePaymentSuccess()
            } else if let error = error {
                // Handle payment error
                print("Payment Error: \(error.localizedDescription)")
            }
            parent.isPresented = false
            print("parent.isPresented \(parent.isPresented)")
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let coordinator = context.coordinator
        let paymentViewController = PaymentViewController(configuration: configuration, delegate: coordinator)
        return paymentViewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Update the view controller if needed
    }
}


//import PaymentSDK
//
//class PaymentDelegate: PaymentManagerDelegate {
//    func paymentManager(didFinishTransaction transactionDetails: PaymentSDKTransactionDetails?, error: Error?) {
//        if let transactionDetails = transactionDetails, transactionDetails.isSuccess() {
//            // Handle payment success
//            print("Payment successful bbbbb!")
//        } else if let error = error {
//            // Handle payment error
//            print("Payment error: \(error.localizedDescription)")
//            // handlePaymentError(error: error)
//        }
//    }
//}
//
