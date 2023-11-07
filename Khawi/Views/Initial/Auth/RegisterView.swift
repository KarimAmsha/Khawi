//
//  RegisterView.swift
//  Khawi
//
//  Created by Karim Amsha on 22.10.2023.
//

import SwiftUI
import iPhoneNumberField
import PopupView

struct RegisterView: View {
    @State var mobile: String = ""
    @State var isEditing: Bool = true
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var settings: UserSettings
    @Environment(\.presentationMode) var presentationMode
    @State var moveToVerificationCodeView = false
    @StateObject var monitor = Monitor()
    @State private var selectedRegion = "SA" // Default selected region
    @State private var countryCode = "+966" // Default country code for Saudi Arabia
    @State var completePhoneNumber = ""
    @StateObject var authViewModel = AuthViewModel()

    var body: some View {
        LoadingView(isShowing: $authViewModel.shouldAnimating) {
            ScrollView(showsIndicators: false) {
                VStack {
                    Rectangle()
                      .foregroundColor(.clear)
                      .frame(width: 100, height: 188)
                      .background(
                        Image("ic_logo")
                          .resizable()
                          .aspectRatio(contentMode: .fill)
                          .frame(width: 100, height: 188)
                          .clipped()
                      )
                      .padding(.top, 86)

                    Text(LocalizedStringKey.enterYourPhoneNumberToCreateNewAccount)
                        .customFont(weight: .book, size: 14)
                        .foregroundColor(.black4E5556())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 54)

                    VStack(alignment: .leading, spacing: 0) {
                        Text(LocalizedStringKey.phoneNumber)
                            .customFont(weight: .book, size: 11)
                            .foregroundColor(.grayA4ACAD())

                        iPhoneNumberField("000000000", text: $mobile, isEditing: $isEditing)
                            .flagHidden(false)
                            .flagSelectable(true)
                            .defaultRegion(selectedRegion)
                            .formatted(true)
                            .maximumDigits(9)
                            .maximumDigits(10)
                            .foregroundColor(.black141F1F())
                            .clearButtonMode(.whileEditing)
                            .onClear { _ in isEditing.toggle() }
                            .customFont(weight: .book, size: 14)
                            .accentColor(Color.primary())
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .inset(by: 0.5)
                            .stroke(Color.grayE6E9EA(), lineWidth: 1)
                    )
                    
                    Button {
                        login()
                    } label: {
                        Text(LocalizedStringKey.createNewAccount)
                    }
                    .buttonStyle(PrimaryButton(fontSize: 18, fontWeight: .book, background: .primary(), foreground: .white, height: 48, radius: 12))
                    .padding(.top, 40)
                    
                    Spacer()
                }
            }
            .padding(.horizontal, 24)
        }
        .navigationTitle(moveToVerificationCodeView ? "" : LocalizedStringKey.register)
        .toolbarColorScheme(.light, for: .navigationBar)
        .toolbarBackground(Color.white,for: .navigationBar)
//        .toolbarBackground(.visible, for: .navigationBar)
        .dismissKeyboard()
        .navigationDestination(isPresented: $moveToVerificationCodeView) {
            SMSVerificationView(mobile: $mobile)
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

#Preview {
    RegisterView()
        .environmentObject(AppState())
        .environmentObject(UserSettings())
}

extension RegisterView {
    func login() {
        authViewModel.login(username: "", password: "", onsuccess: {
            moveToVerificationCodeView = true
        })
    }
}
