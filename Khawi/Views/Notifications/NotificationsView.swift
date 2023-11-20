//
//  NotificationsView.swift
//  Khawi
//
//  Created by Karim Amsha on 25.10.2023.
//

import SwiftUI

struct NotificationsView: View {
        
    @State private var selectedTab: OrderStatus = .new
    @StateObject private var router: MainRouter
    @StateObject private var viewModel = NotificationsViewModel(errorHandling: ErrorHandling())
    private let errorHandling = ErrorHandling()
    let tabs = [OrderStatus.new, OrderStatus.finished, OrderStatus.canceled]

    init(router: MainRouter) {
        _router = StateObject(wrappedValue: router)
    }

    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                ForEach(viewModel.notificationsItems, id: \.self) { item in
                    NotificationRowView(notification: item)
                        .onTapGesture {
                            if item.notificationType == .join {
                                router.presentViewSpec(viewSpec: .joiningRequestOrderDetailsView(item.bodyParams ?? ""))
                            } else if item.notificationType == .deliver {
                                router.presentViewSpec(viewSpec: .deliveryRequestOrderDetailsView(item.bodyParams ?? ""))
                            }
                        }
                        .contextMenu {
                            Button(action: {
                                // Handle deletion here
                                deleteNotification(item)
                            }) {
                                Text(LocalizedStringKey.delete)
                                    .font(.system(size: 14, weight: .regular, design: .default)) // Adjust the size and weight as needed
                                Image(systemName: "trash")
                            }
                        }
                }
                
                if viewModel.shouldLoadMoreData {
                    Color.clear.onAppear {
                        loadMore()
                    }
                }

                if viewModel.isFetchingMoreData {
                    LoadingView()
                }
            }

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
        .onAppear {
            loadData()
        }
        .onChange(of: viewModel.errorMessage) { errorMessage in
            if let errorMessage = errorMessage {
                router.presentToastPopup(view: .error(LocalizedStringKey.error, errorMessage))
            }
        }
    }
}

#Preview {
    NotificationsView(router: MainRouter(isPresented: .constant(nil)))
}

extension NotificationsView {
    func loadData() {
        viewModel.notificationsItems.removeAll()
        viewModel.fetchNotificationsItems(page: 0, limit: 10)
    }
    
    func loadMore() {
        viewModel.loadMoreNotifications(limit: 10)
    }
    
    func deleteNotification(_ notification: NotificationItem) {
        // Implement your deletion logic here
        // You may want to show a confirmation alert before deleting
        let alertModel = AlertModel(
            title: LocalizedStringKey.delete,
            message: LocalizedStringKey.deleteMessage,
            hideCancelButton: false,
            onOKAction: {
                router.dismiss()
                viewModel.deleteNotifications(id: notification.id ?? "") { message in
                    loadData()
                }
            },
            onCancelAction: {
                router.dismiss()
            }
        )
        
        router.presentToastPopup(view: .alert(alertModel))
    }
}
