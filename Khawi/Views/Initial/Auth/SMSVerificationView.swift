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
    var id: String
    var mobile: String
    @State var code = ""
    @StateObject private var router: MainRouter
    @StateObject private var viewModel = AuthViewModel(errorHandling: ErrorHandling())
    private let errorHandling = ErrorHandling()

    init(id: String, mobile: String, router: MainRouter) {
        self.id = id
        self.mobile = mobile
        _router = StateObject(wrappedValue: router)
    }

    var body: some View {
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
                    .disabled(viewModel.isLoading)
                Spacer()
            }
            .environment(\.layoutDirection, .leftToRight)

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
                    } else {
                        resendCode()
                    }
                }

            // Show a loader while registering
            if viewModel.isLoading {
                LoadingView()
            }

            Spacer()
        }
        .padding(.horizontal, 24)
        .navigationTitle(LocalizedStringKey.verifyCode)
        .dismissKeyboard()
        .onChange(of: viewModel.errorMessage) { errorMessage in
            if let errorMessage = errorMessage {
                router.presentToastPopup(view: .error("", errorMessage))
            }
        }
    }
}

struct SMSVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        SMSVerificationView(id: "", mobile: "", router: MainRouter(isPresented: .constant(.smsVerification("", ""))))
            .environmentObject(AppState())
            .environmentObject(UserSettings())
    }
}

extension SMSVerificationView {
    private func verify() {
        var lastPathComponent = ""
        if let referalUrl = appState.referalUrl {
            lastPathComponent = referalUrl.lastPathComponent
        }

        let params = [
            "id": id,
            "verify_code": code,
            "phone_number": mobile,
            "by": lastPathComponent
        ] as [String : Any]

        viewModel.verify(params: params) { profileCompleted in
            if profileCompleted {
                router.replaceNavigationStack(path: [])
                settings.loggedIn = true
                return
            }
            router.presentViewSpec(viewSpec: .personalInfo)
        }
    }
    
    private func resendCode() {
        let params = [
            "id": id
        ] as [String : Any]

        viewModel.resend(params: params) {}
    }
}
