//
//  WelcomeSlideView.swift
//  Khawi
//
//  Created by Karim Amsha on 20.10.2023.
//

import SwiftUI

struct WelcomeSlideView: View {
    let item: WelcomeItem

    var body: some View {
        VStack {
            Image(item.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 285)

            VStack {
                Text(item.title)
                    .customFont(weight: .book, size: 24)
                    .foregroundColor(.black141F1F())
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)

                Text(item.description)
                    .customFont(weight: .book, size: 16)
                    .foregroundColor(.gray929292())
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 40)
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 60)
        .frame(maxHeight: .infinity)
    }
}

struct WelcomeSlideView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeSlideView(item: WelcomeItem(imageName: "slider1", titleKey: LocalizedStringKey.shareYourPathWithOthers, descriptionKey: LocalizedStringKey.descriptionKey))
    }
}
