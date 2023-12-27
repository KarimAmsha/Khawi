//
//  RequestsRowView.swift
//  Khawi
//
//  Created by Karim Amsha on 28.10.2023.
//

import SwiftUI
import CTRating

struct RequestsRowView: View {
    let item: Offer
    let type: OrderType
    let settings: UserSettings
    var onSelectAccept: () -> Void
    var onSelectReject: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 16) {
                AsyncImage(url: item.user?.image?.toURL()) { phase in
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
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(item.user?.full_name ?? "")
                        .customFont(weight: .book, size: 16)
                        .foregroundColor(.black141F1F())
                    CTRating(maxRating: 5,
                             currentRating: Binding.constant(Int(item.user?.rate ?? 0.0)),
                             width: 14,
                             color: UIColor(Color.primary()),
                             openSFSymbol: "star",
                             fillSFSymbol: "star.fill")
    //                if type == .joining && settings.id != item.user?._id {
    //                    HStack {
    //                        Button {
    //                            onSelectAttend()
    //                        } label: {
    //                            Text(LocalizedStringKey.attend)
    //                        }
    //                        .buttonStyle(PrimaryButton(fontSize: 11, fontWeight: .book, background: .green46CF85(), foreground: .white, height: 30, radius: 8))
    //
    //                        Button {
    //                            onSelectNotAttend()
    //                        } label: {
    //                            Text(LocalizedStringKey.notAttend)
    //                        }
    //                        .buttonStyle(PrimaryButton(fontSize: 11, fontWeight: .book, background: .redFF5B5B(), foreground: .white, height: 30, radius: 8))
    //                    }
    //                }
                }
                
                Spacer()
                
                if !(item.offerStatus == .acceptOffer) {
                    Button {
                        onSelectAccept()
                    } label: {
                        Text(LocalizedStringKey.requestAccept)
                    }
                    .buttonStyle(PrimaryButton(fontSize: 15, fontWeight: .book, background: .green46CF85(), foreground: .white, height: 35, radius: 8))

                    Button {
                        onSelectReject()
                    } label: {
                        Text(LocalizedStringKey.requestReject)
                    }
                    .buttonStyle(PrimaryButton(fontSize: 15, fontWeight: .book, background: .redFF5B5B(), foreground: .white, height: 35, radius: 8))
                }
            }

            if item.user?.hasCar ?? false {
                HStack(spacing: 0) {
                    Text(item.user?.carType ?? "")
                        .customFont(weight: .bold, size: 12)
                    Text("/")
                        .customFont(weight: .bold, size: 12)
                    Text(item.user?.carColor ?? "")
                        .customFont(weight: .bold, size: 12)
                    Text("/")
                        .customFont(weight: .bold, size: 12)
                    Text(item.user?.carModel ?? "")
                        .customFont(weight: .bold, size: 12)
                }
                .foregroundColor(.black141F1F())
            }
        }
    }
}

#Preview {
    RequestsRowView(item: Offer(id: nil, user: nil, f_address: nil, t_address: nil, f_lat: nil, f_lng: nil, t_lat: nil, t_lng: nil, price: nil, notes: nil, dt_date: nil, dt_time: nil, status: nil), type: .joining, settings: UserSettings(), onSelectAccept: {}, onSelectReject: {})
}
