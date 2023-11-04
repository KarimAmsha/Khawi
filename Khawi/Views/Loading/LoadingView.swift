//
//  LoadingView.swift
//  MyMoviesSWiftUI
//
//  Created by Karim Amsha on 18.06.2023.
//

import SwiftUI

struct LoadingView<Content>: View where Content: View {

    @Binding var isShowing: Bool
    var content: () -> Content

    var body: some View {
        // Loader view
        GeometryReader { geometry in
            let size = geometry.size.width / 10
            ZStack(alignment: .center) {

                self.content()
                    .disabled(self.isShowing)
                    .blur(radius: self.isShowing ? 3 : 0)

                VStack {
                    Text(LocalizedStringKey.loading)
                        .customFont(weight: .book, size: 15)
                        .foregroundColor(Color.black131313())
                    ActivityIndicatorView(isVisible: self.$isShowing, type: .flickeringDots)
                        .frame(width: size, height: size)
                        .foregroundColor(.black131313())
                        .padding()
                }
                .frame(width: geometry.size.width / 2,
                       height: geometry.size.height / 5)
                .background(Color.primary().opacity(0.5))
                .clipShape(Circle())
                .opacity(self.isShowing ? 1 : 0)
            }
        }
    }
}

