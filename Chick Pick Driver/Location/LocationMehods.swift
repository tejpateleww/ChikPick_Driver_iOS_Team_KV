//
//  LocationMehods.swift
//  Pappea Driver
//
//  Created by Apple on 19/07/19.
//  Copyright © 2019 baps. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import GoogleMaps


// ----------------------------------------------------
// MARK: - Location Methods
// ----------------------------------------------------

extension HomeViewController: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else {
            return
        }
        
    
        Singleton.shared.driverLocation = location
        mapView.mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: zoomLevel, bearing: 0, viewingAngle: 0)
//        mapView.customMap.addLocation(location: location)
        

        if Singleton.shared.driverId != "" && Singleton.shared.isDriverOnline {
            getDriverLocation()
        } else {
//            manager.stopUpdatingLocation()
        }
        
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            break
        case .denied:
            //            mapView.isHidden = false
            break
        case .notDetermined:
            break
        case .authorizedAlways:
            manager.startUpdatingLocation()
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // print (error)
        if (error as? CLError)?.code == .denied {
            manager.stopUpdatingLocation()
            manager.stopMonitoringSignificantLocationChanges()
        }
    }
}

