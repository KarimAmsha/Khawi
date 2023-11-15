////
////  PaymentView.swift
////  Khawi
////
////  Created by Karim Amsha on 14.11.2023.
////
//
import SwiftUI
import PaymentSDK

struct PaymentView: View {
    let configuration: PaymentSDKConfiguration
    @Binding var isPresented: Bool
    var handlePaymentSuccess: () -> Void

    var body: some View {
        VStack {
            PaymentViewControllerRepresentable(configuration: configuration, isPresented: $isPresented, handlePaymentSuccess: handlePaymentSuccess)
        }
        .navigationTitle(LocalizedStringKey.addAccount)
    }
}
