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

