//
//  NotificationsView.swift
//  Khawi
//
//  Created by Karim Amsha on 25.10.2023.
//

import SwiftUI

struct NotificationsView: View {
    
    @StateObject var notificationsViewModel = NotificationsViewModel()
    
    var body: some View {
        VStack {
            NotificationsListView(notifications: notificationsViewModel.notifications)
            
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(LocalizedStringKey.notifications)
                        .customFont(weight: .book, size: 20)
                      .foregroundColor(Color.black141F1F())
                }
            }
        }
    }
}

#Preview {
    NotificationsView()
}
