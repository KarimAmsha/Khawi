//
//  SelectDestinationView.swift
//  Khawi
//
//  Created by Karim Amsha on 27.10.2023.
//

import SwiftUI
import MapKit

struct SelectDestinationView: View {
    @State private var location = ""
    @State private var price = ""

    @StateObject private var router: MainRouter
    @State private var isSpecifyStartPoint = false
    @State private var isSpecifyEndPoint = false
    @State private var startCoordinate: CLLocationCoordinate2D?
    @State private var endCoordinate: CLLocationCoordinate2D?
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 24.7136, longitude: 46.6753),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var userTrackingMode: MapUserTrackingMode = .follow

    @State private var startPoint: CLLocationCoordinate2D?
    @State private var endPoint: CLLocationCoordinate2D?
    @State private var selectingStart = true
    @State private var showDirections = false
    @State private var startPoints: [PointItem] = []
    @State private var endPoints: [PointItem] = []
    @State private var userPoints: [PointItem] = []
    @State private var startPointAddress: String = ""
    @State private var endPointAddress: String = ""
    @EnvironmentObject var appState: AppState
    @State private var userLocation: CLLocationCoordinate2D? = nil
    @State private var coordinates: [CLLocationCoordinate2D]?
    @State private var annotations: [MKPointAnnotation] = []
    @State private var route: MKPolyline?
    @State private var mapAnnotations: [MKPointAnnotation] = []

    init(router: MainRouter) {
        _router = StateObject(wrappedValue: router)
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(LocalizedStringKey.tripPath)
                            .customFont(weight: .book, size: 16)
                            .foregroundColor(.gray4E5556())
                            .padding(.horizontal, 24)

                        VStack(alignment: .leading, spacing: 20) {
                            HStack(spacing: 16) {
                                VStack {
                                    Image("ic_start_point")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                    if isSpecifyStartPoint {
                                        Image("ic_v_line")
                                        Image("ic_end_point")
                                            .resizable()
                                            .frame(width: 19, height: 30)
                                    }
                                }
                                
                                VStack(spacing: 20) {
                                    HStack {
                                        Text(startPointAddress.isEmpty ? LocalizedStringKey.startPoint : startPointAddress)
                                            .customFont(weight: .book, size: 16)
                                            .foregroundColor(isSpecifyStartPoint ? .black666666() : .grayA4ACAD())
                                            .lineLimit(1)
                                        Spacer()
                                        if isSpecifyStartPoint {
                                            Image("ic_edit")
                                                .resizable()
                                                .frame(width: 20, height: 20)
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(12)
                                    .background(Color.grayF9FAFA())
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.grayE6E9EA(), lineWidth: 1)
                                    )
                                    
                                    if isSpecifyStartPoint {
                                        HStack {
                                            Text(endPointAddress.isEmpty ? LocalizedStringKey.endPoint : endPointAddress)
                                                .customFont(weight: .book, size: 16)
                                                .foregroundColor(isSpecifyEndPoint ? .black666666() : .grayA4ACAD())
                                                .lineLimit(1)
                                            Spacer()
                                            if isSpecifyStartPoint {
                                                Image("ic_edit")
                                                    .resizable()
                                                    .frame(width: 20, height: 20)
                                            }
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(12)
                                        .background(Color.grayF9FAFA())
                                        .cornerRadius(12)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.grayE6E9EA(), lineWidth: 1)
                                        )
                                    }
                                }
                            }
                        }
                        .padding(.leading, 44)
                        .padding(.trailing, 24)
                    }
                    
                    ZStack {
                        MapViewRepresentable(region: $region, annotations: $mapAnnotations, route: $route)
                            .onAppear {
                                // Use the user's current location if available
                                if let userLocation = LocationManager.shared.userLocation {
                                    self.userLocation = userLocation
                                    region.center = userLocation
                                    self.userPoints = [PointItem(coordinate: userLocation, type: .user)]
                                    addAnnotation(coordinate: userLocation, title: "User", imageName: "ic_user_pin")
                                }
                            }
                            .onTapGesture(perform: handleTapOnMap)

//                            .onTapGesture { location in
//                                let coordinate = mapViewCoordinate(for: location)
//
//                                if startCoordinate == nil {
//                                    startCoordinate = coordinate
//                                    addAnnotation(coordinate: coordinate, title: "Start", imageName: "ic_start_point")
//                                } else if endCoordinate == nil {
//                                    endCoordinate = coordinate
//                                    addAnnotation(coordinate: coordinate, title: "End", imageName: "ic_end_point")
//                                    createRoute()
//                                }
//                            }


//                        Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: $userTrackingMode, annotationItems: startPoints + endPoints + userPoints) { point in
//                            MapAnnotation(coordinate: point.coordinate) {
//                                Button(action: {
//                                    handlePointTap(point)
//                                }) {
//                                    Image(pointImage(for: point.type))
//                                        .resizable()
//                                        .frame(width: (point.type == .start || point.type == .user) ? 46 : 31, height: (point.type == .start || point.type == .user) ? 46 : 48)
//                                }
//                            }
//                            
////                            if let route {
////                              MapPolyline(route)
////                                  .stroke(.blue, lineWidth: 5)
////                            }
//                        }
//                        .onAppear {
//                            // Use the user's current location if available
//                            if let userLocation = LocationManager.shared.userLocation {
//                                self.userLocation = userLocation
//                                region.center = userLocation
//                                self.userPoints = [PointItem(coordinate: userLocation, type: .user)]
//                            }
//                        }
//                        .onTapGesture(perform: handleTapOnMap)
                        
                        // Add the "My Location" button at the bottom right
                        VStack {
                            Spacer()
                            HStack {
                                Button(action: {
                                    // Move the map to the user's current location
                                    if let userLocation = LocationManager.shared.userLocation {
                                        self.userLocation = userLocation
                                        region.center = userLocation
                                        self.userPoints = [PointItem(coordinate: userLocation, type: .user)]
                                        addAnnotation(coordinate: userLocation, title: "User", imageName: "ic_user_pin")
                                    }
                                }) {
                                    HStack {
                                        Image("ic_end_point")
                                            .resizable()
                                            .frame(width: 13, height: 20)
                                        Text(LocalizedStringKey.yourLocation)
                                            .customFont(weight: .bold, size: 12)
                                            .foregroundColor(.black)
                                    }
                                    .frame(width: 110, height: 40)
                                    .background(Color.white)
                                    .cornerRadius(21)
                                    .shadow(color: .black.opacity(0.28), radius: 2, x: 0, y: 3)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 21.5)
                                            .inset(by: -0.5)
                                            .stroke(Color.primary(), lineWidth: 1)
                                    )
                                }
                                Spacer()
                            }
                        }
                        .padding(.bottom, 135)
                        .padding(.horizontal, 16)

                        VStack {
                            Spacer()
                            VStack {
                                Button {
                                    if destinationSelected() {
                                        router.navigateBack()
                                    } else {
                                        appState.toastTitle = LocalizedStringKey.error
                                        appState.toastMessage = !isSpecifyStartPoint ? LocalizedStringKey.pleaseSpecifyStartPoint : LocalizedStringKey.pleaseSpecifyEndPoint
                                        router.presentToastPopup(view: .error)
                                    }
                                } label: {
                                    Text(!isSpecifyStartPoint ? LocalizedStringKey.specifyStartPoint : (isSpecifyStartPoint && !isSpecifyEndPoint) ? LocalizedStringKey.specifyEndPoint : LocalizedStringKey.joinToTrip)
                                }
                                .buttonStyle(PrimaryButton(fontSize: 18, fontWeight: .book, background: .primary(), foreground: .white, height: 48, radius: 12))
                                .padding(.horizontal, 24)
                                .padding(.vertical, 19)
                            }
                            .background(Color.white)
                            .cornerRadius(16, corners: [.topLeft, .topRight])
                        }
                    }
                }
                .frame(minWidth: geometry.size.width)
                .frame(minHeight: geometry.size.height)
            }
        }
        .navigationTitle("")
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(LocalizedStringKey.specifyDestination)
                        .customFont(weight: .book, size: 20)
                      .foregroundColor(Color.black141F1F())
                }
            }
        }
    }

    func handleTapOnMap(location: CGPoint) {
        let coordinate = region.center(at: location)

        if selectingStart {
            // Clear the map
            clearMap()

            startPoints = [PointItem(coordinate: coordinate, type: .start)]
            selectingStart = false
            isSpecifyStartPoint = true
            getAddress(for: coordinate) { address in
                startPointAddress = address
            }
            appState.startPoint = startPoints.first
            self.coordinates?.append(startPoints.first?.coordinate ?? CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0))
            startCoordinate = coordinate
            addAnnotation(coordinate: coordinate, title: "Start", imageName: "ic_start_point")
        } else {
            endPoints = [PointItem(coordinate: coordinate, type: .end)]
            showDirections = true
            selectingStart = true
            isSpecifyEndPoint = true
            getAddress(for: coordinate) { address in
                endPointAddress = address
            }
            appState.endPoint = endPoints.first
            self.coordinates?.append(endPoints.first?.coordinate ?? CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0))
            endCoordinate = coordinate
            addAnnotation(coordinate: coordinate, title: "End", imageName: "ic_end_point")
            createRoute()
        }
    }

    func handlePointTap(_ point: PointItem) {
        // Handle the tap on the point (start or end) here
    }
    
    func clearMap() {
        // Clear annotations
        mapAnnotations.removeAll()

        // Clear route
        route = nil

        // Reset other state variables if needed
    }

    func pointImage(for type: PointType) -> String {
        switch type {
        case .start:
            return "ic_start_point"
        case .end:
            return "ic_end_point"
        case .user:
            return "ic_user_pin"
        }
    }
    
    // Helper function to get the address for a given coordinate
    func getAddress(for coordinate: CLLocationCoordinate2D, completion: @escaping (String) -> Void) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first {
                var addressComponents: [String] = []

                if let name = placemark.name {
                    addressComponents.append(name)
                }
//                if let thoroughfare = placemark.thoroughfare {
//                    addressComponents.append(thoroughfare)
//                }
//                if let locality = placemark.locality {
//                    addressComponents.append(locality)
//                }
//                if let administrativeArea = placemark.administrativeArea {
//                    addressComponents.append(administrativeArea)
//                }
//                if let postalCode = placemark.postalCode {
//                    addressComponents.append(postalCode)
//                }
                if let country = placemark.country {
                    addressComponents.append(country)
                }

                let formattedAddress = addressComponents.joined(separator: ", ")
                completion(formattedAddress)
            } else {
                completion("Address not found")
            }
        }
    }
    
    func destinationSelected() -> Bool {
        if let startPoint = appState.startPoint, let endPoint = appState.endPoint {
            return true
        } else {
            return false
        }
    }
    
    func addAnnotation(coordinate: CLLocationCoordinate2D, title: String, imageName: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        mapAnnotations.append(annotation)
    }

    func createRoute() {
        if let startCoordinate = startCoordinate, let endCoordinate = endCoordinate {
            let coordinates = [startCoordinate, endCoordinate]
            route = MKPolyline(coordinates: coordinates, count: coordinates.count)
        }
    }

    func mapViewCoordinate(for location: CGPoint) -> CLLocationCoordinate2D {
        // Convert the location to a CLLocationCoordinate2D based on the map's visible region.
        // You may need to adjust this based on your specific use case.
        // Here, we are using a simple offset.
        let mapCenter = region.center
        let offset = CGPoint(x: location.x - UIScreen.main.bounds.size.width / 2, y: location.y - UIScreen.main.bounds.size.height / 2)
        let newCoordinate = CLLocationCoordinate2D(
            latitude: mapCenter.latitude - Double(offset.y) / 10000,
            longitude: mapCenter.longitude + Double(offset.x) / 10000
        )
        return newCoordinate
    }

}

#Preview {
    SelectDestinationView(router: MainRouter(isPresented: .constant(.main)))
        .environmentObject(AppState())
}

