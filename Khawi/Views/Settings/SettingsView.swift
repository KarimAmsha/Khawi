//
//  SettingsView.swift
//  Khawi
//
//  Created by Karim Amsha on 28.10.2023.
//

import SwiftUI
import FirebaseDynamicLinks
import PopupView

struct SettingsView: View {
    @StateObject var settings: UserSettings
    @StateObject private var router: MainRouter
    private let errorHandling = ErrorHandling()
    @StateObject private var initialViewModel = InitialViewModel(errorHandling: ErrorHandling())
    @StateObject private var authViewModel = AuthViewModel(errorHandling: ErrorHandling())
    let appURL = URL(string: "https://www.example.com")
    @State private var referralCode: String?
    @State private var showInviteFriends = false
    @State private var showLogout = false
    @State private var showDelete = false

    init(settings: UserSettings, router: MainRouter) {
        _settings = StateObject(wrappedValue: settings)
        _router = StateObject(wrappedValue: router)
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 24) {
                    HStack(spacing: 16) {
                        AsyncImage(url: settings.user?.image?.toURL()) { phase in
                            switch phase {
                            case .empty:
                                ProgressView() // Placeholder while loading
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 56, height: 56)
                                    .clipShape(Circle()) // Clip the image to a circle
                            case .failure:
                                Image(systemName: "photo.circle") // Placeholder for failure
                                    .imageScale(.large)
                                    .foregroundColor(.gray)
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .frame(width: 56, height: 56)
                        .clipShape(Circle())

                        Text(settings.user?.full_name ?? "")
                            .customFont(weight: .book, size: 20)
                            .foregroundColor(.black141F1F())
                        
                        Spacer()
                        
                        Button {
                            router.presentViewSpec(viewSpec: .editProfile)
                        } label: {
                            Text(LocalizedStringKey.profile)
                                .customFont(weight: .book, size: 12)
                        }
                        .buttonStyle(CustomButtonStyle())
                    }
                    
                    Button {
                        router.presentViewSpec(viewSpec: .wallet)
                    } label: {
                        HStack(spacing: 26) {
                            Image("ic_wallet")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding(20)
                                .background(Color.yellowFFFCF6().clipShape(Circle()))
                            Text(LocalizedStringKey.wallet)
                                .customFont(weight: .book, size: 16)
                                .foregroundColor(.black141F1F())
                            Spacer()
                            Image(systemName: "chevron.left")
                                .resizable()
                                .foregroundColor(.grayA4ACAD())
                                .frame(width: 10, height: 16)
                        }
                    }
                    
                    Button {
                        if let item = initialViewModel.constantsItems?.filter({ $0.Type == "about" }).first {
                            router.presentViewSpec(viewSpec: .constant(item))
                        }
                    } label: {
                        HStack(spacing: 26) {
                            Image("ic_info")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding(20)
                                .background(Color.yellowFFFCF6().clipShape(Circle()))
                            Text(LocalizedStringKey.aboutUs)
                                .customFont(weight: .book, size: 16)
                                .foregroundColor(.black141F1F())
                            Spacer()
                            Image(systemName: "chevron.left")
                                .resizable()
                                .foregroundColor(.grayA4ACAD())
                                .frame(width: 10, height: 16)
                        }
                    }

                    Button {
                        router.presentViewSpec(viewSpec: .addComplain)
                    } label: {
                        HStack(spacing: 26) {
                            Image("ic_chat")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding(20)
                                .background(Color.yellowFFFCF6().clipShape(Circle()))
                            Text(LocalizedStringKey.contactUs)
                                .customFont(weight: .book, size: 16)
                                .foregroundColor(.black141F1F())
                            Spacer()
                            Image(systemName: "chevron.left")
                                .resizable()
                                .foregroundColor(.grayA4ACAD())
                                .frame(width: 10, height: 16)
                        }
                    }
                    
                    Button {
                        shareApp()
                    } label: {
                        HStack(spacing: 26) {
                            Image("ic_share")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding(20)
                                .background(Color.yellowFFFCF6().clipShape(Circle()))
                            Text(LocalizedStringKey.shareApp)
                                .customFont(weight: .book, size: 16)
                                .foregroundColor(.black141F1F())
                            Spacer()
                            Image(systemName: "chevron.left")
                                .resizable()
                                .foregroundColor(.grayA4ACAD())
                                .frame(width: 10, height: 16)
                        }
                    }

                    Button {
                        createReferal()
                    } label: {
                        HStack(spacing: 26) {
                            Image("ic_share")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding(20)
                                .background(Color.yellowFFFCF6().clipShape(Circle()))
                            Text(LocalizedStringKey.inviteFriend)
                                .customFont(weight: .book, size: 16)
                                .foregroundColor(.black141F1F())
                            Spacer()
                            Image(systemName: "chevron.left")
                                .resizable()
                                .foregroundColor(.grayA4ACAD())
                                .frame(width: 10, height: 16)
                        }
                    }

                    Button {
                        if let item = initialViewModel.constantsItems?.filter({ $0.Type == "terms" }).first {
                            router.presentViewSpec(viewSpec: .constant(item))
                        }
                    } label: {
                        HStack(spacing: 26) {
                            Image("ic_help")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding(20)
                                .background(Color.yellowFFFCF6().clipShape(Circle()))
                            Text(LocalizedStringKey.termsConditions)
                                .customFont(weight: .book, size: 16)
                                .foregroundColor(.black141F1F())
                            Spacer()
                            Image(systemName: "chevron.left")
                                .resizable()
                                .foregroundColor(.grayA4ACAD())
                                .frame(width: 10, height: 16)
                        }
                    }
                    
                    Button {
                        showLogout = true
                    } label: {
                        HStack(spacing: 26) {
                            Image("ic_logout")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding(20)
                                .background(Color.yellowFFFCF6().clipShape(Circle()))
                            Text(LocalizedStringKey.logout)
                                .customFont(weight: .book, size: 16)
                                .foregroundColor(.black141F1F())
                            Spacer()
                            Image(systemName: "chevron.left")
                                .resizable()
                                .foregroundColor(.grayA4ACAD())
                                .frame(width: 10, height: 16)
                        }
                    }

                    Button {
                        showDelete = true
                    } label: {
                        HStack(spacing: 26) {
                            Image("ic_logout")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding(20)
                                .background(Color.yellowFFFCF6().clipShape(Circle()))
                            Text(LocalizedStringKey.deleteAccount)
                                .customFont(weight: .book, size: 16)
                                .foregroundColor(.black141F1F())
                            Spacer()
                            Image(systemName: "chevron.left")
                                .resizable()
                                .foregroundColor(.grayA4ACAD())
                                .frame(width: 10, height: 16)
                        }
                    }

                    Spacer()
                }
                .frame(minWidth: geometry.size.width)
                .frame(minHeight: geometry.size.height)
            }
        }
        .padding(24)
        .navigationTitle("")
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(LocalizedStringKey.settings)
                        .customFont(weight: .book, size: 20)
                      .foregroundColor(Color.black141F1F())
                }
            }
        }
        .popup(isPresented: $showLogout) {
            let alertModel = AlertModel(
                iconType: .logo,
                title: LocalizedStringKey.logout,
                message: LocalizedStringKey.logoutMessage,
                hideCancelButton: false,
                onOKAction: {
                    showLogout = false
                    authViewModel.logoutUser {
                    }
                },
                onCancelAction: {
                    showLogout = false
                }
            )
            
            AlertView(alertModel: alertModel)
        } customize: {
            $0
                .type(.toast)
                .position(.bottom)
                .animation(.spring())
                .closeOnTapOutside(false)
                .closeOnTap(false)
                .backgroundColor(.black.opacity(0.5))
        }
        .popup(isPresented: $showDelete) {
            let alertModel = AlertModel(
                iconType: .logo,
                title: LocalizedStringKey.deleteAccount,
                message: LocalizedStringKey.deleteAccountMessage,
                hideCancelButton: false,
                onOKAction: {
                    authViewModel.deleteAccount {
                        showDelete = false
                    }
                },
                onCancelAction: {
                    showDelete = false
                }
            )
            
            AlertView(alertModel: alertModel)
        } customize: {
            $0
                .type(.toast)
                .position(.bottom)
                .animation(.spring())
                .closeOnTapOutside(false)
                .closeOnTap(false)
                .backgroundColor(.black.opacity(0.5))
        }
        .onAppear {
            getConstants()
        }
    }
}

#Preview {
    SettingsView(settings: UserSettings(), router: MainRouter(isPresented: .constant(.main)))
}

extension SettingsView {
    private func getConstants() {
        initialViewModel.fetchConstantsItems()
    }
    
    private func shareApp() {
        if let url = appURL {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                windowScene.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
            }
        }
    }
        
//    private func generateAndShareReferralLink(userID: String) {
//        let link = "https://khawi.page.link/\(userID)"
//
//        guard let dynamicLink = URL(string: link) else {
//            fatalError("Invalid URL")
//        }
//
//        let dynamicLinkDomain = "https://khawi.page.link"
//        let linkBuilder = DynamicLinkComponents(link: dynamicLink, domainURIPrefix: dynamicLinkDomain)
//
//        guard let finalLink = linkBuilder?.url else {
//            fatalError("Invalid Dynamic Link")
//        }
//
//        referralCode = finalLink.absoluteString
//        print("finalLink \(finalLink)")
//
//        shareReferralLink(finalLink)
//    }

    private func shareReferralLink(_ link: URL) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let activityViewController = UIActivityViewController(activityItems: [link], applicationActivities: nil)
            windowScene.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    private func createReferal() {
        authViewModel.createReferal {
            if let url = authViewModel.referal?.shortLink?.toURL() {
                shareReferralLink(url)
            }
        }
    }
}
