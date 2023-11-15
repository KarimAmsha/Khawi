//
//  OrdersView.swift
//  Khawi
//
//  Created by Karim Amsha on 24.10.2023.
//

import SwiftUI
import MapKit

struct OrdersView: View {
    @State private var selectedTab: OrderStatus = .new
    @StateObject private var router: MainRouter
    @StateObject private var ordersViewModel = OrdersViewModel(initialRegion: MKCoordinateRegion(), errorHandling: ErrorHandling())
    private let errorHandling = ErrorHandling()
    let tabs = [OrderStatus.new, OrderStatus.finished, OrderStatus.canceled]

    init(router: MainRouter) {
        _router = StateObject(wrappedValue: router)
    }

    var body: some View {
        VStack {
            // Segmented Control (Top Tabs)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(tabs, id: \.self) { tab in
                        Button(action: {
                            withAnimation {
                                selectedTab = tab
                            }
                        }) {
                            Text(tab.value)
                                .customFont(weight: tab == selectedTab ? .bold : .book, size: 14)
                                .foregroundColor(tab == selectedTab ? .black141F1F() : .grayA4ACAD())
                        }
                    }
                }
                .padding(.horizontal, 20)
            }

            ZStack {
                // Custom Divider
                CustomDivider()

                // Bottom Line
                GeometryReader { geometry in
                    Capsule()
                        .frame(width: geometry.size.width / CGFloat(tabs.count), height: 2)
                        .offset(x: (geometry.size.width / CGFloat(tabs.count) * CGFloat(tabs.firstIndex(of: selectedTab) ?? 0)) + (geometry.size.width / CGFloat(tabs.count) / 6) - 20)
                        .foregroundColor(.primary())
                }
                .frame(height: 2)
            }
            .padding(.top, 12)

            ScrollView(showsIndicators: false) {
                ForEach(ordersViewModel.orders, id: \.self) { item in
                    OrderCardView(item: item)
                        .onTapGesture {
                            if item.type == .joining {
                                router.presentViewSpec(viewSpec: .joiningRequestOrderDetailsView(item._id ?? ""))
                            } else {
                                router.presentViewSpec(viewSpec: .deliveryRequestOrderDetailsView(item._id ?? ""))
                            }
                        }
                }
                
                if ordersViewModel.shouldLoadMoreData {
                    Color.clear.onAppear {
                        loadMore()
                    }
                }

                if ordersViewModel.isFetchingMoreData {
                    LoadingView()
                }
            }
            .onAppear {
                
            }

            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(LocalizedStringKey.orders)
                        .customFont(weight: .book, size: 20)
                      .foregroundColor(Color.black141F1F())
                }
            }
        }
        .onAppear {
            loadData()
        }
        .onChange(of: selectedTab) { newTab in
            loadData()
        }
        .onChange(of: ordersViewModel.errorMessage) { errorMessage in
            if let errorMessage = errorMessage {
                router.presentToastPopup(view: .error(LocalizedStringKey.error, errorMessage))
            }
        }
    }
}

#Preview {
    OrdersView(router: MainRouter(isPresented: .constant(.main)))
}

extension OrdersView {
    func loadData() {
        ordersViewModel.orders.removeAll()
        ordersViewModel.getOrders(status: selectedTab.rawValue, page: 0, limit: 10)
    }
    
    func loadMore() {
        ordersViewModel.loadMoreOrders(status: selectedTab.rawValue, limit: 10)
    }
}
