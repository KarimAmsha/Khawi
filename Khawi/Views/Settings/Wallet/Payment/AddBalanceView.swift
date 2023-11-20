//
//  AddBalanceView.swift
//  Khawi
//
//  Created by Karim Amsha on 14.11.2023.
//

import SwiftUI
import PaymentSDK

struct AddBalanceView: View {
    @State private var coupon = ""
    @State private var amount = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @StateObject private var router: MainRouter
    @Binding var showAddBalanceView: Bool
    var onsuccess: () -> Void
    @StateObject private var paymentState = PaymentState(errorHandling: ErrorHandling())
    
    init(showAddBalanceView: Binding<Bool>, router: MainRouter, onsuccess: @escaping () -> Void) {
        _showAddBalanceView = showAddBalanceView
        _router = StateObject(wrappedValue: router)
        self.onsuccess = onsuccess
    }

    var body: some View {
        VStack(spacing: 20) {
            
            CustomTextFieldWithTitle(text: $coupon, placeholder: LocalizedStringKey.coupon, textColor: .black4E5556(), placeholderColor: .grayA4ACAD())
                .disabled(paymentState.isLoading)
            
            CustomTextFieldWithTitle(text: $amount, placeholder: LocalizedStringKey.amount, textColor: .black4E5556(), placeholderColor: .grayA4ACAD())
                .keyboardType(.numberPad)
                .disabled(paymentState.isLoading)

            if let errorMessage = paymentState.errorMessage {
                Text(errorMessage)
                    .customFont(weight: .book, size: 14)
                    .foregroundColor(.redFF3F3F())
            }

            if paymentState.isLoading {
                LoadingView()
            }

            Button {
                checkCoupon()
            } label: {
                Text(LocalizedStringKey.send)
            }
            .buttonStyle(PrimaryButton(fontSize: 18, fontWeight: .book, background: .primary(), foreground: .white, height: 48, radius: 12))
            .disabled(paymentState.isLoading)

            Spacer()
        }
        .padding()
        .navigationTitle(LocalizedStringKey.addAccount)
        .alert(isPresented: $showAlert) {
            Alert(title: Text(LocalizedStringKey.error), message: Text(alertMessage), dismissButton: .default(Text(LocalizedStringKey.ok)))
        }
        .onChange(of: paymentState.errorMessage) { errorMessage in
            if let errorMessage = errorMessage {
                router.presentToastPopup(view: .error(LocalizedStringKey.error, errorMessage))
            }
        }
        .onChange(of: paymentState.paymentSuccess) { paymentSuccess in
            // Do something when payment is successful
            if paymentSuccess {
                addBalance()
            }
        }
    }
}

extension AddBalanceView {
    func checkCoupon() {
        let params: [String: Any] = [
            "coupon": coupon,
            "amount": amount.toDouble() ?? 0.0
        ]
        
        if coupon.isEmpty {
            guard !amount.isEmpty else {
                paymentState.errorMessage = LocalizedStringKey.addAccount
                return
            }
            startPayment(amount: amount.toDouble() ?? 0.0)
        } else {
            paymentState.checkCoupon(params: params) {
                startPayment(amount: paymentState.coupon?.final_total?.toDouble() ?? 0.0)
            }
        }
    }
    
    func startPayment(amount: Double) {
        paymentState.startCardPayment(amount: amount)
    }
    
    func addBalance() {
        let params: [String: Any] = [
            "amount": coupon.isEmpty ? amount.toDouble() ?? 0.0 : paymentState.coupon?.final_total?.toDouble() ?? 0.0,
            "coupon": coupon,
        ]
        
        paymentState.addBalanceToWallet(params: params) { message in
            showAddBalanceView = false
            self.onsuccess()
        }
    }
}

