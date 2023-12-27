//
//  SplashView.swift
//  Khawi
//
//  Created by Karim Amsha on 20.10.2023.
//

import SwiftUI

struct SplashView: View {
    @State private var isSplash1Visible = true

    var body: some View {
        ZStack {
            Color.primary()
                .ignoresSafeArea()

            Rectangle()
                .frame(width: 171, height: 271)
                .foregroundColor(.clear)
                .background(Color.white)
                .cornerRadius(85.5)
                .overlay(
                    Image(isSplash1Visible ? "ic_transparent_logo" : "ic_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 105, height: 197)
                )
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 3)
                .opacity(!isSplash1Visible ? 1 : 0) 

            Image(isSplash1Visible ? "splash_map1" : "splash_map2")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .ignoresSafeArea()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                isSplash1Visible = false
            }
        }
    }
}

#Preview {
    SplashView()
}
