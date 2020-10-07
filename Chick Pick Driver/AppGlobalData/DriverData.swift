//
//  DriverData.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 11/05/19.
//  Copyright © 2019 baps. All rights reserved.
//

import Foundation
import GooglePlaces
import GooglePlacePicker
import GoogleMaps
import CoreLocation

struct DriverData {
    static var shared = DriverData()
    
    var driverState = DriverState.available
    {
        didSet
        {
            if(driverState == .available)
            {
                if let homeVC = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.children.first?.children.first as? HomeViewController
                {
                    homeVC.updateDriverLocationAtRegularInterval = Timer.scheduledTimer(timeInterval: 10, target: homeVC, selector: #selector(homeVC.updateDriverLocation), userInfo: nil, repeats: true)
                }
            }
            else
            {
                if let homeVC = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.children.first?.children.first as? HomeViewController
                {
                    if homeVC.updateDriverLocationAtRegularInterval != nil {
                        homeVC.updateDriverLocationAtRegularInterval.invalidate()
                        homeVC.updateDriverLocationAtRegularInterval = nil
                    }
                }
            }
        }
    }

    private(set) var profile: LoginModel!
    
    private init(){
        let defaults = UserDefaults.standard
        do{
            try self.profile = defaults.get(objectType: LoginModel.self, forKey: "userProfile")
        }
        catch {
            print("Driver Profile not found")
        }
    }
}


