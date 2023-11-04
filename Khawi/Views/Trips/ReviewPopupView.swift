//
//  ReviewPopupView.swift
//  Khawi
//
//  Created by Karim Amsha on 27.10.2023.
//

import SwiftUI
import CTRating

struct ReviewPopupView: View {
    @State private var note = ""
    @StateObject var settings: UserSettings
    @StateObject private var router: MainRouter
    
    init(settings: UserSettings, router: MainRouter) {
        _settings = StateObject(wrappedValue: settings)
        _router = StateObject(wrappedValue: router)
    }

    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            AsyncImage(url: settings.myUser.image?.toURL()) { phase in
                switch phase {
                case .empty:
                    ProgressView() // Placeholder while loading
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60)
                        .clipShape(Circle()) // Clip the image to a circle
                case .failure:
                    Image(systemName: "photo.circle") // Placeholder for failure
                        .imageScale(.large)
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 60, height: 60)
            .clipShape(Circle())
            .background(Circle().foregroundColor(.white).padding(4).overlay(Circle().stroke(Color.primary(), lineWidth: 2))
            )

            VStack(alignment: .center, spacing: 0) {
                Text(settings.myUser.name ?? "")
                    .customFont(weight: .book, size: 16)
                    .foregroundColor(.black141F1F())
                CTRating(maxRating: 5,
                         currentRating: Binding.constant(0),
                         width: 21,
                         color: UIColor(Color.primary()),
                         openSFSymbol: "star",
                         fillSFSymbol: "star.fill")
            }
            
            CustomTextField(text: $note, placeholder: LocalizedStringKey.addOptionalNotes, textColor: .black4E5556(), placeholderColor: .grayA4ACAD())

            Button {
                router.dismiss()
            } label: {
                Text(LocalizedStringKey.addReview)
            }
            .buttonStyle(PrimaryButton(fontSize: 18, fontWeight: .book, background: .primary(), foreground: .white, height: 48, radius: 12))
            .padding(.top, 10)
        }
        .padding(.horizontal, 24)
        .padding(.top, 24)
        .padding(.bottom, 44)
        .ignoresSafeArea()
        .background(.white)
        .cornerRadius(16, corners: [.topLeft, .topRight])
    }
}

#Preview {
    ReviewPopupView(settings: UserSettings(), router: MainRouter(isPresented: .constant(.main)))
}
