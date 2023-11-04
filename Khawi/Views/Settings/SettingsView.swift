//
//  SettingsView.swift
//  Khawi
//
//  Created by Karim Amsha on 28.10.2023.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var settings: UserSettings
    @StateObject private var router: MainRouter
    
    init(settings: UserSettings, router: MainRouter) {
        _settings = StateObject(wrappedValue: settings)
        _router = StateObject(wrappedValue: router)
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 24) {
                    HStack(spacing: 16) {
                        AsyncImage(url: settings.myUser.image?.toURL()) { phase in
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

                        Text(settings.myUser.name ?? "")
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
                        //
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
                        //
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
                        //
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
                        //
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
                        //
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
    }
}

#Preview {
    SettingsView(settings: UserSettings(), router: MainRouter(isPresented: .constant(.main)))
}
