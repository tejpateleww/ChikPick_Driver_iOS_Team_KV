//
//  MyTrips.swift
//  Pappea Driver
//
//  Created by EWW-iMac Old on 05/07/19.
//  Copyright © 2019 baps. All rights reserved.
//

import Foundation

enum MyTrips: String, CaseIterable{
    
    case past = "Past"
    case upcoming = "Upcoming"
    case ongoing = "On Going"
    
  
    func getDescription() -> [(String, String)]{
        switch self {
        case .past:
            return setPastDescription()
        case .upcoming:
            return setUpcomingDescription()
            
        case .ongoing:
            return setUpcomingDescription()
        }
    }
    static var titles = MyTrips.allCases.map({$0.rawValue})
    fileprivate func setPastDescription() -> [(String, String)]
    {
        return [("Title" ,"Past"),
                ("PickupLocation" , "Obj pickupLocation"),
                ("DropoffLocation" , "Obj dropoffLocation"),
                ("Date" , "Obj pickupDateTime"),
                ("BookingId" , "Obj id")]
    }
    
    fileprivate func setFutureDescription(section: Int)
    {
        
    }
    
    fileprivate func setUpcomingDescription() -> [(String, String)]{
        return [("Title" ,"Upcoming"),
                ("PickupLocation" , "Obj pickupLocation"),
                ("DropoffLocation" , "Obj dropoffLocation"),
                ("Date" , "Obj pickupDateTime"),
                ("BookingId" , "Obj id"),
                ("PickupLocation" , "Obj pickupLocation"),
                ("DropoffLocation" , "Obj dropoffLocation"),
                ("Date" , "Obj pickupDateTime"),
                ("BookingId" , "Obj id")]
    }
}
