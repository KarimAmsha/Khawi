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
    @StateObject private var viewModel = PaymentState(errorHandling: ErrorHandling())
    @State private var showAddBalanceView = false

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
                                HStack {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(LocalizedStringKey.lastTransaction)
                                            .customFont(weight: .book, size: 14)
                                          .foregroundColor(Color.black141F1F())
                                        if let lastDate = viewModel.walletResponse?.last_date {
                                            let formattedDate = lastDate.formattedDateString(with: "yyyy-MM-dd")
                                            Text(formattedDate ?? "Invalid date")
                                                .customFont(weight: .book, size: 14)
                                              .foregroundColor(Color.black141F1F())
                                        }
                                    }
                                    Spacer()
                                    HStack {
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text(LocalizedStringKey.totalAccount)
                                                .customFont(weight: .book, size: 14)
                                                .foregroundColor(Color.black141F1F())
                                            Text("\(LocalizedStringKey.sar) \(viewModel.walletResponse?.total?.toString() ?? "")")
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
                        
                        ScrollView(showsIndicators: false) {
                            ForEach(viewModel.walletDataItems, id: \.self) { item in
                                TransactionsRowiew(item: item)
                            }
                            
                            if viewModel.shouldLoadMoreData {
                                Color.clear.onAppear {
                                    loadMore()
                                }
                            }

                            if viewModel.isFetchingMoreData {
                                LoadingView()
                            }
                        }

                        Spacer()
                    }
                    .frame(minWidth: geometry.size.width)
                    .frame(minHeight: geometry.size.height)
                }
            }
            
            HStack {
                Button(action: {
                    withAnimation {
                        showAddBalanceView.toggle()
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
                .scaleEffect(showAddBalanceView ? 1.2 : 1.0)
                .padding(.top, 32)

                Spacer()
            }
        }
        .padding(24)
        .navigationTitle("")
        .navigationDestination(isPresented: $showAddBalanceView, destination: {
            AddBalanceView(showAddBalanceView: $showAddBalanceView, router: MainRouter(isPresented: .constant(.main)), onsuccess: {
                //
            })
        })
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(LocalizedStringKey.wallet)
                        .customFont(weight: .book, size: 20)
                      .foregroundColor(Color.black141F1F())
                }
            }
        }
        .onAppear {
            loadData()
        }
        .onChange(of: viewModel.errorMessage) { errorMessage in
            if let errorMessage = errorMessage {
                router.presentToastPopup(view: .error(LocalizedStringKey.error, errorMessage, .error))
            }
        }
    }
}

#Preview {
    WalletView(settings: UserSettings(), router: MainRouter(isPresented: .constant(.main)))
}

extension WalletView {
    func loadData() {
        viewModel.walletDataItems.removeAll()
        viewModel.fetchWallet(page: 0, limit: 10)
    }
    
    func loadMore() {
        viewModel.loadMoreWalletItems(limit: 10)
    }
}
