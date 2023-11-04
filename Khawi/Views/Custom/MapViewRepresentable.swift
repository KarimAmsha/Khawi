//
//  MyMapView.swift
//  Khawi
//
//  Created by Karim Amsha on 29.10.2023.
//

import Foundation
import SwiftUI
import MapKit

import SwiftUI
import MapKit

struct MapViewRepresentable: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    @Binding var annotations: [MKPointAnnotation]
    @Binding var route: MKPolyline?

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.setRegion(region, animated: true)
        
        // Remove all annotations
        uiView.removeAnnotations(uiView.annotations)
        
        // Remove all overlays (including the polyline)
        if let overlays = uiView.overlays as? [MKPolyline] {
            uiView.removeOverlays(overlays)
        }

        uiView.addAnnotations(annotations)

        if let route = route {
            uiView.addOverlay(route)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapViewRepresentable

        init(_ parent: MapViewRepresentable) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = UIColor(Color.blue006E85())
                renderer.lineWidth = 5
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if let annotation = annotation as? MKPointAnnotation {
                let reuseIdentifier = "customAnnotationView"
                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? MKPinAnnotationView

                if annotationView == nil {
                    annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
                } else {
                    annotationView?.annotation = annotation
                }

                // Customize the pin color and set images based on your conditions
                if annotation.title == "Start" {
                    annotationView?.pinTintColor = .green
                    annotationView?.image = UIImage(named: "ic_start_point")
                } else if annotation.title == "End" {
                    annotationView?.pinTintColor = .red
                    annotationView?.image = UIImage(named: "ic_end_point")
                } else if annotation.title == "User" {
                    annotationView?.pinTintColor = .red
                    annotationView?.image = UIImage(named: "ic_user_pin")
                }

                return annotationView
            }
            return nil
        }
    }
}
