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
import Combine

struct RegisterView: View {
    @State var mobile: String = ""
    @State var isEditing: Bool = true
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var settings: UserSettings
    @Environment(\.presentationMode) var presentationMode
    @StateObject var monitor = Monitor()
//    @State private var selectedRegion = "SA" // Default selected region
//    @State private var countryCode = "+966" // Default country code for Saudi Arabia
    @State var completePhoneNumber = ""
    @StateObject private var viewModel = AuthViewModel(errorHandling: ErrorHandling())
    @StateObject private var router: MainRouter
    @State private var userLocation: CLLocationCoordinate2D? = nil
    private let errorHandling = ErrorHandling()
    @State var presentSheet = false
    @FocusState private var keyIsFocused: Bool
    @State var countryCode : String = "+966"
    @State var countryFlag : String = "🇸🇦"
    @State var countryPattern : String = "## ### ####"
    @State var countryLimit : Int = 17
    let counrties: [CPData] = Bundle.main.decode("CountryNumbers.json")
    @State private var searchCountry: String = ""

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

                    HStack(spacing: 10) {
                        Button {
                            presentSheet = true
                            keyIsFocused = false
                        } label: {
                            Text("\(countryFlag) \(countryCode)")
                                .foregroundColor(.black141F1F())
                        }

                        TextField("", text: $mobile)
                            .placeholder(when: mobile.isEmpty) {
                                Text(LocalizedStringKey.phoneNumber)
                                    .foregroundColor(.white)
                            }
                            .focused($keyIsFocused)
                            .foregroundColor(.black141F1F())
                            .keyboardType(.phonePad)
                            .onReceive(Just(mobile)) { _ in
                                applyPatternOnNumbers(&mobile, pattern: countryPattern, replacementCharacter: "#")
                            }
                    }
                    .environment(\.layoutDirection, .leftToRight)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color(red: 0.98, green: 0.98, blue: 0.98))
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
        .sheet(isPresented: $presentSheet) {
            NavigationStack {
                List(filteredResorts) { country in
                    
                    HStack {
                        Text(country.flag)
                        Text(country.name)
                            .font(.headline)
                        Spacer()
                        Text(country.dial_code)
                            .foregroundColor(.secondary)
                    }
                    .onTapGesture {
                        self.countryFlag = country.flag
                        self.countryCode = country.dial_code
                        self.countryPattern = country.pattern
                        self.countryLimit = country.limit
                        presentSheet = false
                        searchCountry = ""
                    }
                }
                .listStyle(.plain)
                .searchable(text: $searchCountry, prompt: LocalizedStringKey.yourCountry)
            }
            .environment(\.layoutDirection, .leftToRight)
        }
        .onAppear {
            // Use the user's current location if available
            if let userLocation = LocationManager.shared.userLocation {
                self.userLocation = userLocation
            }
            
//            #if DEBUG
//            mobile = "905345719207"
//            #endif
        }
        .onChange(of: viewModel.errorMessage) { errorMessage in
            if let errorMessage = errorMessage {
                router.presentToastPopup(view: .error("", errorMessage))
            }
        }
    }
    
    private func getCompletePhoneNumber() -> String {
        completePhoneNumber = "\(countryCode)\(mobile)".replacingOccurrences(of: " ", with: "")
        
        // Remove "+" from countryCode
        if countryCode.hasPrefix("+") {
            completePhoneNumber = completePhoneNumber.replacingOccurrences(of: countryCode, with: String(countryCode.dropFirst()))
        }
        
        return completePhoneNumber
    }

    var filteredResorts: [CPData] {
        if searchCountry.isEmpty {
            return counrties
        } else {
            return counrties.filter { $0.name.contains(searchCountry) }
        }
    }
    
    func applyPatternOnNumbers(_ stringvar: inout String, pattern: String, replacementCharacter: Character) {
        var pureNumber = stringvar.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else {
                stringvar = pureNumber
                return
            }
            let stringIndex = String.Index(utf16Offset: index, in: pattern)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacementCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        stringvar = pureNumber
    }
}

#Preview {
    RegisterView(router: MainRouter(isPresented: .constant(.register)))
        .environmentObject(AppState())
        .environmentObject(UserSettings())
}

extension RegisterView {
    func register(fcmToken: String) {
        print(getCompletePhoneNumber())
        let params = [
            "phone_number": getCompletePhoneNumber(),
            "os": "IOS",
            "fcmToken": fcmToken,
            "lat": userLocation?.latitude ?? 0.0,
            "lng": userLocation?.longitude ?? 0.0,
            "address": "",
        ] as [String : Any]
        
        viewModel.registerUser(params: params, onsuccess: { id in
            router.presentViewSpec(viewSpec: .smsVerification(id, getCompletePhoneNumber()))
        })
    }
}
