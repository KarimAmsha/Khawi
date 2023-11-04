//
//  WelcomeView.swift
//  Khawi
//
//  Created by Karim Amsha on 20.10.2023.
//

import SwiftUI

struct WelcomeView: View {
    @State private var currentPage = 0
    @State private var showNextView = false
    @State private var items: [WelcomeItem] = [
        WelcomeItem(imageName: "slider1", titleKey: LocalizedStringKey.shareYourPathWithOthers, descriptionKey: LocalizedStringKey.descriptionKey),
        WelcomeItem(imageName: "slider2", titleKey: LocalizedStringKey.gettingToYourDestinationIsEasier, descriptionKey: LocalizedStringKey.descriptionKey),
        WelcomeItem(imageName: "slider3", titleKey: LocalizedStringKey.investYourCar, descriptionKey: LocalizedStringKey.descriptionKey)
    ]
    @EnvironmentObject var languageManager: LanguageManager

    var body: some View {
        NavigationStack {
            VStack {
                TabView(selection: $currentPage) {
                    ForEach(0..<items.count, id: \.self) { index in
                        WelcomeSlideView(item: items[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))

                WelcomeControlDots(numberOfPages: items.count, currentPage: $currentPage)
                    .padding(.top, 20)

                Button(action: {
                    if currentPage < items.count - 1 {
                        currentPage += 1 // Go to the next slide
                    } else if currentPage == items.count - 1 {
                        showNextView = true
                    }
                }) {
                    Text(currentPage == items.count - 1 ? LocalizedStringKey.createNewAccount : LocalizedStringKey.next)
                }
                .buttonStyle(PrimaryButton(fontSize: 18, fontWeight: .book, background: .primary(), foreground: .white, height: 48, radius: 12))
                .padding(.horizontal, 24)
                .padding(.vertical, 24)
            }
            .navigationTitle("")
            .navigationDestination(isPresented: $showNextView) {
                RegisterView()
            }
        }
        .accentColor(.black141F1F())
    }
}

#Preview {
    WelcomeView()
        .environmentObject(LanguageManager())
}
