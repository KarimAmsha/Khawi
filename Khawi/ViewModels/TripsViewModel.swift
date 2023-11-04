//
//  TripsViewModel.swift
//  Khawi
//
//  Created by Karim Amsha on 25.10.2023.
//

import Foundation
import SwiftUI
import Combine
import MapKit

class TripsViewModel: ObservableObject {
    @Published var allTrips: [Trip] = [
        Trip(
            tripNumber: "#12548",
            imageURL: URL(string: "https://hips.hearstapps.com/hmg-prod/images/2022-gr86-premium-trackbred-002-1628887849.jpg?crop=0.689xw:0.517xh;0.242xw,0.238xh&resize=1200:*")!,
            date: "2023-11-20",
            status: .opened,
            fromDestination: "الدمام",
            toDestination: "الرياض",
            price: "60 ر.س",
            title: "الرحلة 1",
            coordinate: CLLocationCoordinate2D(latitude: 24.7136, longitude: 46.6153),
            type: .joiningRequest
        ),

        Trip(
            tripNumber: "#12548",
            imageURL: URL(string: "https://hips.hearstapps.com/hmg-prod/images/2022-gr86-premium-trackbred-002-1628887849.jpg?crop=0.689xw:0.517xh;0.242xw,0.238xh&resize=1200:*")!,
            date: "2023-11-20",
            status: .opened,
            fromDestination: "الدمام",
            toDestination: "الرياض",
            price: "60 ر.س",
            title: "الرحلة 2",
            coordinate: CLLocationCoordinate2D(latitude: 24.7346, longitude: 46.6743),
            type: .deliveryRequest
        ),

        Trip(
            tripNumber: "#12549",
            imageURL: URL(string: "https://hips.hearstapps.com/hmg-prod/images/2022-gr86-premium-trackbred-002-1628887849.jpg?crop=0.689xw:0.517xh;0.242xw,0.238xh&resize=1200:*")!,
            date: "2023-11-10",
            status: .opened,
            fromDestination: "جدة",
            toDestination: "مكة",
            price: "40 ر.س",
            title: "الرحلة 3",
            coordinate: CLLocationCoordinate2D(latitude: 24.7556, longitude: 46.6963),
            type: .joiningRequest
        ),
        
        Trip(
            tripNumber: "#12549",
            imageURL: URL(string: "https://hips.hearstapps.com/hmg-prod/images/2022-gr86-premium-trackbred-002-1628887849.jpg?crop=0.689xw:0.517xh;0.242xw,0.238xh&resize=1200:*")!,
            date: "2023-11-10",
            status: .opened,
            fromDestination: "جدة",
            toDestination: "مكة",
            price: "40 ر.س",
            title: "الرحلة 4",
            coordinate: CLLocationCoordinate2D(latitude: 24.7766, longitude: 46.6533),
            type: .joiningRequest
        ),

        Trip(
            tripNumber: "#12549",
            imageURL: URL(string: "https://hips.hearstapps.com/hmg-prod/images/2022-gr86-premium-trackbred-002-1628887849.jpg?crop=0.689xw:0.517xh;0.242xw,0.238xh&resize=1200:*")!,
            date: "2023-11-10",
            status: .opened,
            fromDestination: "الرياض",
            toDestination: "الدمام",
            price: "40 ر.س",
            title: "الرحلة 5",
            coordinate: CLLocationCoordinate2D(latitude: 24.7976, longitude: 46.6873),
            type: .deliveryRequest
        ),

        Trip(
            tripNumber: "#12549",
            imageURL: URL(string: "https://hips.hearstapps.com/hmg-prod/images/2022-gr86-premium-trackbred-002-1628887849.jpg?crop=0.689xw:0.517xh;0.242xw,0.238xh&resize=1200:*")!,
            date: "2023-11-10",
            status: .completed,
            fromDestination: "الرياض",
            toDestination: "مكة",
            price: "40 ر.س",
            title: "الرحلة 6",
            coordinate: CLLocationCoordinate2D(latitude: 24.7976, longitude: 46.6873),
            type: .deliveryRequest
        ),

        Trip(
            tripNumber: "#12549",
            imageURL: URL(string: "https://hips.hearstapps.com/hmg-prod/images/2022-gr86-premium-trackbred-002-1628887849.jpg?crop=0.689xw:0.517xh;0.242xw,0.238xh&resize=1200:*")!,
            date: "2023-11-10",
            status: .completed,
            fromDestination: "جدة",
            toDestination: "الرياض",
            price: "40 ر.س",
            title: "الرحلة 7",
            coordinate: CLLocationCoordinate2D(latitude: 24.7976, longitude: 46.6873),
            type: .deliveryRequest
        ),

        Trip(
            tripNumber: "#12549",
            imageURL: URL(string: "https://hips.hearstapps.com/hmg-prod/images/2022-gr86-premium-trackbred-002-1628887849.jpg?crop=0.689xw:0.517xh;0.242xw,0.238xh&resize=1200:*")!,
            date: "2023-11-10",
            status: .canceled,
            fromDestination: "جدة",
            toDestination: "الدمام",
            price: "40 ر.س",
            title: "الرحلة 8",
            coordinate: CLLocationCoordinate2D(latitude: 24.7976, longitude: 46.6873),
            type: .deliveryRequest
        ),
        Trip(
            tripNumber: "#12549",
            imageURL: URL(string: "https://hips.hearstapps.com/hmg-prod/images/2022-gr86-premium-trackbred-002-1628887849.jpg?crop=0.689xw:0.517xh;0.242xw,0.238xh&resize=1200:*")!,
            date: "2023-11-10",
            status: .canceled,
            fromDestination: "الدمام",
            toDestination: "جدة",
            price: "40 ر.س",
            title: "الرحلة 9",
            coordinate: CLLocationCoordinate2D(latitude: 24.7976, longitude: 46.6873),
            type: .deliveryRequest
        ),

    ]
    
    @Published var filteredTrips: [Trip] = [] 
}
