//
//  DirectionsView.swift
//  Khawi
//
//  Created by Karim Amsha on 27.10.2023.
//

import SwiftUI
import MapKit

struct DirectionsView: View {
    @Binding var startPoint: CLLocationCoordinate2D?
    @Binding var endPoint: CLLocationCoordinate2D?
    var dismissDirections: () -> Void

    var body: some View {
        VStack {
            Button("Clear Selection") {
                startPoint = nil
                endPoint = nil
                dismissDirections()
            }
            Text("Start Point: \(String(describing: startPoint))")
            Text("End Point: \(String(describing: endPoint))")
        }
        .padding()
    }
}
