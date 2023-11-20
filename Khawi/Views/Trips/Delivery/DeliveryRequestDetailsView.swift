//
//  DeliveryRequestDetailsView.swift
//  Khawi
//
//  Created by Karim Amsha on 26.10.2023.
//

import SwiftUI
import CTRating
import MapKit

struct DeliveryRequestDetailsView: View {
    @StateObject var settings: UserSettings
    let orderID: String

    let weekDays: [String] = {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ar")
        return calendar.shortWeekdaySymbols
    }()
    @StateObject private var router: MainRouter
    @StateObject private var viewModel = OrdersViewModel(initialRegion: MKCoordinateRegion(), errorHandling: ErrorHandling())
    private let errorHandling = ErrorHandling()
    @State private var userLocation: CLLocationCoordinate2D? = nil
    @StateObject var userViewModel = UserViewModel(errorHandling: ErrorHandling())
    @State private var driverLocation: CLLocationCoordinate2D?

    init(settings: UserSettings, orderID: String, router: MainRouter) {
        _settings = StateObject(wrappedValue: settings)
        self.orderID = orderID
        _router = StateObject(wrappedValue: router)
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    if viewModel.isLoading {
                        LoadingView()
                    }

                    VStack(alignment: .leading) {
                        HStack {
                            Text(viewModel.order?.formattedCreatedDate ?? "")
                                .customFont(weight: .book, size: 12)
                                .foregroundColor(.gray898989())
                            Spacer()
                            Text(viewModel.order?.displayedOrderStatus?.displayedValue ?? "")
                                .customFont(weight: .bold, size: 10)
                                .foregroundColor(.blue0094FF())
                                .padding(.horizontal, 30)
                                .padding(.vertical, 7)
                                .background(Color.blue0094FF().opacity(0.06).cornerRadius(12))
                        }
                        Text("\(viewModel.order?.title ?? "") :\(LocalizedStringKey.tripTitle)")
                            .customFont(weight: .bold, size: 16)
                            .foregroundColor(.black141F1F())
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 4) {
                                Text(":\(LocalizedStringKey.from)")
                                    .foregroundColor(.black141F1F())
                                Text(viewModel.order?.f_address ?? "")
                                    .foregroundColor(.blue288599())
                            }
                            HStack(spacing: 4) {
                                Text(":\(LocalizedStringKey.to)")
                                    .foregroundColor(.black141F1F())
                                Text(viewModel.order?.t_address ?? "")
                                    .foregroundColor(.blue288599())
                            }
                        }
                        .customFont(weight: .book, size: 14)
                        
                        Button {
                            if let order = viewModel.order {
                                router.presentViewSpec(viewSpec: .showOnMap(order, driverLocation))
                            }
                        } label: {
                            Text(LocalizedStringKey.showOnMap)
                                .customFont(weight: .book, size: 12)
                        }
                        .buttonStyle(CustomButtonStyle())
                    }
                    
                    if let order = viewModel.order, order.user?._id == settings.id, let offers = order.offers, !offers.isEmpty {
                        let acceptedOffers = offers.filter { $0.status == "accept_offer" }
                        let otherOffers = offers.filter { $0.status != "accept_offer" }

                            if !acceptedOffers.isEmpty {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text(LocalizedStringKey.acceptedOffers)
                                        .customFont(weight: .book, size: 14)
                                        .foregroundColor(.gray4E5556())
                                    
                                    // Show accepted offers
                                    ScrollView(showsIndicators: false) {
                                        ForEach(acceptedOffers, id: \.self) { item in
                                            RequestsRowView(item: item, type: .delivery, settings: settings, onSelectDetails: {
                                                if let order = viewModel.order {
                                                    router.presentViewSpec(viewSpec: .showOfferDetails(order, item))
                                                }
                                            }, onSelectAttend: {
                                                updateOfferStatus(offer: item, status: .attend)
                                            }, onSelectNotAttend: {
                                                updateOfferStatus(offer: item, status: .notAttend)
                                            })
                                        }
                                    }
                                }
                            }

                            // Show other offers
                            if !otherOffers.isEmpty {
                                CustomDivider()
                                VStack(alignment: .leading, spacing: 16) {
                                    Text(LocalizedStringKey.deliveryOffers)
                                        .customFont(weight: .book, size: 14)
                                        .foregroundColor(.gray4E5556())
                                    
                                    ScrollView(showsIndicators: false) {
                                        ForEach(otherOffers, id: \.self) { item in
                                            RequestsRowView(item: item, type: .delivery, settings: settings, onSelectDetails: {
                                                if let order = viewModel.order {
                                                    router.presentViewSpec(viewSpec: .showOfferDetails(order, item))
                                                }
                                            }, onSelectAttend: {
                                                updateOfferStatus(offer: item, status: .attend)
                                            }, onSelectNotAttend: {
                                                updateOfferStatus(offer: item, status: .notAttend)
                                            })
                                        }
                                    }
                                }
                            }
                    }
                                        
                    HStack(spacing: 16) {
                        VStack(alignment: .leading) {
                            Text(LocalizedStringKey.tripDate)
                                .customFont(weight: .book, size: 11)
                                .foregroundColor(.grayA4ACAD())
                            Text(viewModel.order?.dt_time ?? "")
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
                            Text(viewModel.order?.formattedDate ?? "")
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
                        Text(LocalizedStringKey.price)
                            .customFont(weight: .book, size: 11)
                            .foregroundColor(.grayA4ACAD())
                        Text("\(LocalizedStringKey.sar) \(viewModel.order?.price?.toString() ?? "")")
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

                                        if viewModel.order?.days?.contains(day) ?? false {
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
                                        
                    VStack(alignment: .leading, spacing: 16) {
                        Text(LocalizedStringKey.personInformations)
                            .customFont(weight: .book, size: 14)
                            .foregroundColor(.gray4E5556())
                        
                        HStack {
                            AsyncImage(url: viewModel.order?.user?.image?.toURL()) { phase in
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
                                Text(viewModel.order?.user?.full_name ?? "")
                                    .customFont(weight: .book, size: 16)
                                    .foregroundColor(.black141F1F())
                                CTRating(maxRating: 5,
                                         currentRating: Binding.constant(Int(viewModel.order?.user?.rate ?? 0.0)),
                                         width: 14,
                                         color: UIColor(Color.primary()),
                                         openSFSymbol: "star",
                                         fillSFSymbol: "star.fill")
                            }
                            
                            Spacer()
                            
                            if let order = viewModel.order,
                               order.orderStatus == .finished,
                               let orderID = order._id,
                               let userID = order.user?._id,
                               userID == settings.id {

                                Button {
                                    // Use orderID in review
                                    router.replaceNavigationStack(path: [])
                                    router.presentToastPopup(view: .review(order))
                                } label: {
                                    Text(LocalizedStringKey.addReview)
                                        .customFont(weight: .book, size: 12)
                                        .padding(.horizontal)
                                }
                                .buttonStyle(CustomButtonStyle())
                            }
                        }
                    }
            
                    if let order = viewModel.order,
                       order.orderStatus == .accepted,
                       let acceptedOffer = order.offers?.first(where: {$0.status == "accept_offer" }),
                       let acceptedUser = acceptedOffer.user {
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text(LocalizedStringKey.driverInformations)
                                .customFont(weight: .book, size: 14)
                                .foregroundColor(.gray4E5556())
                            
                            HStack {
                                AsyncImage(url: acceptedUser.image?.toURL()) { phase in
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
                                    Text(acceptedUser.full_name ?? "")
                                        .customFont(weight: .book, size: 16)
                                        .foregroundColor(.black141F1F())
                                    CTRating(maxRating: 5,
                                             currentRating: Binding.constant(Int(acceptedUser.rate ?? 0.0)),
                                             width: 14,
                                             color: UIColor(Color.primary()),
                                             openSFSymbol: "star",
                                             fillSFSymbol: "star.fill")
                                }
                            }
                                
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
                                            Text(acceptedUser.carType ?? "")
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
                                            Text(acceptedUser.carModel ?? "")
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
                                            Text(acceptedUser.carColor ?? "")
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
                                            Text(acceptedUser.carNumber ?? "")
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
                        }
                    }
 
                    VStack(alignment: .leading) {
                        Text(LocalizedStringKey.numberOfRequiredSeats)
                            .customFont(weight: .book, size: 11)
                            .foregroundColor(.grayA4ACAD())
                        Text("\(LocalizedStringKey.seats) \(viewModel.order?.max_passenger?.toString() ?? "")")
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
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text(LocalizedStringKey.notes)
                            .customFont(weight: .book, size: 14)
                            .foregroundColor(.gray4E5556())
                        
                        VStack(alignment: .leading) {
                            Text(viewModel.order?.notes ?? "")
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
                    
                    HStack {
                        // Check if there is a valid order, user, and offers
                        if let order = viewModel.order, let user = order.user, let offers = order.offers {
                            // Check if the current user is the order owner
                            if settings.id == user._id {
                                // My order
                                if order.orderStatus == .new || order.orderStatus == .accepted {
                                    // Handle canceled status by User
                                    Button {
                                        presentCancellationReasonPopup(status: .canceledByUser)
                                    } label: {
                                        Text(LocalizedStringKey.cancel)
                                    }
                                    .buttonStyle(PrimaryButton(fontSize: 18, fontWeight: .book, background: .primary(), foreground: .white, height: 48, radius: 12))
                                }
                            } else {
                                // Check if the current user has existing offers
                                let userHasOffer = offers.contains { $0.user?._id == settings.id }
                                
                                if !userHasOffer {
                                    // Present the "Make Delivery Offer" button
                                    Button {
                                        router.presentViewSpec(viewSpec: .deliveryOfferView(order))
                                    } label: {
                                        Text(LocalizedStringKey.makeDeliveryOffer)
                                    }
                                    .buttonStyle(PrimaryButton(fontSize: 18, fontWeight: .book, background: .primary(), foreground: .white, height: 48, radius: 12))
                                    .padding(.top, 10)
                                } else {
                                    if let currentUserOffer = offers.first(where: { $0.user?._id == settings.id && $0.status == "accept_offer" }) {
                                        if order.orderStatus == .accepted {
                                            // Handle started status
                                            Button {
                                                updateOrderStatus(status: .started)
                                                fetchAndTrackingDriverLocation()
                                            } label: {
                                                Text(LocalizedStringKey.start)
                                            }
                                            .buttonStyle(PrimaryButton(fontSize: 18, fontWeight: .book, background: .green0CB057(), foreground: .white, height: 48, radius: 12))
                                        } else if order.orderStatus == .started {
                                            // Handle finished status
                                            Button {
                                                updateOrderStatus(status: .finished)
                                                deleteAndstopUpdateDriverLocation()
                                            } label: {
                                                Text(LocalizedStringKey.finish)
                                            }
                                            .buttonStyle(PrimaryButton(fontSize: 18, fontWeight: .book, background: .redFF3F3F(), foreground: .white, height: 48, radius: 12))
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .frame(minWidth: geometry.size.width)
            }
        }
        .padding(24)
        .navigationTitle("")
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(LocalizedStringKey.orderDetails)
                        .customFont(weight: .book, size: 20)
                      .foregroundColor(Color.black141F1F())
                }
            }
        }
        .onAppear {
            getOrderDetails()
            fetchAndTrackingDriverLocation()
            observeDriverLocation()
        }
        .onChange(of: viewModel.errorMessage) { errorMessage in
            if let errorMessage = errorMessage {
                router.presentToastPopup(view: .error("", errorMessage))
            }
        }
    }
}

#Preview {
    DeliveryRequestDetailsView(settings: UserSettings(), orderID: "", router: MainRouter(isPresented: .constant(.main)))
}

extension DeliveryRequestDetailsView {
    func getOrderDetails() {
        viewModel.getOrderDetails(orderId: orderID) {
            //
        }
    }
}

extension DeliveryRequestDetailsView {
    func updateOrderStatus(status: OrderStatus, canceledNote: String = "") {
        let params: [String: Any] = [
            "status": status.rawValue,
            "canceled_note": canceledNote
        ]
        
        viewModel.updateOrderStatus(orderId: orderID, params: params, onsuccess: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                getOrderDetails()
            })
        })
    }
    
    private func presentCancellationReasonPopup(status: OrderStatus) {
        let alertModel = AlertModelWithInput(
            title: LocalizedStringKey.logout,
            content: LocalizedStringKey.description,
            hideCancelButton: false,
            onOKAction: { content in
                updateOrderStatus(status: status, canceledNote: content)
                router.dismiss()
            },
            onCancelAction: {
                router.dismiss()
            }
        )
        
        router.presentToastPopup(view: .inputAlert(alertModel))
    }
}

extension DeliveryRequestDetailsView {
    func updateOfferStatus(offer: Offer, status: OfferStatus) {
        let params: [String: Any] = [
            "offer": offer.id ?? "",
            "status": status.rawValue
        ]
        
        viewModel.updateOfferStatus(orderId: orderID, params: params, onsuccess: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                getOrderDetails()
            })
        })
    }
    
    private func fetchAndTrackingDriverLocation() {
        if let order = viewModel.order,
           let acceptedOffer = order.offers?.first(where: { $0.user?._id == settings.id && $0.status == "accept_offer" }),
           let acceptedUserId = acceptedOffer.user?._id {
            LocationManager.shared.getCurrentLocation { location in
                if let location = location {
                    userLocation = location
                    userViewModel.trackingUserLocation(item: Tracking(orderId: orderID, userId: settings.id ?? "", status: viewModel.order?.orderStatus?.rawValue ?? "", lat: location.latitude, lng: location.longitude, lastUpdate: Date().toMillis()))
                } else {
                    print("Failed to get the user's location")
                }
            }
        }
    }
    
    private func deleteAndstopUpdateDriverLocation() {
        if let order = viewModel.order,
           let acceptedOffer = order.offers?.first(where: { $0.user?._id == settings.id && $0.status == "accept_offer" }),
           let acceptedUserId = acceptedOffer.user?._id {
            userViewModel.deleteUserLocation(id: orderID)
            LocationManager.shared.stopUpdatingLocation()
        }
    }
    
    func observeDriverLocation() {
        if !orderID.isEmpty {
            userViewModel.observeDriverLocation(orderID: orderID) { tracking in
                self.driverLocation = CLLocationCoordinate2D(latitude: tracking.lat, longitude: tracking.lng)
            }
        }
    }
}
