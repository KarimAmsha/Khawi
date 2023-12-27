//
//  MapSearch.swift
//  Khawi
//
//  Created by Karim Amsha on 24.12.2023.
//

import SwiftUI
import Combine
import MapKit
import CoreLocation

class MapSearch: NSObject, ObservableObject {
    @Published var locationResults: [MKLocalSearchCompletion] = []
    @Published var searchTerm = ""
    @Published var selectedLocation: MKMapItem?

    @Published var isListVisible: Bool = false

    private var searchCompleter = MKLocalSearchCompleter()
    private var cancellables: Set<AnyCancellable> = []

    override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.resultTypes = .address

        $searchTerm
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { term in
                if term.isEmpty {
                    // Show list when starting a new search
                    self.isListVisible = true
                }
                self.searchCompleter.queryFragment = term
            }
            .store(in: &cancellables)
    }

    func clearResults() {
        locationResults.removeAll()
    }
}

extension MapSearch: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        locationResults = completer.results
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Autocomplete error: \(error.localizedDescription)")
        clearResults()
    }
}

//class MapSearch: NSObject, ObservableObject {
//    @Published var locationResults: [MKLocalSearchCompletion] = []
//    @Published var searchTerm = ""
//
//    private var searchCompleter = MKLocalSearchCompleter()
//    private var cancellables: Set<AnyCancellable> = []
//
//    override init() {
//        super.init()
//        searchCompleter.delegate = self
//        searchCompleter.resultTypes = .address
//
//        $searchTerm
//            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
//            .removeDuplicates()
//            .sink { term in
//                self.searchCompleter.queryFragment = term
//            }
//            .store(in: &cancellables)
//    }
//}
//
//extension MapSearch: MKLocalSearchCompleterDelegate {
//    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
//        locationResults = completer.results
//    }
//
//    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
//        print("Autocomplete error: \(error.localizedDescription)")
//    }
//}
//
//struct ReversedGeoLocation {
//    let streetNumber: String
//    let streetName: String
//    let city: String
//    let state: String
//    let zipCode: String
//    let country: String
//    let isoCountryCode: String
//
//    var formattedAddress: String {
//        return """
//        \(streetNumber) \(streetName),
//        \(city), \(state) \(zipCode)
//        \(country)
//        """
//    }
//
//    init(with placemark: CLPlacemark) {
//        self.streetName = placemark.thoroughfare ?? ""
//        self.streetNumber = placemark.subThoroughfare ?? ""
//        self.city = placemark.locality ?? ""
//        self.state = placemark.administrativeArea ?? ""
//        self.zipCode = placemark.postalCode ?? ""
//        self.country = placemark.country ?? ""
//        self.isoCountryCode = placemark.isoCountryCode ?? ""
//    }
//}
