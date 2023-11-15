//
//  TransactionsRowiew.swift
//  Khawi
//
//  Created by Karim Amsha on 28.10.2023.
//

import SwiftUI

struct TransactionsRowiew: View {
    let item: WalletData

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 11) {
                Image(item.paymentType == "Online" ? "ic_transfer_up" : "ic_transfer_down")
                    .resizable()
                    .frame(width: 20, height: 20)
                VStack(alignment: .leading) {
                    Text("\(item.orderNo ?? "") \(LocalizedStringKey.orderNo)")
                        .customFont(weight: .book, size: 14)
                        .foregroundColor(.blue288599())
                    Text(item.details ?? "")
                        .customFont(weight: .book, size: 14)
                        .foregroundColor(.black141F1F())
                }
                Spacer()
                Text("\(LocalizedStringKey.sar) \(item.total?.toString() ?? "")")
                    .customFont(weight: .book, size: 14)
                    .foregroundColor(.black141F1F())
            }
            
            CustomDivider()
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 6)
    }
}

#Preview {
    TransactionsRowiew(item: WalletData(id: nil, orderNo: nil, user: nil, details: nil, total: nil, paymentType: nil, createAt: nil))
}

