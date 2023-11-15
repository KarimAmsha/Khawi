//
//  LocationManager.swift
//  Khawi
//
//  Created by Karim Amsha on 29.10.2023.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()

    private var locationManager = CLLocationManager()
    private var locationCompletion: ((CLLocationCoordinate2D?) -> Void)?
    @Published var userLocation: CLLocationCoordinate2D?

    override private init() {
        super.init()
        setupLocationManager()
    }

    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func getCurrentLocation(completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        locationCompletion = completion
        locationManager.requestLocation()
    }

    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last?.coordinate else {
            locationCompletion?(nil)
            return
        }
        userLocation = location
        locationCompletion?(location)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location update failed with error: \(error.localizedDescription)")
        locationCompletion?(nil)
    }
}
