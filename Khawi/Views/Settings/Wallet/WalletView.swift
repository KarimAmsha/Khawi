//
//  WalletView.swift
//  Khawi
//
//  Created by Karim Amsha on 28.10.2023.
//

import SwiftUI

struct WalletView: View {
    @StateObject var settings: UserSettings
    @StateObject private var router: MainRouter
    @State private var isButtonScaled = false

    init(settings: UserSettings, router: MainRouter) {
        _settings = StateObject(wrappedValue: settings)
        _router = StateObject(wrappedValue: router)
    }

    var body: some View {
        VStack {
            GeometryReader { geometry in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 16) {
                        ZStack {
                            Image("ic_wallet_bg")
                                .resizable()
                                .frame(maxWidth: .infinity)
                                .frame(height: 169)
                                .cornerRadius(16)
                            
                            VStack(alignment: .leading) {
                                Text(LocalizedStringKey.myWallet)
                                    .customFont(weight: .bold, size: 18)
                                  .foregroundColor(Color.black141F1F())
                                Spacer()
                                HStack {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(LocalizedStringKey.lastTransaction)
                                            .customFont(weight: .book, size: 14)
                                          .foregroundColor(Color.black141F1F())
                                        Text("14 ربيع الأول، ١٤٤٥ هـ")
                                            .customFont(weight: .book, size: 14)
                                          .foregroundColor(Color.black141F1F())
                                    }
                                    Spacer()
                                    HStack {
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text(LocalizedStringKey.totalAccount)
                                                .customFont(weight: .book, size: 14)
                                                .foregroundColor(Color.black141F1F())
                                            Text("\(LocalizedStringKey.sar) 1520.5")
                                                .customFont(weight: .bold, size: 16)
                                                .foregroundColor(Color.black141F1F())
                                        }
                                    }
                                }
                            }
                            .padding(24)
                        }
                        
                        Text(LocalizedStringKey.finicialTransactions)
                            .customFont(weight: .bold, size: 14)
                          .foregroundColor(Color.black141F1F())
                        
                        TransactionListView()
                        
                        Spacer()
                    }
                    .frame(minWidth: geometry.size.width)
                    .frame(minHeight: geometry.size.height)
                }
            }
            
            HStack {
                Button(action: {
                    withAnimation {
                        isButtonScaled.toggle()
                    }
                }) {
                    VStack(spacing: 5) {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .fontWeight(.bold)
                        Text(LocalizedStringKey.addAccount)
                            .customFont(weight: .bold, size: 10)
                            .foregroundColor(.white)
                    }
                    .foregroundColor(.white)
                }
                .frame(width: 68, height: 68)
                .background(Color.primary())
                .clipShape(Circle())
                .scaleEffect(isButtonScaled ? 1.2 : 1.0)
                .padding(.top, 32)

                Spacer()
            }
        }
        .padding(24)
        .navigationTitle("")
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(LocalizedStringKey.wallet)
                        .customFont(weight: .book, size: 20)
                      .foregroundColor(Color.black141F1F())
                }
            }
        }
    }
}

#Preview {
    WalletView(settings: UserSettings(), router: MainRouter(isPresented: .constant(.main)))
}
