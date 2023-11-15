//
//  PaymentViewController.swift
//  Khawi
//
//  Created by Karim Amsha on 14.11.2023.
//

import UIKit
import PaymentSDK

class PaymentViewController: UIViewController {
    let configuration: PaymentSDKConfiguration
    let delegate: PaymentManagerDelegate

    init(configuration: PaymentSDKConfiguration, delegate: PaymentManagerDelegate) {
        self.configuration = configuration
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//    override func viewDidLoad() {
//        super.viewDidLoad()
//        PaymentManager.startCardPayment(on: self, configuration: configuration, delegate: delegate)
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        PaymentManager.startCardPayment(on: self, configuration: configuration, delegate: delegate)
    }
}

//extension PaymentViewController: PaymentManagerDelegate {
//    func paymentManager(didFinishTransaction transactionDetails: PaymentSDKTransactionDetails?, error: Error?) {
//        if let transactionDetails = transactionDetails, transactionDetails.isSuccess() {
//            handlePaymentSuccess(transactionDetails: transactionDetails)
//        } else if let error = error {
//            handlePaymentError(error: error)
//        }
//    }
//
//    func handlePaymentSuccess(transactionDetails: PaymentSDKTransactionDetails) {
//        // Print the response details
//        print("Transaction Reference22222: \(transactionDetails.transactionReference ?? "")")
//        print("Transaction Type: \(transactionDetails.transactionType ?? "")")
//        print("Cart ID: \(transactionDetails.cartID ?? "")")
//
//        // Dismiss the current payment view
//        dismiss(animated: true)
//    }
//
//    func handlePaymentError(error: Error) {
//        // Handle the payment error here
//        print("Payment Error: \(error.localizedDescription)")
//
//        // Dismiss the current payment view on error
//        dismiss(animated: true)
//    }
//}
