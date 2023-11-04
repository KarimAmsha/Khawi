//
//  MapRouteOverlay.swift
//  Khawi
//
//  Created by Karim Amsha on 27.10.2023.
//

import SwiftUI
import MapKit

//struct MapRouteOverlay: View {
//    var route: MKRoute
//    @Binding var region: MKCoordinateRegion
//
//    var body: some View {
//        GeometryReader { geometry in
//            Path { path in
//                for i in 0..<route.polyline.pointCount {
//                    let mapPoint = route.polyline.points[i]
//                    let coordinate = CLLocationCoordinate2D(latitude: mapPoint.y, longitude: mapPoint.x)
//                    let point = CGPoint(x: geometry.size.width / 2 + CGFloat(coordinate.longitude - region.center.longitude) * geometry.size.width / region.span.longitudeDelta,
//                                        y: geometry.size.height / 2 - CGFloat(coordinate.latitude - region.center.latitude) * geometry.size.height / region.span.latitudeDelta)
//                    if path.isEmpty {
//                        path.move(to: point)
//                    } else {
//                        path.addLine(to: point)
//                    }
//                }
//            }
//            .stroke(Color.blue, lineWidth: 4)
//        }
//    }
//}
