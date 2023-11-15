//
//  AddComplainView.swift
//  Khawi
//
//  Created by Karim Amsha on 15.11.2023.
//

import SwiftUI

struct AddComplainView: View {
    @State private var name = ""
    @State private var phone = ""
    @State private var email = ""
    @State private var description: String = LocalizedStringKey.description
    @State var placeholderString = LocalizedStringKey.description
    @StateObject var viewModel = UserViewModel(errorHandling: ErrorHandling())
    @StateObject var settings: UserSettings
    @StateObject private var router: MainRouter

    init(settings: UserSettings, router: MainRouter) {
        _settings = StateObject(wrappedValue: settings)
        _router = StateObject(wrappedValue: router)
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) {
                        VStack(spacing: 16) {
                            CustomTextField(text: $name, placeholder: LocalizedStringKey.fullName, textColor: .black4E5556(), placeholderColor: .grayA4ACAD())
                                .disabled(viewModel.isLoading)
                            CustomTextField(text: $phone, placeholder: LocalizedStringKey.phoneNumber, textColor: .black4E5556(), placeholderColor: .grayA4ACAD())
                                .keyboardType(.phonePad)
                                .disabled(viewModel.isLoading)
                            CustomTextField(text: $email, placeholder: LocalizedStringKey.email, textColor: .black4E5556(), placeholderColor: .grayA4ACAD())
                                .keyboardType(.emailAddress)
                                .disabled(viewModel.isLoading)
                            
                            TextEditor(text: self.$description)
                                .foregroundColor(self.description == placeholderString ? .gray : .black)
                                .customFont(weight: .book, size: 14)
                                .frame(height: 100)
                                .onTapGesture {
                                    if self.description == placeholderString {
                                        self.description = ""
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 14)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .inset(by: 0.5)
                                        .stroke(Color(red: 0.93, green: 0.93, blue: 0.93), lineWidth: 1)
                                )
                        }
                        .padding(.top, 12)

                        Spacer()
                        
                        if viewModel.isLoading {
                            LoadingView()
                        }

                        Button {
                            addComplain()
                        } label: {
                            Text(LocalizedStringKey.send)
                        }
                        .buttonStyle(PrimaryButton(fontSize: 18, fontWeight: .book, background: .primary(), foreground: .white, height: 48, radius: 12))
                        .disabled(viewModel.isLoading)
                    }
                    .padding(24)
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: geometry.size.height)
                }
            }
        }
        .dismissKeyboard()
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(LocalizedStringKey.contactUs)
                        .customFont(weight: .book, size: 20)
                      .foregroundColor(Color.black141F1F())
                }
            }
        }
        .onChange(of: viewModel.errorMessage) { errorMessage in
            if let errorMessage = errorMessage {
                router.presentToastPopup(view: .error("", errorMessage))
            }
        }
        .onAppear {
            name = settings.user?.full_name ?? ""
            phone = settings.user?.phone_number ?? ""
            email = settings.user?.email ?? ""
        }
    }
}

#Preview {
    AddComplainView(settings: UserSettings(), router: MainRouter(isPresented: .constant(.main)))
}

extension AddComplainView {
    func addComplain() {
        let params: [String: Any] = [
            "details": description,
            "full_name": name,
            "email": email,
            "phone_number": phone
        ]
        
        viewModel.addComplain(params: params) { message in
            showMessage(message: message)
        }
    }
    
    func showMessage(message: String) {
        let alertModel = AlertModel(
            title: LocalizedStringKey.message,
            message: message,
            hideCancelButton: true,
            onOKAction: {
                router.dismiss()
                router.navigateBack()
            },
            onCancelAction: {
                router.dismiss()
            }
        )
        
        router.presentToastPopup(view: .alert(alertModel))
    }
}
