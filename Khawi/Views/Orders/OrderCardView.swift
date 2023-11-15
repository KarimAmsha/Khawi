//
//  OrderCardView.swift
//  Khawi
//
//  Created by Karim Amsha on 25.10.2023.
//

import SwiftUI
import MapKit

struct OrderCardView: View {
    let item: Order?
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return formatter
    }
    
    var formattedDate: String {
        if let dateStr = item?.dt_date, let date = dateFormatter.date(from: dateStr) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MMM d, yyyy"
            return outputFormatter.string(from: date)
        }
        return ""
    }

    var body: some View {
        ZStack {
            Text(item?.displayedOrderStatus?.displayedValue ?? "")
                .customFont(weight: .book, size: 10)
                .foregroundColor(item?.orderStatus == .new ? Color.blue0094FF() : item?.orderStatus == .finished ? .green0CB057() : item?.orderStatus == .rated ? .green0CB057() : .redFF3F3F())
                .padding(.horizontal, item?.orderStatus == .new ? 12 : item?.orderStatus == .finished ? 25 : 27)
                .padding(.vertical, 8)
                .background((item?.orderStatus == .new ? Color.blue0094FF() : item?.orderStatus == .finished ? .green0CB057() : item?.orderStatus == .rated ? .green0CB057() : .redFF3F3F()).opacity(0.06).cornerRadius(12, corners: [.topLeft, .bottomRight]))
                .offset(x: 150, y: -60)

            Image(systemName: "arrow.left.circle.fill")
                .resizable()
                .frame(width: 28, height: 28)
                .foregroundStyle(Color.black666666(), Color.grayE8E8E8())
                .offset(x: 150, y: 30)


            HStack {
                AsyncImage(url: item?.user?.image?.toURL()) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 113, height: 118)
                            .clipped()
                            .cornerRadius(12) 
                    case .failure(_):
                        Image(systemName: "xmark.octagon")
                            .resizable()
                            .frame(width: 113, height: 118)
                            .foregroundColor(.red)
                            .cornerRadius(12)
                    case .empty:
                        ProgressView()
                    @unknown default:
                        EmptyView()
                    }
                }
                
                VStack(alignment: .leading) {
                    Text(formattedDate)
                        .customFont(weight: .book, size: 10)
                        .foregroundColor(.gray898989())
                    Text("\(item?.order_no ?? "") :\(LocalizedStringKey.tripNumber)")
                        .customFont(weight: .book, size: 12)
                        .foregroundColor(.black141F1F())
                    HStack(spacing: 12) {
                        HStack(spacing: 4) {
                            Text(":\(LocalizedStringKey.from)")
                                .foregroundColor(.black141F1F())
                            Text(cutOffAddress(address: item?.f_address ?? ""))
                                .foregroundColor(.blue288599())
                        }
                        HStack(spacing: 4) {
                            Text(":\(LocalizedStringKey.to)")
                                .foregroundColor(.black141F1F())
                            Text(cutOffAddress(address: item?.t_address ?? ""))
                                .foregroundColor(.blue288599())
                        }
                    }
                    .customFont(weight: .book, size: 12)
                    Text(item?.price?.toString() ?? "")
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
    
    func cutOffAddress(address: String) -> String {
        let maxLength = 5 // Adjust this to your desired maximum length
        if address.count > maxLength {
            return String(address.prefix(maxLength))
        } else {
            return address
        }
    }
}

#Preview {
    OrderCardView(item: nil)
}
