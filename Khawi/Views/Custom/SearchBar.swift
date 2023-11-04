//
//  SearchBar.swift
//  Khawi
//
//  Created by Karim Amsha on 24.10.2023.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var placeholder: String 
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(.black141F1F())
            
            TextField(placeholder, text: $text)
                .customFont(weight: .book, size: 16)
                .textFieldStyle(PlainTextFieldStyle())
                .accentColor(.primary())
        }
        .frame(maxWidth: .infinity, maxHeight: 50)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.grayF9FAFA())
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .inset(by: 0.5)
                        .stroke(Color.grayE6E9EA(), lineWidth: 1)
                )
        )
    }
}

#Preview {
    SearchBar(text: .constant(""), placeholder: LocalizedStringKey.searchForPlace)
}

