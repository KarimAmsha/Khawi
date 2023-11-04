//
//  DeliveryPopupView.swift
//  Khawi
//
//  Created by Karim Amsha on 25.10.2023.
//

import SwiftUI
import MapKit

struct DeliveryPopupView: View {
    @StateObject var settings: UserSettings
    let item: Trip
    @StateObject private var router: MainRouter
    
    init(settings: UserSettings, trip: Trip, router: MainRouter) {
        _settings = StateObject(wrappedValue: settings)
        item = trip
        _router = StateObject(wrappedValue: router)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading) {
                HStack {
                    VStack {
                        AsyncImage(url: settings.myUser.image?.toURL()) { phase in
                            switch phase {
                            case .empty:
                                ProgressView() // Placeholder while loading
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 32, height: 32)
                                    .clipShape(Circle()) // Clip the image to a circle
                            case .failure:
                                Image(systemName: "photo.circle") // Placeholder for failure
                                    .imageScale(.large)
                                    .foregroundColor(.gray)
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .frame(width: 32, height: 32)
                        .clipShape(Circle())
                        .background(Circle().foregroundColor(.white).padding(4).overlay(Circle().stroke(Color.primary(), lineWidth: 2))
                        )
                        Spacer()
                            .frame(maxHeight: 20)
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text(settings.myUser.name ?? "")
                            .customFont(weight: .book, size: 20)
                            .foregroundColor(.black141F1F())
                        Text(item.type?.value ?? "")
                            .customFont(weight: .book, size: 14)
                            .foregroundColor(.primary())
                    }
                    
                    Spacer()
                    
                    Button {
                        router.dismiss() 
                        router.presentViewSpec(viewSpec: .deliveryRequestOrderDetailsView)
                    } label: {
                        Text(LocalizedStringKey.showDetails)
                            .customFont(weight: .book, size: 12)
                    }
                    .buttonStyle(CustomButtonStyle())
                }

                VStack(alignment: .leading) {
                    HStack(spacing: 12) {
                        HStack(spacing: 4) {
                            Text(":\(LocalizedStringKey.from)")
                                .foregroundColor(.black141F1F())
                            Text(item.fromDestination ?? "")
                                .foregroundColor(.blue288599())
                        }
                        HStack(spacing: 4) {
                            Text(":\(LocalizedStringKey.to)")
                                .foregroundColor(.black141F1F())
                            Text(item.toDestination ?? "")
                                .foregroundColor(.blue288599())
                        }
                    }
                    .customFont(weight: .book, size: 12)
                    
                    HStack(spacing: 16) {
                        VStack(alignment: .leading) {
                            Text(LocalizedStringKey.tripDate)
                                .customFont(weight: .book, size: 11)
                                .foregroundColor(.grayA4ACAD())
                            Text("07:30 صباحاً")
                                .customFont(weight: .book, size: 14)
                                .foregroundColor(.black141F1F())
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12)
                        .background(Color.grayF9FAFA())
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.grayE6E9EA(), lineWidth: 1)
                        )

                        VStack(alignment: .leading) {
                            Text(LocalizedStringKey.dateOfTheFirstTrip)
                                .customFont(weight: .book, size: 11)
                                .foregroundColor(.grayA4ACAD())
                            Text("15 ربيع الأول، 1445")
                                .customFont(weight: .book, size: 14)
                                .foregroundColor(.black141F1F())
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12)
                        .background(Color.grayF9FAFA())
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.grayE6E9EA(), lineWidth: 1)
                        )
                    }
                }
            }
            .padding(.horizontal, 24)
        }
        .padding(.top, 24)
        .padding(.bottom, 44)
        .ignoresSafeArea()
        .background(.white)
        .cornerRadius(16, corners: [.topLeft, .topRight])
    }
}

#Preview {
    DeliveryPopupView(settings: UserSettings(), trip: Trip(
        tripNumber: "#12549",
        imageURL: URL(string: "https://hips.hearstapps.com/hmg-prod/images/2022-gr86-premium-trackbred-002-1628887849.jpg?crop=0.689xw:0.517xh;0.242xw,0.238xh&resize=1200:*")!,
        date: "2023-11-10",
        status: .canceled,
        fromDestination: "الدمام",
        toDestination: "جدة",
        price: "40 ر.س",
        title: "الرحلة 9",
        coordinate: CLLocationCoordinate2D(latitude: 24.7976, longitude: 46.6873),
        type: .deliveryRequest
    ), router: MainRouter(isPresented: .constant(.main)))
}
