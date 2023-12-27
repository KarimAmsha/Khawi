//
//  Utilities.swift
//  Khawi
//
//  Created by Karim Amsha on 7.11.2023.
//

import Foundation
import MapKit

class Utilities: NSObject {
    // Helper function to get the address for a given coordinate
    static func getAddress(for coordinate: CLLocationCoordinate2D, completion: @escaping (String) -> Void) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first {
                var addressComponents: [String] = []

                if let thoroughfare = placemark.thoroughfare {
                    addressComponents.append(thoroughfare)
                }
                if let locality = placemark.locality {
                    addressComponents.append(locality)
                }
                if let name = placemark.name {
                    addressComponents.append(name)
                }

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
    
    static func getShortAddress(for coordinate: CLLocationCoordinate2D, completion: @escaping (String) -> Void) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first {
                var addressComponents: [String] = []

                if let thoroughfare = placemark.thoroughfare {
                    addressComponents.append(thoroughfare)
                }
                if let locality = placemark.locality {
                    addressComponents.append(locality)
                }
                if let name = placemark.name {
                    addressComponents.append(name)
                }

    //                if let administrativeArea = placemark.administrativeArea {
    //                    addressComponents.append(administrativeArea)
    //                }
    //                if let postalCode = placemark.postalCode {
    //                    addressComponents.append(postalCode)
    //                }
//                if let country = placemark.country {
//                    addressComponents.append(country)
//                }

                let formattedAddress = addressComponents.joined(separator: ", ")
                completion(formattedAddress)
            } else {
                completion("Address not found")
            }
        }
    }
}

