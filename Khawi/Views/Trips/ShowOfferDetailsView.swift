//
//  ShowOfferDetailsView.swift
//  Khawi
//
//  Created by Karim Amsha on 28.10.2023.
//

import SwiftUI
import CTRating
import MapKit

struct ShowOfferDetailsView: View {
    @StateObject var settings: UserSettings
    let order: Order
    let offer: Offer

    let weekDays: [String] = {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ar")
        return calendar.shortWeekdaySymbols
    }()
    @StateObject private var router: MainRouter
    @StateObject private var viewModel = OrdersViewModel(initialRegion: MKCoordinateRegion(), errorHandling: ErrorHandling())

    init(order: Order, offer: Offer, settings: UserSettings, router: MainRouter) {
        self.order = order
        self.offer = offer
        _settings = StateObject(wrappedValue: settings)
        _router = StateObject(wrappedValue: router)
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(spacing: 12) {
                            AsyncImage(url: offer.user?.image?.toURL()) { phase in
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
                            
                            Text(offer.user?.full_name ?? "")
                                .customFont(weight: .book, size: 16)
                                .foregroundColor(.black141F1F())
                            
                            Spacer()
                        }
                        
                        HStack(spacing: 12) {
                            HStack(spacing: 4) {
                                Text(":\(LocalizedStringKey.from)")
                                    .foregroundColor(.black141F1F())
                                Text(offer.f_address ?? "")
                                    .foregroundColor(.blue288599())
                            }
                            HStack(spacing: 4) {
                                Text(":\(LocalizedStringKey.to)")
                                    .foregroundColor(.black141F1F())
                                Text(offer.t_address ?? "")
                                    .foregroundColor(.blue288599())
                            }
                        }
                        .customFont(weight: .book, size: 14)
                    }
                    
                    Button {
                        router.presentViewSpec(viewSpec: .showOfferOnMap(offer))
                    } label: {
                        Text(LocalizedStringKey.showOnMap)
                            .customFont(weight: .book, size: 12)
                    }
                    .buttonStyle(CustomButtonStyle())
                    
                    HStack(spacing: 16) {
                        VStack(alignment: .leading) {
                            Text(LocalizedStringKey.tripDate)
                                .customFont(weight: .book, size: 11)
                                .foregroundColor(.grayA4ACAD())
                            Text(offer.dt_time ?? "")
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
                            Text(offer.formattedDate ?? "")
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
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text(LocalizedStringKey.tripDays)
                            .customFont(weight: .book, size: 14)
                            .foregroundColor(.gray4E5556())
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(weekDays, id: \.self) { day in
                                    VStack(spacing: 15) {
                                        Text(day)
                                            .customFont(weight: .book, size: 12)
                                            .foregroundColor(.grayA4ACAD())

                                        if order.days?.contains(day) ?? false {
                                            Circle()
                                                .fill(Color.primary())
                                                .frame(width: 32, height: 32)
                                        } else {
                                            Image(systemName: "circle")
                                                .resizable()
                                                .frame(width: 32, height: 32)
                                                .foregroundStyle(Color.grayF9FAFA(), Color.grayE6E9EA())
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text(LocalizedStringKey.price)
                            .customFont(weight: .book, size: 11)
                            .foregroundColor(.grayA4ACAD())
                        Text("\(offer.price?.toString() ?? "") \(LocalizedStringKey.sar)")
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
                    
                    if order.type == .delivery {
                        VStack(alignment: .leading, spacing: 16) {
                            Text(LocalizedStringKey.carInformation)
                                .customFont(weight: .book, size: 14)
                                .foregroundColor(.gray4E5556())
                            
                            VStack(spacing: 12) {
                                HStack(spacing: 16) {
                                    VStack(alignment: .leading) {
                                        Text(LocalizedStringKey.carType)
                                            .customFont(weight: .book, size: 11)
                                            .foregroundColor(.grayA4ACAD())
                                        Text(offer.user?.carType ?? "")
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
                                        Text(LocalizedStringKey.carModel)
                                            .customFont(weight: .book, size: 11)
                                            .foregroundColor(.grayA4ACAD())
                                        Text(offer.user?.carModel ?? "")
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

                                HStack(spacing: 16) {
                                    VStack(alignment: .leading) {
                                        Text(LocalizedStringKey.carColor)
                                            .customFont(weight: .book, size: 11)
                                            .foregroundColor(.grayA4ACAD())
                                        Text(offer.user?.carColor ?? "")
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
                                        Text(LocalizedStringKey.carNumber)
                                            .customFont(weight: .book, size: 11)
                                            .foregroundColor(.grayA4ACAD())
                                        Text(offer.user?.carNumber ?? "")
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
                                
                                VStack(alignment: .leading) {
                                    Text(order.type == .delivery ? LocalizedStringKey.numberOfRequiredSeats : LocalizedStringKey.numberOfAvailableSeats)
                                        .customFont(weight: .book, size: 11)
                                        .foregroundColor(.grayA4ACAD())
                                    Text("\(LocalizedStringKey.seats) \(order.max_passenger?.toString() ?? "")")
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
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text(LocalizedStringKey.notes)
                            .customFont(weight: .book, size: 14)
                            .foregroundColor(.gray4E5556())
                        
                        VStack(alignment: .leading) {
                            Text(offer.notes ?? "")
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
                    
                    Spacer()
                    
                    if viewModel.isLoading {
                        LoadingView()
                    }

                    if order.user?._id == settings.id && offer.offerStatus == .addOffer {
                        HStack(spacing: 20) {
                            Button {
                                updateOfferStatus(status: .acceptOffer)
                            } label: {
                                Text(LocalizedStringKey.requestAccept)
                            }
                            .buttonStyle(PrimaryButton(fontSize: 18, fontWeight: .book, background: .green46CF85(), foreground: .white, height: 48, radius: 12))

                            Button {
                                updateOfferStatus(status: .rejectOffer)
                            } label: {
                                Text(LocalizedStringKey.requestReject)
                            }
                            .buttonStyle(PrimaryButton(fontSize: 18, fontWeight: .book, background: .redFF5B5B(), foreground: .white, height: 48, radius: 12))
                        }
                    }
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
                    Text(order.type == .joining ? LocalizedStringKey.joiningRequest : LocalizedStringKey.deliveryOffer)
                        .customFont(weight: .book, size: 20)
                      .foregroundColor(Color.black141F1F())
                }
            }
        }
        .onChange(of: viewModel.errorMessage) { errorMessage in
            if let errorMessage = errorMessage {
                router.presentToastPopup(view: .error("", errorMessage, .error))
            }
        }
    }
}

#Preview {
    ShowOfferDetailsView(order: Order(id: nil, loc: nil, days: nil, passengers: nil, title: nil, f_lat: nil, f_lng: nil, t_lat: nil, t_lng: nil, max_price: nil, min_price: nil, price: nil, f_address: nil, t_address: nil, order_no: nil, tax: nil, totalDiscount: nil, netTotal: nil, status: nil, createAt: nil, dt_date: nil, dt_time: nil, is_repeated: nil, couponCode: nil, paymentType: nil, orderType: nil, max_passenger: nil, offers: nil, user: nil, notes: nil, canceled_note: nil), offer: Offer(id: nil, user: nil, f_address: nil, t_address: nil, f_lat: nil, f_lng: nil, t_lat: nil, t_lng: nil, price: nil, notes: nil, dt_date: nil, dt_time: nil, status: nil), settings: UserSettings(), router: MainRouter(isPresented: .constant(.main)))
}

extension ShowOfferDetailsView {
    func updateOfferStatus(status: OfferStatus) {
        let params: [String: Any] = [
            "offer": offer.id ?? "",
            "status": status.rawValue
        ]
        
        viewModel.updateOfferStatus(orderId: order.id ?? "", params: params, onsuccess: {
            router.dismiss()
        })
    }
}
