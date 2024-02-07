//
//  NotificationsView.swift
//  Khawi
//
//  Created by Karim Amsha on 25.10.2023.
//

import SwiftUI
import MapKit

struct NotificationsView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedTab: OrderStatus = .new
    @StateObject private var router: MainRouter
    @StateObject private var viewModel = NotificationsViewModel(errorHandling: ErrorHandling())
    private let errorHandling = ErrorHandling()
    let tabs = [OrderStatus.new, OrderStatus.finished, OrderStatus.canceled]
    @StateObject private var orderViewModel = OrdersViewModel(initialRegion: MKCoordinateRegion(), errorHandling: ErrorHandling())

    init(router: MainRouter) {
        _router = StateObject(wrappedValue: router)
    }

    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                ForEach(viewModel.notificationsItems, id: \.self) { item in
                    NotificationRowView(notification: item)
                        .onTapGesture {
                            if item.notificationType == .orders {
                                orderViewModel.getOrderDetails(orderId: item.bodyParams ?? "") {
                                    if orderViewModel.order?.type == .joining {
                                        print("111")
                                        router.presentViewSpec(viewSpec: .joiningRequestOrderDetailsView(orderViewModel.order?._id ?? ""))
                                    } else {
                                        print("222")
                                        router.presentViewSpec(viewSpec: .deliveryRequestOrderDetailsView(orderViewModel.order?._id ?? ""))
                                    }
                                }
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
            readNotification()
        }
        .onChange(of: viewModel.errorMessage) { errorMessage in
            if let errorMessage = errorMessage {
                router.presentToastPopup(view: .error(LocalizedStringKey.error, errorMessage, .error))
            }
        }
    }
}

#Preview {
    NotificationsView(router: MainRouter(isPresented: .constant(nil)))
        .environmentObject(AppState())
}

extension NotificationsView {
    func loadData() {
        viewModel.notificationsItems.removeAll()
        viewModel.fetchNotificationsItems(page: 0, limit: 10)
    }
    
    func loadMore() {
        viewModel.loadMoreNotifications(limit: 10)
    }
    
    func readNotification() {
        viewModel.readNotifications() { message in
            appState.notificationCountString = nil
        }
    }
}
