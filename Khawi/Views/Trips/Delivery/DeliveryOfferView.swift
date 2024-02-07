//
//  DeliveryOfferView.swift
//  Khawi
//
//  Created by Karim Amsha on 26.10.2023.
//

import SwiftUI
import MapKit

struct DeliveryOfferView: View {
    @State var price = ""
    @State var note = ""
    @EnvironmentObject var appState: AppState
    @StateObject private var router: MainRouter
    @StateObject private var ordersViewModel = OrdersViewModel(initialRegion: MKCoordinateRegion(), errorHandling: ErrorHandling())
    var order: Order?

    init(order: Order?, router: MainRouter) {
        self.order = order
        _router = StateObject(wrappedValue: router)
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 6) {
                        CustomTextField(text: $price, placeholder: LocalizedStringKey.price, textColor: .black4E5556(), placeholderColor: .grayA4ACAD())
                            .keyboardType(.numberPad)
                            .disabled(ordersViewModel.isLoading)
//                        Text(" \(order?.min_price?.toString() ?? "") - \(order?.max_price?.toString() ?? "") \(LocalizedStringKey.rangeOfPrice)")
//                            .customFont(weight: .book, size: 12)
//                            .foregroundColor(.primary())
                    }

                    CustomTextField(text: $note, placeholder: LocalizedStringKey.addOptionalNotes, textColor: .black4E5556(), placeholderColor: .grayA4ACAD())
                        .disabled(ordersViewModel.isLoading)

                    Spacer()

                    // Show a loader while creating
                    if ordersViewModel.isLoading {
                        LoadingView()
                    }

                    Button {
                        addOffer()
                    } label: {
                        Text(LocalizedStringKey.makeDeliveryOffer)
                    }
                    .buttonStyle(PrimaryButton(fontSize: 18, fontWeight: .book, background: .primary(), foreground: .white, height: 48, radius: 12))
                    .padding(.top, 10)
                    .disabled(ordersViewModel.isLoading)
                }
                .frame(minWidth: geometry.size.width)
                .frame(minHeight: geometry.size.height)
            }
        }
        .padding(24)
        .navigationTitle("")
        .dismissKeyboard()
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(LocalizedStringKey.deliveryOffer)
                        .customFont(weight: .book, size: 20)
                      .foregroundColor(Color.black141F1F())
                }
            }
        }
        .onChange(of: ordersViewModel.errorMessage) { errorMessage in
            if let errorMessage = errorMessage {
                router.presentToastPopup(view: .error("", errorMessage, .error))
            }
        }
    }
}

#Preview {
    DeliveryOfferView(order: nil, router: MainRouter(isPresented: .constant(.main)))
        .environmentObject(AppState())
}

extension DeliveryOfferView {
    func addOffer() {
        guard let order = order else {
            // Handle the case where order is nil
            return
        }

        var params: [String: Any] = [
            "f_address": order.f_address ?? "",
            "t_address": order.t_address ?? "",
            "f_lat": order.f_lat ?? "",
            "f_lng": order.f_lng ?? "",
            "t_lat": order.t_lat ?? "",
            "t_lng": order.t_lng ?? "",
            "dt_date": order.dt_date ?? "",
            "dt_time": order.dt_time ?? ""
        ]

        // Check and unwrap price and note before adding them to params
        if let priceValue = price.toInt() {
            params["price"] = priceValue
        }

        if let noteValue = note.toInt() {
            params["notes"] = noteValue
        }

        ordersViewModel.addOfferToOrder(orderId: order.id ?? "", params: params) { message in
            router.replaceNavigationStack(path: [])
            router.presentToastPopup(view: .deliverySuccess(order.id ?? "", message))
        }
    }
}
