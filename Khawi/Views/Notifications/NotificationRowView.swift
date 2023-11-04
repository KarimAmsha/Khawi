//
//  NotificationRowView.swift
//  Khawi
//
//  Created by Karim Amsha on 25.10.2023.
//

import SwiftUI

struct NotificationRowView: View {
    let notification: Notification

    var body: some View {
        VStack {
            if (notification.isFromAdmin ?? false) {
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
                            Text(notification.date ?? "")
                                .customFont(weight: .book, size: 14)
                                .foregroundColor(.grayA4ACAD())
                        }
                    }
                }
            } else {
                HStack(spacing: 15) {
                    Image(notification.requestType == .joiningRequest ? "ic_new_notification" : "ic_agree_notification")
                        .resizable()
                        .frame(width: 94, height: 92)
                    
                    VStack(alignment: .leading) {
                        Text(notification.title ?? "")
                            .customFont(weight: .book, size: 12)
                            .foregroundColor(.primary())
                        HStack {
                            HStack(spacing: 12) {
                                Text("\(notification.name ?? ""), ")
                                    .foregroundColor(.blue288599())
                                +
                                Text(notification.message ?? "")
                                    .foregroundColor(.black141F1F())
                            }
                            .customFont(weight: .book, size: 14)
                            Spacer()
                            Text(notification.date ?? "")
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
    NotificationRowView(notification: Notification(name: "أحمد", date: "08.58", title: "هذا اشعار خاص بالإدارة", message: "يطلب الانضمام إلى رحلتك.", isFromAdmin: true, requestType: .joiningRequest))
}
