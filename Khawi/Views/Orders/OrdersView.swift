//
//  OrdersView.swift
//  Khawi
//
//  Created by Karim Amsha on 24.10.2023.
//

import SwiftUI
import MapKit

struct OrdersView: View {
    @State private var selectedTab = 0
    @StateObject var tripsViewModel = TripsViewModel()
    
    let tabs = [LocalizedStringKey.currentOrders, LocalizedStringKey.completedOrders, LocalizedStringKey.cancelledOrders]

    var body: some View {
        VStack {
            // Segmented Control (Top Tabs)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(0..<tabs.count, id: \.self) { index in
                        Button(action: {
                            withAnimation {
                                selectedTab = index
                            }
                        }) {
                            Text(tabs[index])
                                .customFont(weight: index == selectedTab ? .bold : .book, size: 14)
                                .foregroundColor(index == selectedTab ? .black141F1F() : .grayA4ACAD())
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
                        .offset(x: geometry.size.width / CGFloat(tabs.count) * CGFloat(selectedTab))
                        .foregroundColor(.primary())
                }
                .frame(height: 2)
            }
            .padding(.top, 12)

            TripsListView(trips: tripsViewModel.filteredTrips)
            
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
            // Initialize filteredTrips with the trips matching the default tab (Current Orders)
            filterTripsBySelectedTab(selectedTab)
        }
        .onChange(of: selectedTab) { newTab in
            // Update filteredTrips when selectedTab changes
            filterTripsBySelectedTab(newTab)
        }
    }
    
    // Helper function to filter trips based on the selected tab
    private func filterTripsBySelectedTab(_ tab: Int) {
        switch tab {
        case 0: // Current Orders
            tripsViewModel.filteredTrips = tripsViewModel.allTrips.filter { $0.status == .opened }
        case 1: // Completed Orders
            tripsViewModel.filteredTrips = tripsViewModel.allTrips.filter { $0.status == .completed }
        case 2: // Cancelled Orders
            tripsViewModel.filteredTrips = tripsViewModel.allTrips.filter { $0.status == .canceled }
        default:
            tripsViewModel.filteredTrips = []
        }
    }
}

#Preview {
    OrdersView()
}
