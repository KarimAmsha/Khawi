//
//  MapViewModel.swift
//  Khawi
//
//  Created by Karim Amsha on 11.11.2023.
//

import MapKit
import Combine

class MapViewModel: ObservableObject {
    @Published var startCoordinate: CLLocationCoordinate2D?
    @Published var endCoordinate: CLLocationCoordinate2D?
    
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),  // Default to San Francisco
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )

    @Published var route: MKPolyline?
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        $region
            .sink { _ in
                self.fetchRoute()
            }
            .store(in: &cancellables)
    }

    private func fetchRoute() {
        // Add your logic to fetch route between two locations and update the 'route' property
        // For simplicity, we'll use a static route between two coordinates
        guard let startCoordinate = startCoordinate, let endCoordinate = endCoordinate else {
            return
        }

        let coordinates = [startCoordinate, endCoordinate]
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        route = polyline
    }
}
