//
//  NotificationsListView.swift
//  Khawi
//
//  Created by Karim Amsha on 25.10.2023.
//

import SwiftUI

struct NotificationsListView: View {
    let notifications: [Notification]

    var body: some View {
        ScrollView {
            ForEach(notifications, id: \.self) { item in
                NotificationRowView(notification: item)
            }
        }
    }
}
