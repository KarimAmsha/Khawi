//
//  SMSVerificationView.swift
//  Khawi
//
//  Created by Karim Amsha on 22.10.2023.
//

import SwiftUI
import Combine
import PopupView

struct SMSVerificationView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var settings: UserSettings
    @State private var passCodeFilled = false
    @State var moveToPersonalInfoView = false
    @Environment(\.presentationMode) var presentationMode
    @State private var totalSeconds = 300
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var minutes: Int {
        return totalSeconds / 60
    }

    var seconds: Int {
        return totalSeconds % 60
    }
    @StateObject var monitor = Monitor()
    @Binding var mobile: String
    @State var code = ""
    @StateObject var authViewModel = AuthViewModel()

    var body: some View {
        LoadingView(isShowing: $authViewModel.shouldAnimating) {
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(LocalizedStringKey.enterCodeWasSentToYourMobileNumber)
                        .customFont(weight: .book, size: 14)
                        .foregroundColor(.black131313())
                        .padding(.top, 16)
                    Text(mobile)
                        .customFont(weight: .book, size: 14)
                        .foregroundColor(.black131313())
                }

                HStack {
                    Spacer()
                    OtpFormFieldView(combinedPins: $code)
                    Spacer()
                }
                
                Button {
                    verify()
                } label: {
                    Text(LocalizedStringKey.verifyCode)
                }
                .buttonStyle(PrimaryButton(fontSize: 18, fontWeight: .book, background: .primary(), foreground: .white, height: 48, radius: 12))
                .padding(.top, 40)

                Text("(\(minutes):\(seconds)) \(LocalizedStringKey.resendCodeAfter)")
                    .customFont(weight: .book, size: 16)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.primary())
                    .padding(.top, 24)
                    .onReceive(timer) { _ in
                        if totalSeconds > 0 {
                            totalSeconds -= 1
                        }
                    }

                Spacer()
            }
            .padding(.horizontal, 24)
        }
        .navigationTitle(moveToPersonalInfoView ? "" : LocalizedStringKey.register)
        .dismissKeyboard()
        .navigationDestination(isPresented: $moveToPersonalInfoView) {
            PersonalInfoView()
        }
        .popup(isPresented: $authViewModel.showErrorPopup) {
            ErrorToastView(title: $authViewModel.errorTitle, message: $authViewModel.errorMessage)
        } customize: {
            $0
                .type(.toast)
                .position(.bottom)
                .animation(.spring())
                .closeOnTapOutside(true)
                .autohideIn(2)
                .backgroundColor(.black.opacity(0.63))
        }
    }
}

struct SMSVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        SMSVerificationView(mobile: .constant(""))
            .environmentObject(AppState())
            .environmentObject(UserSettings())
    }
}

extension SMSVerificationView {
    private func verify() {
        authViewModel.verify {
            moveToPersonalInfoView = true
        }
    }
}
