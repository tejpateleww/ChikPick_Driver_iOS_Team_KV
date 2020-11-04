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
    
    /// Booking data while acceptd or started trip
    var bookingInfoLoginModel: BookingInfoLoginModel?
    
    /// Driver cancellation charges
    var cancelltionFee: String?
    
    /// Driver cancellation charges
    var cancelltionCharges: [CancellationCharge]?
    
    /// While send to client build some features not everything
    var isClientBuild = true
    
    
    func clearSingletonClass() {
        RegisterOTP = String()
        walletBalance = String()
        vehicleListData = VehicleListResultModel()
        companyListData = CompanyListModel()
        menufacturingYearList = [String]()
        
        /// Driver login details
        userProfile = LoginModel()
        
        /// Get driver ID
        driverId = ""
        
        /// Get device token
        token = ""
        
        /// Check Is driver is online or offline
        isDriverOnline = false
        
        /// My current wallet balance
        currentBalance = "0"
        
        /// Get driver currentLocation
        driverLocation = CLLocation()
        
        /// Booking data while acceptd or started trip
        bookingInfo = BookingInfo()
        
        /// Booking data while acceptd or started trip
        bookingInfoLoginModel = BookingInfoLoginModel()
        
        /// Driver cancellation charges
        cancelltionFee = String()
        
        /// Driver cancellation charges
        cancelltionCharges = [CancellationCharge]()
        
        /// While send to client build some features not everything
        isClientBuild = false
    }
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
