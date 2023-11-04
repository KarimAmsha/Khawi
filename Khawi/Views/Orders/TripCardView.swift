//
//  TripCardView.swift
//  Khawi
//
//  Created by Karim Amsha on 25.10.2023.
//

import SwiftUI
import MapKit

struct TripCardView: View {
    let trip: Trip
    
    var body: some View {
        ZStack {
            Text(trip.status?.value ?? "")
                .customFont(weight: .book, size: 10)
                .foregroundColor(trip.status == .opened ? Color.blue0094FF() : trip.status == .completed ? .green0CB057() : .redFF3F3F())
                .padding(.horizontal, trip.status == .opened ? 12 : trip.status == .completed ? 25 : 27)
                .padding(.vertical, 8)
                .background((trip.status == .opened ? Color.blue0094FF() : trip.status == .completed ? .green0CB057() : .redFF3F3F()).opacity(0.06).cornerRadius(12, corners: [.topLeft, .bottomRight]))
                .offset(x: 150, y: -60)

            Image(systemName: "arrow.left.circle.fill")
                .resizable()
                .frame(width: 28, height: 28)
                .foregroundStyle(Color.black666666(), Color.grayE8E8E8())
                .offset(x: 150, y: 30)


            HStack {
                AsyncImage(url: trip.imageURL) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 113, height: 118)
                            .clipped()
                            .cornerRadius(12) // Apply corner radius
                    case .failure(_):
                        Image(systemName: "xmark.octagon")
                            .resizable()
                            .frame(width: 113, height: 118)
                            .foregroundColor(.red)
                            .cornerRadius(12) // Apply corner radius
                    case .empty:
                        ProgressView()
                    @unknown default:
                        EmptyView()
                    }
                }
                
                VStack(alignment: .leading) {
                    Text(trip.date ?? "")
                        .customFont(weight: .book, size: 10)
                        .foregroundColor(.gray898989())
                    Text("\(trip.tripNumber ?? "") :\(LocalizedStringKey.tripNumber)")
                        .customFont(weight: .book, size: 12)
                        .foregroundColor(.black141F1F())
                    HStack(spacing: 12) {
                        HStack(spacing: 4) {
                            Text(":\(LocalizedStringKey.from)")
                                .foregroundColor(.black141F1F())
                            Text(trip.fromDestination ?? "")
                                .foregroundColor(.blue288599())
                        }
                        HStack(spacing: 4) {
                            Text(":\(LocalizedStringKey.to)")
                                .foregroundColor(.black141F1F())
                            Text(trip.toDestination ?? "")
                                .foregroundColor(.blue288599())
                        }
                    }
                    .customFont(weight: .book, size: 12)
                    Text(trip.price ?? "")
                        .customFont(weight: .book, size: 12)
                        .foregroundColor(.primary())
                }
                .padding(.leading)
                
                Spacer()
            }
        }
        .padding()
        .background(Color.grayF9FAFA())
        .cornerRadius(12)
        .padding(.horizontal, 24)
        .padding(.vertical, 8)
    }
}

#Preview {
    TripCardView(trip: Trip(
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
    ))
}
