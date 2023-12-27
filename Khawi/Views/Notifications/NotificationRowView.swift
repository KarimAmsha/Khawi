//
//  NotificationRowView.swift
//  Khawi
//
//  Created by Karim Amsha on 25.10.2023.
//

import SwiftUI

struct NotificationRowView: View {
    let notification: NotificationItem

    var body: some View {
        VStack {
            if notification.notificationType == .panel {
                HStack(alignment: .firstTextBaseline, spacing: 17) {
                    Circle()
                        .frame(width: 8, height: 8)
                        .foregroundColor(.primary())
                    VStack(alignment: .leading) {
                        Text(notification.title ?? "")
                            .customFont(weight: .book, size: 12)
                            .foregroundColor(.grayA4ACAD())
                        HStack {
                            Text(notification.message ?? "")
                                .customFont(weight: .book, size: 14)
                                .foregroundColor(.black141F1F())
                            Spacer()
                            Text(notification.formattedDate ?? "")
                                .customFont(weight: .book, size: 14)
                                .foregroundColor(.grayA4ACAD())
                        }
                    }
                }
            } else {
                HStack(spacing: 15) {
                    Image(notification.notificationType == .orders ? "ic_new_notification" : "ic_agree_notification")
                        .resizable()
                        .frame(width: 94, height: 92)
                    
                    VStack(alignment: .leading) {
                        Text(notification.title ?? "")
                            .customFont(weight: .book, size: 12)
                            .foregroundColor(.primary())
                        HStack {
                            HStack(spacing: 12) {
                                Text("\(notification.fromName ?? ""), ")
                                    .foregroundColor(.blue288599())
                                +
                                Text(notification.message ?? "")
                                    .foregroundColor(.black141F1F())
                            }
                            .customFont(weight: .book, size: 14)
                            Spacer()
                            Text(notification.formattedDate ?? "")
                                .customFont(weight: .book, size: 14)
                                .foregroundColor(.grayA4ACAD())
                        }
                        HStack {
                            Text(LocalizedStringKey.showDetails)
                                .customFont(weight: .bold, size: 12)
                                .foregroundColor(.primary())
                            Image(systemName: "arrow.left")
                                .foregroundColor(.primary())
                        }
                    }
                }
            }
            
            CustomDivider()
        }
        .cornerRadius(12)
        .padding(.horizontal, 24)
        .padding(.vertical, 8)
    }
}

#Preview {
    NotificationRowView(notification: NotificationItem(id: nil, fromId: nil, userId: nil, title: nil, message: nil, dateTime: nil, type: nil, bodyParams: nil, isRead: nil, fromName: nil, toName: nil))
}
