//
//  MapView.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 29/04/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit
import GooglePlaces
import GooglePlacePicker
import GoogleMaps
import CoreLocation

class MapView: UIView, CLLocationManagerDelegate, ARCarMovementDelegate{
    var customMap = Map()
    
    var driverData = DriverData.shared
    let carMovement = ARCarMovement()
    
    lazy var mapView = GMSMapView.map(withFrame: frame, camera: customMap.camera)
    var driverMarker = GMSMarker()
    var destinationMarker = GMSMarker()
    var bookingData = BookingInfo()
    
    override func draw(_ rect: CGRect) {
        customMap.marker.map = mapView

        carMovement.delegate = self
        do {
            if let styleURL = Bundle.main.url(forResource: "styleMap", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            }
        } catch {
            print(error.localizedDescription)
        }
        
        addSubview(mapView)
        
        if let appdelegate = UIApplication.shared.delegate as? AppDelegate {
            appdelegate.resetMap = resetMap
        }
    }
    
    func arCarMovementMoved(_ marker: GMSMarker) {
        customMap.marker = marker
        driverMarker.map = mapView
    }
    
    func clearMapData() {
        mapView.clear()
    }
    
    func resetMap(){
        
        mapView.animate(to: customMap.camera)
        mapView.clear()
        switch driverData.driverState {
       
        case .requestAccepted:
            let originLocation = "\(Singleton.shared.driverLocation.coordinate.latitude),\(Singleton.shared.driverLocation.coordinate.longitude)"
            let destinationLocation = "\(bookingData.pickupLat ?? ""),\(bookingData.pickupLng ?? "")"
            drawRouteOnGoogleMap(origin: originLocation, destination: destinationLocation, waypoints: nil, travelMode: nil, fromMarker: nil, toMarker: nil, completionHandler: nil)
        case .inTrip:
            let originLocation = "\(Singleton.shared.driverLocation.coordinate.latitude),\(Singleton.shared.driverLocation.coordinate.longitude)"
            let destinationLocation = "\(bookingData.dropoffLat ?? ""),\(bookingData.dropoffLng ?? "")"
            drawRouteOnGoogleMap(origin: originLocation, destination: destinationLocation, waypoints: nil, travelMode: nil, fromMarker: nil, toMarker: nil, completionHandler: nil)
        default:
            break
//            carMovement.arCarMovement(marker: customMap.marker, oldCoordinate: customMap.previousLocation.coordinate, newCoordinate: customMap.presentLocation.coordinate, mapView: mapView, bearing: Float(2))
        }
    }
    
   
}

