//
//  RequestsRowView.swift
//  Khawi
//
//  Created by Karim Amsha on 28.10.2023.
//

import SwiftUI

struct RequestsRowView: View {
    @StateObject var settings: UserSettings
    @StateObject private var router: MainRouter

    init(settings: UserSettings, router: MainRouter) {
        _settings = StateObject(wrappedValue: settings)
        _router = StateObject(wrappedValue: router)
    }

    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: settings.myUser.image?.toURL()) { phase in
                switch phase {
                case .empty:
                    ProgressView() // Placeholder while loading
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle()) // Clip the image to a circle
                case .failure:
                    Image(systemName: "photo.circle") // Placeholder for failure
                        .imageScale(.large)
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 40, height: 40)
            .clipShape(Circle())
            .background(Circle().foregroundColor(.white).padding(4).overlay(Circle().stroke(Color.primary(), lineWidth: 2))
            )
            
            VStack(spacing: 6) {
                Text("أحمد علي")
                    .customFont(weight: .book, size: 16)
                    .foregroundColor(.black141F1F())
            }
            
            Spacer()
            
            Button {
                router.presentViewSpec(viewSpec: .showJoiningDetails)
            } label: {
                Text(LocalizedStringKey.showDetails)
                    .customFont(weight: .book, size: 12)
            }
            .buttonStyle(CustomButtonStyle())
        }
    }
}

#Preview {
    RequestsRowView(settings: UserSettings(), router: MainRouter(isPresented: .constant(.main)))
}
