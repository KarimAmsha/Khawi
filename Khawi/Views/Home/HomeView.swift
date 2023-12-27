//
//  HomeView.swift
//  Khawi
//
//  Created by Karim Amsha on 23.10.2023.
//

import SwiftUI
import MapKit

struct HomeView: View {
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var appState: AppState
    @State var isEditing: Bool = false
    @State var searchText: String = ""
    @Binding var showPopUp: Bool
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 24.7136, longitude: 46.6753),
        span: MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
    )
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    @StateObject private var router: MainRouter
    private let errorHandling = ErrorHandling()
    @State private var userLocation: CLLocationCoordinate2D? = nil
    @State private var lastLoadedRegion: MKCoordinateRegion?
    private let distanceThreshold: CLLocationDistance = Constants.distance * 1609.34
    @ObservedObject var ordersViewModel: OrdersViewModel
    @ObservedObject var userViewModel: UserViewModel
    @StateObject private var notificationHandler = NotificationHandler.shared
    @StateObject private var mapSearch = MapSearch()
    
    @FocusState private var isFocused: Bool
    
    @State private var btnHover = false
    @State private var isBtnActive = false
    
    @State private var address = ""
    @State private var city = ""
    @State private var state = ""
    @State private var zip = ""
    
    init(showPopUp: Binding<Bool>, router: MainRouter) {
        _showPopUp = showPopUp
        _router = StateObject(wrappedValue: router)
        
        let initialRegion: MKCoordinateRegion
        if let userLocation = LocationManager.shared.userLocation {
            initialRegion = MKCoordinateRegion(
                center: userLocation,
                span: MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
            )
        } else {
            // Default to a specific location if user location is not available
            initialRegion = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 24.7136, longitude: 46.6753),
                span: MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
            )
        }
        
        self._ordersViewModel = ObservedObject(wrappedValue: OrdersViewModel(initialRegion: initialRegion, errorHandling: errorHandling))
        self._userViewModel = ObservedObject(wrappedValue: UserViewModel(errorHandling: errorHandling))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                SearchBar(text: $mapSearch.searchTerm, placeholder: LocalizedStringKey.searchForPlace)
            }
            .padding()
            .background(showPopUp ? .clear : Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.06), radius: 2, x: 0, y: 2)

            if mapSearch.isListVisible && !mapSearch.locationResults.isEmpty {
                ScrollView {
                    // Autocomplete results
                    ForEach(mapSearch.locationResults, id: \.self) { location in
                        Button {
                            mapSearch.searchTerm = location.title
                            mapSearch.clearResults()
                            handleAutocompleteSelection(location: location)
                            // Hide the list after selecting a location
                            mapSearch.isListVisible = false
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(location.title)
                                        .foregroundColor(.primary)
                                        .font(.headline)
                                    Spacer()
                                }
                                Text(location.subtitle)
                                    .foregroundColor(.secondary)
                                    .font(.caption)
                                    .padding(.top, 2) // Adjust the top padding as needed
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        // Separator
                        if mapSearch.locationResults.last != location {
                            Divider().padding(.vertical, 4)
                        }
                    }
                    .listRowSeparator(.visible)
                }
                .padding()
            }

            Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: $userTrackingMode, annotationItems: generateMapAnnotations(for: ordersViewModel.nearByOrders)) { item in
                MapAnnotation(coordinate: item.coordinate,
                              anchorPoint: CGPoint(x: 0.5, y: 0.7)) {
                    Button(action: {
                        item.onTap?() // Execute the onTap callback
                    }) {
                        item.content
                    }
                }
            }
            .padding(.bottom, -20)
            .onAppear {
                withAnimation(.easeInOut(duration: 2.0)) {
                    // Use the user's current location if available
                    if let userLocation = LocationManager.shared.userLocation {
                        region.center = userLocation
                    }
                }
                
                // Initial data loading
                ordersViewModel.loadNearbyOrders(for: region.center)
            }
            .onChange(of: region.center) { newCenter in
                if searchText.isEmpty {
                    // If searchText is empty, load nearby orders when the map moves
                    if let lastCenter = lastLoadedRegion?.center {
                        let oldLocation = CLLocation(latitude: lastCenter.latitude, longitude: lastCenter.longitude)
                        let newLocation = CLLocation(latitude: newCenter.latitude, longitude: newCenter.longitude)
                        let distance = newLocation.distance(from: oldLocation)
                        //                        print("distance \(distance)")
                        //                        print("distanceThreshold \(distanceThreshold)")
                        
                        //                        if distance >= distanceThreshold {
                        withAnimation {
                            //                                print("newCenter \(newCenter)")
                            ordersViewModel.loadNearbyOrders(for: newCenter)
                            lastLoadedRegion = MKCoordinateRegion(center: newCenter, span: region.span)
                        }
                        //                        }
                    } else {
                        withAnimation {
                            lastLoadedRegion = MKCoordinateRegion(center: newCenter, span: region.span)
                        }
                    }
                } else {
                    // If searchText is not empty, update the region based on the first result
                    if let firstOrder = ordersViewModel.orders.first,
                       let latitude = firstOrder.f_lat,
                       let longitude = firstOrder.f_lng {
                        withAnimation {
                            region.center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        }
                    }
                }
            }
            .onChange(of: mapSearch.selectedLocation) { newLocation in
                if let newLocation = newLocation {
                    // Move the map to the selected place
                    withAnimation {
                        region.center = newLocation.placemark.coordinate
                    }
                }
            }
        }
        .ignoresSafeArea()
        .navigationTitle("")
        .overlay(
            RoundedRectangle(cornerRadius: 0)
                .fill(Color.gray595959())
                .opacity(showPopUp ? 0.3 : 0)
        )
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                } label: {
                    AsyncImage(url: settings.user?.image?.toURL()) { phase in
                        switch phase {
                        case .empty:
                            ProgressView() // Placeholder while loading
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 32, height: 32)
                                .clipShape(Circle()) // Clip the image to a circle
                        case .failure:
                            Image(systemName: "photo.circle") // Placeholder for failure
                                .imageScale(.large)
                                .foregroundColor(.gray)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(width: 40, height: 40)
                    .background(Circle().foregroundColor(.white).padding(4).overlay(Circle().stroke(Color.primary(), lineWidth: 2)))
                }
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    Text(LocalizedStringKey.helloBrother)
                        .foregroundColor(.black141F1F())
                    Text("..\(settings.user?.full_name ?? "")")
                        .foregroundColor(.primary())
                }
                .customFont(weight: .book, size: 20)
            }
        }
        .onAppear {
            fetchUserLocation()
            
            // Observe changes in notificationHandler properties
            NotificationCenter.default.addObserver(
                forName: NotificationHandler.orderNotificationUpdateNotification,
                object: nil,
                queue: .main
            ) { _ in
                // Trigger navigation when an order notification is received
                notificationHandler.orderNotificationReceived = true
                appState.currentPage = .notifications
            }
        }
        .onChange(of: ordersViewModel.errorMessage) { errorMessage in
            if let errorMessage = errorMessage {
                router.presentToastPopup(view: .error(LocalizedStringKey.error, errorMessage))
            }
        }
    }
    
    func image(for type: OrderType) -> Image {
        switch type {
        case .joining:
            return Image("ic_car_pin")
        case .delivery:
            return Image("ic_person_pin")
        }
    }
}

#Preview {
    HomeView(showPopUp: .constant(false), router: MainRouter(isPresented: .constant(.main)))
        .environmentObject(UserSettings())
        .environmentObject(AppState())
}


extension HomeView {
    private func generateMapAnnotations(for orders: [Order]) -> [CustomMapAnnotation] {
        return ordersViewModel.generateMapAnnotations(for: orders) { order in
            self.handleButtonTap(for: order)
        }
    }

    private func handleButtonTap(for order: Order) {
//        appState.selectedOrder = order

        switch order.type {
        case .joining:
            router.presentToastPopup(view: .joining(order))
        case .delivery:
            router.presentToastPopup(view: .delivery(order))
        case .none:
            break
        }
    }
    
    private func fetchUserLocation() {
        LocationManager.shared.getCurrentLocation { location in
            if let location = location {
                // Update your UI or perform actions with the location
                userLocation = location
                userViewModel.updateUserLocation(location: FBUserLocation(driverName: settings.user?.full_name ?? "", driverPhone: Int64(settings.user?.phone_number ?? "") ?? 0, g: String.randomStringWithDigitsAndChars(10), l: [location.latitude, location.longitude]))
                LocationManager.shared.stopUpdatingLocation()
            } else {
                print("Failed to get the user's location")
            }
        }
    }    
}


extension HomeView {
    private func handleAutocompleteSelection(location: MKLocalSearchCompletion) {
        // Use MKLocalSearch to get detailed information about the selected location
        let searchRequest = MKLocalSearch.Request(completion: location)
        let search = MKLocalSearch(request: searchRequest)

        search.start { response, error in
            guard let mapItem = response?.mapItems.first else {
                if let error = error {
                    print("Error getting details for selected location: \(error.localizedDescription)")
                }
                return
            }

            // Handle the selected location (mapItem) as needed
            // For example, update the selectedLocation in MapSearch
            mapSearch.selectedLocation = mapItem
        }
    }
    
//    private func reverseGeo(location: MKLocalSearchCompletion) {
//        let searchRequest = MKLocalSearch.Request(completion: location)
//        let search = MKLocalSearch(request: searchRequest)
//
//        search.start { response, error in
//            guard let mapItem = response?.mapItems.first else {
//                let errorString = error?.localizedDescription ?? "Unexpected Error"
//                print("Unable to reverse geocode the given location. Error: \(errorString)")
//                return
//            }
//
//            let reversedGeoLocation = ReversedGeoLocation(with: mapItem.placemark)
//            address = reversedGeoLocation.streetName
//            city = reversedGeoLocation.city
//            state = reversedGeoLocation.state
//            zip = reversedGeoLocation.zipCode
//
//            // Update your UI or perform actions with the reversed location
//            print("Reversed Geo Location: \(reversedGeoLocation.formattedAddress)")
//            isFocused = false
//        }
//    }
}
