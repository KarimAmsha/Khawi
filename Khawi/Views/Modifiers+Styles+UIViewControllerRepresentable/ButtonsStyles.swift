//
//  ButtonsStyles.swift
//  Khawi
//
//  Created by Karim Amsha on 20.10.2023.
//

import SwiftUI

struct PrimaryButton: ButtonStyle {
    var fontSize: CGFloat? = 14
    var fontWeight: FontWeight? = .book
    var background: Color? = Color.primary()
    var foreground: Color? = Color.white
    var height: CGFloat? = 48
    var radius: CGFloat? = 24

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity, maxHeight: height, alignment: .center)
            .customFont(weight: fontWeight!, size: fontSize!)
            .foregroundColor(foreground)
            .background(background.cornerRadius(radius!))
            .scaleEffect(configuration.isPressed ? 0.8 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.primary())
            .foregroundColor(.white)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.8 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct PopOverButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .foregroundColor(Color.black141F1F()) // Customize the text color
            .contentShape(Rectangle())
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0) // Add a pressed effect
    }
}

