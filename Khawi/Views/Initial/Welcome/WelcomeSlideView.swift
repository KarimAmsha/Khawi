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
            VStack {
                AsyncImage(url: item.icon?.toURL()) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 285)
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .imageScale(.large)
                            .foregroundColor(.gray595959())
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(height: 285)
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2) 

            VStack {
                Text(item.Title ?? "")
                    .customFont(weight: .book, size: 24)
                    .foregroundColor(.black141F1F())
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)

                Text(item.Description ?? "")
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
        WelcomeSlideView(item: WelcomeItem(_id: "", icon: "", Title: "", Description: ""))
    }
}
