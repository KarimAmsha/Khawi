//
//  ShowOnMapView.swift
//  Khawi
//
//  Created by Karim Amsha on 29.10.2023.
//

import SwiftUI
import MapKit

struct ShowOnMapView: View {
    @State private var route: MKPolyline?
    @State private var mapAnnotations: [MKPointAnnotation] = []
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 24.7136, longitude: 46.6753),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @Binding var startCoordinate: CLLocationCoordinate2D?
    @Binding var endCoordinate: CLLocationCoordinate2D?

    var body: some View {
        VStack {
            MapViewRepresentable(region: $region, annotations: $mapAnnotations, route: $route)
                .onAppear {
                    addAnnotation(coordinate: $startCoordinate, title: "Start", imageName: "ic_start_point")
                    addAnnotation(coordinate: $endCoordinate, title: "End", imageName: "ic_end_point")
                    createRoute()
                }
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationTitle("")
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(LocalizedStringKey.showOnMap)
                        .customFont(weight: .book, size: 20)
                      .foregroundColor(Color.black141F1F())
                }
            }
        }
    }
    
    func addAnnotation(coordinate: Binding<CLLocationCoordinate2D?>, title: String, imageName: String) {
        if let coord = coordinate.wrappedValue {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coord
            annotation.title = title
            mapAnnotations.append(annotation)
        }
    }

    func createRoute() {
        if let startCoordinate = startCoordinate, let endCoordinate = endCoordinate {
            let coordinates = [startCoordinate, endCoordinate]
            route = MKPolyline(coordinates: coordinates, count: coordinates.count)
        }
    }
}

#Preview {
    ShowOnMapView(startCoordinate: .constant(CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)), endCoordinate: .constant(CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)))
}
