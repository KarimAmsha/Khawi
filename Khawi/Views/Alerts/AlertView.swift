//
//  AlertView.swift
//  GatherPoint
//
//  Created by Karim Amsha on 27.08.2023.
//

import SwiftUI

struct AlertView: View {
    @Binding var message: String

    var body: some View {
        // Alert view
        HStack(spacing: 8) {
            Text(message)
                .foregroundColor(.white)
                .font(.system(size: 16))
        }
        .padding(16)
        .background(Color.primary().cornerRadius(12))
        .padding(.horizontal, 16)
    }
}
