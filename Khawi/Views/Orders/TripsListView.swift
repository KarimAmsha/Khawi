//
//  TripsListView.swift
//  Khawi
//
//  Created by Karim Amsha on 25.10.2023.
//

import SwiftUI

struct TripsListView: View {
    let trips: [Trip]
    
    var body: some View {
        ScrollView {
            ForEach(trips) { trip in
                TripCardView(trip: trip)
            }
        }
    }
}
