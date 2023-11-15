//
//  RegisterView.swift
//  Khawi
//
//  Created by Karim Amsha on 22.10.2023.
//

import SwiftUI
import iPhoneNumberField
import PopupView
import FirebaseMessaging
import MapKit

struct RegisterView: View {
    @State var mobile: String = ""
    @State var isEditing: Bool = true
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var settings: UserSettings
    @Environment(\.presentationMode) var presentationMode
    @StateObject var monitor = Monitor()
    @State private var selectedRegion = "SA" // Default selected region
    @State private var countryCode = "+966" // Default country code for Saudi Arabia
    @State var completePhoneNumber = ""
    @StateObject private var viewModel = AuthViewModel(errorHandling: ErrorHandling())
    @StateObject private var router: MainRouter
    @State private var userLocation: CLLocationCoordinate2D? = nil
    private let errorHandling = ErrorHandling()

    init(router: MainRouter) {
        _router = StateObject(wrappedValue: router)
    }

    var body: some View {
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

                    iPhoneNumberField("000000000000", text: $mobile, isEditing: $isEditing)
                        .flagHidden(false)
                        .flagSelectable(true)
                        .defaultRegion(selectedRegion)
                        .formatted(true)
                        .maximumDigits(12)
                        .foregroundColor(.black141F1F())
                        .clearButtonMode(.whileEditing)
                        .onClear { _ in isEditing.toggle() }
                        .customFont(weight: .book, size: 14)
                        .accentColor(Color.primary())
                        .disabled(viewModel.isLoading)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .inset(by: 0.5)
                        .stroke(Color.grayE6E9EA(), lineWidth: 1)
                )
                
                Button {
                    Messaging.messaging().token { token, error in
                        if let error = error {
                            router.presentToastPopup(view: .error(LocalizedStringKey.error, error.localizedDescription))
                        } else if let token = token {
                            register(fcmToken: token)
                        }
                    }
                } label: {
                    Text(LocalizedStringKey.createNewAccount)
                }
                .buttonStyle(PrimaryButton(fontSize: 18, fontWeight: .book, background: .primary(), foreground: .white, height: 48, radius: 12))
                .padding(.top, 40)
                .disabled(viewModel.isLoading)

                // Show a loader while registering
                if viewModel.isLoading {
                    LoadingView()
                }

                Spacer()
            }
        }
        .padding(.horizontal, 24)
        .navigationTitle(LocalizedStringKey.register)
        .toolbarColorScheme(.light, for: .navigationBar)
        .toolbarBackground(Color.white,for: .navigationBar)
//        .toolbarBackground(.visible, for: .navigationBar)
        .dismissKeyboard()
        .onAppear {
            // Use the user's current location if available
            if let userLocation = LocationManager.shared.userLocation {
                self.userLocation = userLocation
            }
            
            #if DEBUG
            mobile = "905345719207"
            #endif
        }
        .onChange(of: viewModel.errorMessage) { errorMessage in
            if let errorMessage = errorMessage {
                router.presentToastPopup(view: .error("", errorMessage))
            }
        }
    }
    
    private func getCompletePhoneNumber() -> String {
        completePhoneNumber = "\(countryCode)\(mobile)".replacingOccurrences(of: " ", with: "")
        return completePhoneNumber
    }
}

#Preview {
    RegisterView(router: MainRouter(isPresented: .constant(.register)))
        .environmentObject(AppState())
        .environmentObject(UserSettings())
}

extension RegisterView {
    func register(fcmToken: String) {
        let params = [
            "phone_number": mobile,
            "os": "IOS",
            "fcmToken": fcmToken,
            "lat": userLocation?.latitude ?? 0.0,
            "lng": userLocation?.longitude ?? 0.0,
        ] as [String : Any]
        
        viewModel.registerUser(params: params, onsuccess: { id in
            router.presentViewSpec(viewSpec: .smsVerification(id, mobile))
        })
    }
}
