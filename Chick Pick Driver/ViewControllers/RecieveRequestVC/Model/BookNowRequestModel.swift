//
//  RequestModel.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 30/04/19.
//  Copyright © 2019 baps. All rights reserved.
//

import Foundation
import SwiftyJSON

struct  BookNowRequestModel {
    
    var bookingId : Int!
    var bookingType : String!
    var driverId : Int!
    var dropoffLocation : String!
    var grandTotal : String!
    var message : String!
    var parcelImage : String!
    var paymentType : String!
    var pickupLocation : String!
    var rideType : String!
    var type : String!
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        bookingId = json["BookingId"].intValue
        bookingType = json["BookingType"].stringValue
        driverId = json["DriverId"].intValue
        dropoffLocation = json["DropoffLocation"].stringValue
        grandTotal = json["GrandTotal"].stringValue
        message = json["message"].stringValue
        parcelImage = json["ParcelImage"].stringValue
        let parcelInfoJson = json["ParcelInfo"]
        if !parcelInfoJson.isEmpty{
        }
        paymentType = json["PaymentType"].stringValue
        pickupLocation = json["PickupLocation"].stringValue
        rideType = json["RideType"].stringValue
        type = json["type"].stringValue
    }

}
struct  BookLaterRequestModel {
    
    var message : String!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
       message = json["message"].stringValue
    }
}
