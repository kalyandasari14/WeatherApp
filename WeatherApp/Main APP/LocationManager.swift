//
//  LocationManager.swift
//  WeatherApp
//
//  Created by kalyan on 3/29/26.
//

import Foundation
import CoreLocation
import Observation

@Observable
class LocationManager: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    var location: CLLocationCoordinate2D?
    var isLoading = false
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocation() {
        isLoading = true
        
        // Check authorization status
        let status = manager.authorizationStatus
        
        switch status {
        case .notDetermined:
            #if os(macOS)
            manager.requestAlwaysAuthorization()
            #else
            manager.requestWhenInUseAuthorization()
            #endif
        #if os(macOS)
        case .authorizedAlways:
            manager.requestLocation()
        #else
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        #endif
        case .denied, .restricted:
            isLoading = false
            print("Location access denied")
        @unknown default:
            isLoading = false
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        
        #if os(macOS)
        if manager.authorizationStatus == .authorizedAlways {
            manager.requestLocation()
        }
        #else
        if manager.authorizationStatus == .authorizedWhenInUse || 
           manager.authorizationStatus == .authorizedAlways {
            manager.requestLocation()
        }
        #endif
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.location = location.coordinate
        isLoading = false
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
        isLoading = false
    }
}
