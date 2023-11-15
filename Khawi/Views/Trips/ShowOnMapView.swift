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
     let order: Order?
    @State private var selectedResult: MKMapItem?
    @State private var route2: MKRoute?
    
    @State var requestLocation: CLLocationCoordinate2D?
    @State var requestLocation2: CLLocationCoordinate2D?
    @State var destinationLocation: CLLocationCoordinate2D?
    @State var destination2: CLLocationCoordinate2D?

    var body: some View {
        VStack {
            MyMapView(requestLocation: Binding(
                          get: { requestLocation ?? CLLocationCoordinate2D() },
                          set: { requestLocation = $0 }
                      ),
                      requestLocation2: Binding(
                          get: { requestLocation2 ?? CLLocationCoordinate2D() },
                          set: { requestLocation2 = $0 }
                      ),
                      destinationLocation: Binding(
                          get: { destinationLocation ?? CLLocationCoordinate2D() },
                          set: { destinationLocation = $0 }
                      ),
                      destination2: Binding(
                          get: { destination2 ?? CLLocationCoordinate2D() },
                          set: { destination2 = $0 }
                      ), order: order!
            )
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
        .onAppear {
            if let startCoordinate = order?.f_lat, let startLongitude = order?.f_lng,
               let endCoordinate = order?.t_lat, let endLongitude = order?.t_lng {
                requestLocation = CLLocationCoordinate2D(latitude: startCoordinate, longitude: startLongitude)
                requestLocation2 = CLLocationCoordinate2D(latitude: startCoordinate, longitude: startLongitude)
                destinationLocation = CLLocationCoordinate2D(latitude: endCoordinate, longitude: endLongitude)
                destination2 = CLLocationCoordinate2D(latitude: startCoordinate, longitude: endLongitude)
                
                region.center = requestLocation ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
                region.span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            }
        }
    }
}

#Preview {
    ShowOnMapView(order: nil)
}

