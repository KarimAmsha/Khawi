//
//  WelcomeControlDots.swift
//  Khawi
//
//  Created by Karim Amsha on 20.10.2023.
//

import SwiftUI

struct WelcomeControlDots: View {
    let numberOfPages: Int
    @Binding var currentPage: Int

    var body: some View {
        HStack {
            ForEach(0..<numberOfPages, id: \.self) { page in
                Image(page == currentPage ? "ic_current_page_dot" : "ic_page_dot")
            }
        }
    }
}
