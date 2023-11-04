//
//  DeliveryOfferView.swift
//  Khawi
//
//  Created by Karim Amsha on 26.10.2023.
//

import SwiftUI

struct DeliveryOfferView: View {
    @State var minPrice = ""
    @State var maxPrice = ""
    @EnvironmentObject var appState: AppState
    @StateObject private var router: MainRouter
    
    init(router: MainRouter) {
        _router = StateObject(wrappedValue: router)
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 12) {
                    HStack(spacing: 16) {
                        CustomTextField(text: $minPrice, placeholder: LocalizedStringKey.minPrice, textColor: .black4E5556(), placeholderColor: .grayA4ACAD())
                        CustomTextField(text: $maxPrice, placeholder: LocalizedStringKey.maxPrice, textColor: .black4E5556(), placeholderColor: .grayA4ACAD())
                    }
                    
                    CustomTextField(text: $maxPrice, placeholder: LocalizedStringKey.addOptionalNotes, textColor: .black4E5556(), placeholderColor: .grayA4ACAD())
                    
                    Spacer()

                    Button {
                        router.replaceNavigationStack(path: [])
                        router.presentToastPopup(view: .deliverySuccess)
                    } label: {
                        Text(LocalizedStringKey.makeDeliveryOffer)
                    }
                    .buttonStyle(PrimaryButton(fontSize: 18, fontWeight: .book, background: .primary(), foreground: .white, height: 48, radius: 12))
                    .padding(.top, 10)
                }
                .frame(minWidth: geometry.size.width)
                .frame(minHeight: geometry.size.height)
            }
        }
        .padding(24)
        .navigationTitle("")
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(LocalizedStringKey.deliveryOffer)
                        .customFont(weight: .book, size: 20)
                      .foregroundColor(Color.black141F1F())
                }
            }
        }
    }
}

#Preview {
    DeliveryOfferView(router: MainRouter(isPresented: .constant(.main)))
        .environmentObject(AppState())
}
