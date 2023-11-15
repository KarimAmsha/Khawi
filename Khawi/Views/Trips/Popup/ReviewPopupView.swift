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
    @State private var currentRating = 0
    let order: Order
    @StateObject var settings: UserSettings
    @StateObject private var router: MainRouter
    @StateObject private var viewModel = UserViewModel(errorHandling: ErrorHandling())
    
    init(order: Order, settings: UserSettings, router: MainRouter) {
        self.order = order
        _settings = StateObject(wrappedValue: settings)
        _router = StateObject(wrappedValue: router)
    }

    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            let offerUser = order.offers?.first(where: { $0.status == "accept_offer" })?.user
            let user = order.type == .joining ? order.user : offerUser
                
            AsyncImage(url: user?.image?.toURL()) { phase in
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
                Text(user?.full_name ?? "")
                    .customFont(weight: .book, size: 16)
                    .foregroundColor(.black141F1F())
                CTRating(maxRating: 5,
                         currentRating: $currentRating,
                         width: 21,
                         color: UIColor(Color.primary()),
                         openSFSymbol: "star",
                         fillSFSymbol: "star.fill")
            }
            
            CustomTextField(text: $note, placeholder: LocalizedStringKey.addOptionalNotes, textColor: .black4E5556(), placeholderColor: .grayA4ACAD())
                .disabled(viewModel.isLoading)

            if viewModel.isLoading {
                LoadingView()
            }

            Button {
                addReview()
            } label: {
                Text(LocalizedStringKey.addReview)
            }
            .buttonStyle(PrimaryButton(fontSize: 18, fontWeight: .book, background: .primary(), foreground: .white, height: 48, radius: 12))
            .disabled(viewModel.isLoading)
            .padding(.top, 10)
        }
        .padding(.horizontal, 24)
        .padding(.top, 24)
        .padding(.bottom, 44)
        .ignoresSafeArea()
        .background(.white)
        .cornerRadius(16, corners: [.topLeft, .topRight])
        .onChange(of: viewModel.errorMessage) { errorMessage in
            if let errorMessage = errorMessage {
                router.presentToastPopup(view: .error("", errorMessage))
            }
        }
    }
}

#Preview {
    ReviewPopupView(order: Order(id: nil, loc: nil, days: nil, passengers: nil, title: nil, f_lat: nil, f_lng: nil, t_lat: nil, t_lng: nil, max_price: nil, min_price: nil, price: nil, f_address: nil, t_address: nil, order_no: nil, tax: nil, totalDiscount: nil, netTotal: nil, status: nil, createAt: nil, dt_date: nil, dt_time: nil, is_repeated: nil, couponCode: nil, paymentType: nil, orderType: nil, max_passenger: nil, offers: nil, user: nil, notes: nil, canceled_note: nil), settings: UserSettings(), router: MainRouter(isPresented: .constant(.main)))
}

extension ReviewPopupView {
    private func addReview() {
        let params: [String: Any] = [
            "rate_from_user": currentRating,
            "note_from_user": note
        ]
        
        print("ssss \(order.id)")
        viewModel.addReview(orderID: order.id ?? "", params: params) { message in
            showMessage(message: message)
        }
    }
    
    func showMessage(message: String) {
        let alertModel = AlertModel(
            title: "",
            message: message,
            hideCancelButton: true,
            onOKAction: {
                router.dismiss()
            },
            onCancelAction: {
                router.dismiss()
            }
        )
        
        router.presentToastPopup(view: .alert(alertModel))
    }
}
