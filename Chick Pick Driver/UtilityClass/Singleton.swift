//
//  Singleton.swift
//  Pappea Driver
//
//  Created by Apple on 19/07/19.
//  Copyright © 2019 baps. All rights reserved.
//

import Foundation
import CoreLocation

class Singleton {
    
    static let shared = Singleton()


    var RegisterOTP = String()
    var walletBalance = String()
    var vehicleListData : VehicleListResultModel?
    var companyListData : CompanyListModel?
    var menufacturingYearList = [String]()



     /// Driver login details
    var userProfile: LoginModel?
    
    /// Get driver ID
    var driverId = ""
    
    /// Get device token
    var token = ""
    
    /// Check Is driver is online or offline
    var isDriverOnline = false
    
    /// My current wallet balance
    var currentBalance = "0"
    
    /// Get driver currentLocation
    var driverLocation = CLLocation()
    
    /// Booking data while acceptd or started trip
    var bookingInfo: BookingInfo?
    
    /// While send to client build some features not everything
    var isClientBuild = true
}

//class Singleton: NSObject
//{
//    static let sharedInstance = Singleton()
//
//    var RegisterOTP = String()
//    var walletBalance = String()
//    var vehicleListData : VehicleListResultModel?
//    var companyListData : CompanyListModel?
//    var menufacturingYearList = [String]()
//}
