//
//  TransactionsRowiew.swift
//  Khawi
//
//  Created by Karim Amsha on 28.10.2023.
//

import SwiftUI

struct TransactionsRowiew: View {
    let item: Int

    var body: some View {
        VStack(spacing: 24) {
            HStack(spacing: 11) {
                Image(item%2==0 ? "ic_transfer_down" : "ic_transfer_up")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text("رسوم رحلة رقم #154645")
                    .customFont(weight: .book, size: 14)
                    .foregroundColor(.black141F1F())
                Spacer()
                Text(item%2==0 ? "\(LocalizedStringKey.sar) -50" : "\(LocalizedStringKey.sar) 50")
                    .customFont(weight: .book, size: 14)
                    .foregroundColor(.black141F1F())
            }
            
            CustomDivider()
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
    }
}

#Preview {
    TransactionsRowiew(item: 1)
}

