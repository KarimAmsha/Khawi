//
//  CustomTextField.swift
//  Khawi
//
//  Created by Karim Amsha on 23.10.2023.
//

import SwiftUI

struct CustomTextField: View {
    @Binding var text: String
    
    var placeholder: String
    var textColor: Color
    var placeholderColor: Color
    
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .foregroundColor(.clear)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.grayF9FAFA())
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.grayE6E9EA(), lineWidth: 1)
                )
            
            if text.isEmpty {
                Text(placeholder)
                    .customFont(weight: .book, size: 16)
                    .foregroundColor(placeholderColor)
                    .padding(.horizontal, 8)
            }
            
            TextField("", text: $text)
                .customFont(weight: .book, size: 16)
                .foregroundColor(textColor)
                .accentColor(Color.primary())
                .padding(.horizontal, 8)
        }
    }
}

#Preview {
    CustomTextField(text: .constant("Text"), placeholder: "Text", textColor: .black, placeholderColor: .gray)
}