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
    let item: Order
    @StateObject private var router: MainRouter
    
    init(settings: UserSettings, order: Order, router: MainRouter) {
        _settings = StateObject(wrappedValue: settings)
        item = order
        _router = StateObject(wrappedValue: router)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading) {
                HStack {
                    VStack {
                        AsyncImage(url: item.user?.image?.toURL()) { phase in
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
                        Text(item.user?.full_name ?? "")
                            .customFont(weight: .book, size: 20)
                            .foregroundColor(.black141F1F())
                        Text(item.type?.value ?? "")
                            .customFont(weight: .book, size: 14)
                            .foregroundColor(.primary())
                    }
                    
                    Spacer()
                    
                    Button {
                        router.dismiss() 
                        router.presentViewSpec(viewSpec: .deliveryRequestOrderDetailsView(item.id ?? ""))
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
                            Text(item.f_address ?? "")
                                .foregroundColor(.blue288599())
                        }
                        HStack(spacing: 4) {
                            Text(":\(LocalizedStringKey.to)")
                                .foregroundColor(.black141F1F())
                            Text(item.t_address ?? "")
                                .foregroundColor(.blue288599())
                        }
                    }
                    .customFont(weight: .book, size: 12)
                    
                    HStack(spacing: 16) {
                        VStack(alignment: .leading) {
                            Text(LocalizedStringKey.tripDate)
                                .customFont(weight: .book, size: 11)
                                .foregroundColor(.grayA4ACAD())
                            Text(item.dt_time ?? "")
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
                            Text(item.formattedDate ?? "")
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
    DeliveryPopupView(settings: UserSettings(), order: Order(id: nil, loc: nil, days: nil, passengers: nil, title: nil, f_lat: nil, f_lng: nil, t_lat: nil, t_lng: nil, max_price: nil, min_price: nil, price: nil, f_address: nil, t_address: nil, order_no: nil, tax: nil, totalDiscount: nil, netTotal: nil, status: nil, createAt: nil, dt_date: nil, dt_time: nil, is_repeated: nil, couponCode: nil, paymentType: nil, orderType: nil, max_passenger: nil, offers: nil, user: nil, notes: nil, canceled_note: nil), router: MainRouter(isPresented: .constant(.main)))
}
