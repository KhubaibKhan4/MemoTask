//
//  LocationManager.swift
//  Notes
//
//  Created by Muhammad Khubaib Imtiaz on 25/11/2024.
//
import Foundation
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    @Published var lastKnownLocation: CLLocationCoordinate2D?
    var manager = CLLocationManager()
    
    func checkLocationAuthorization() {
        manager.delegate = self
        manager.startUpdatingLocation()
    
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted:
            print("Location Restricted")
        case .denied:
            print("Location Denied")
        case .authorizedAlways:
            print("Authorization Always")
        case .authorizedWhenInUse:
            print("Location Authorized when in use")
        @unknown default:
            print("Location Disabled..")
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocation location: [CLLocation]){
        lastKnownLocation = location.first?.coordinate
    }
}
