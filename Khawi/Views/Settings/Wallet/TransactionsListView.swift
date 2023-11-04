//
//  TransactionsListView.swift
//  Khawi
//
//  Created by Karim Amsha on 28.10.2023.
//

import SwiftUI

struct TransactionListView: View {
    let items: [Int] = Array(1...10) 

    var body: some View {
        ScrollView {
            ForEach(items, id: \.self) { item in
                TransactionsRowiew(item: item)
            }
        }
    }
}

struct TransactionsListView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionListView()
    }
}
