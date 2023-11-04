//
//  MiddleButtonView.swift
//  Khawi
//
//  Created by Karim Amsha on 24.10.2023.
//

import SwiftUI

struct MiddleButtonView: View {
    @Binding var showPopUp: Bool
    
    var body: some View {
        VStack {
            HStack{
                Spacer()
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 65, height: 65)
                        .background(Color.primary())
                        .cornerRadius(37.5)
                        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 2)
                    
                    Image(showPopUp ? "ic_add_close" : "ic_add")
                }
                .frame(width: 65, height: 65)
                Spacer()
            }
            
            Spacer()
        }
        .padding(.horizontal, -10)
        .padding(.top, 5)
        .onTapGesture {
            withAnimation {
                showPopUp.toggle()
            }
        }
    }
}

#Preview {
    MiddleButtonView(showPopUp: .constant(true))
}
