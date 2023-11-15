//
//  ConstantView.swift
//  Khawi
//
//  Created by Karim Amsha on 8.11.2023.
//

import SwiftUI

struct ConstantView: View {
    let item: ConstantItem?
    @State private var contentHeight: CGFloat = 0

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                HTMLView(html: item?.Content ?? "", contentHeight: $contentHeight)
                    .frame(height: contentHeight)
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(item?.Title ?? "")
                        .customFont(weight: .book, size: 20)
                      .foregroundColor(Color.black141F1F())
                }
            }
        }
    }
}

#Preview {
    ConstantView(item: nil)
}
