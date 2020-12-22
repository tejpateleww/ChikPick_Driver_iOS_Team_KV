//
//  SideMenuCase.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 10/05/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit

enum SideMenuCase: String, CaseIterable{
    
    case home = "Home"
    case myTrip = "My Trips"
    case myRating = "My Ratings"
    case tripToDestination = "Trip To Destination"
//    case payments = "Payments"
    case settings = "Settings"
//    case wallet = "Wallet"
    
//    case onDemand = "On Demand Area"
    
//    case airportQueue = "Airport Queue Management"
//    case bidMyTrip = "Bid My Trip"
//    case invite = "Invite"
//    case logout = "Logout"
    
    
    static var width : CGFloat {
        return 280
    }
}
