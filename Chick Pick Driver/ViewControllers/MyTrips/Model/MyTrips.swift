//
//  MyTrips.swift
//  Pappea Driver
//
//  Created by EWW-iMac Old on 05/07/19.
//  Copyright © 2019 baps. All rights reserved.
//

import Foundation

enum MyTrips: String, CaseIterable {
    
    case past = "Past"
    case upcoming = "Upcoming"
    case ongoing = "Pending"
    
    func getDescription(pastBookingHistory : PastBookingHistoryResponse) -> [(String, String)]{
            switch self {
            case .past:
                return setPastDescription(pastBookingHistory: pastBookingHistory)
            case .upcoming:
                return setUpcomingDescription(pastBookingHistory: pastBookingHistory)
            case .ongoing:
                return setUpcomingDescription(pastBookingHistory: pastBookingHistory)
                
            }
        }
  
//    func getDescription() -> [(String, String)]{
//        switch self {
//        case .past:
//            return setPastDescription()
//        case .upcoming:
//            return setUpcomingDescription()
//
//        case .ongoing:
//            return setUpcomingDescription()
//        }
//    }
    
    static var titles = MyTrips.allCases.map({$0.rawValue})
    
    fileprivate func setPastDescription(pastBookingHistory : PastBookingHistoryResponse) -> [(String, String)]{
        
        if pastBookingHistory.status == "canceled" {
            
            if pastBookingHistory.cancelBy != "passenger" {
                let tempArray = [("Status" , "Cancelled"), ("Cancellation Charges" , "\(Currency) \(pastBookingHistory.cancellationCharge ?? "")"), ("Grand Total" , "\(Currency) \(pastBookingHistory.grandTotal ?? "")")]
                return tempArray
                
            } else {
                let tempArray = [("Status" , "Cancelled")]
                return tempArray
            }
        } else {
            var tempArray = [("Pickup Time" , UtilityClass.convertTimeStampToFormat(unixtimeInterval: pastBookingHistory.pickupTime, dateFormat: "dd-MM-YYYY HH:mm:ss")),
                             ("Drop Off Time" , UtilityClass.convertTimeStampToFormat(unixtimeInterval: pastBookingHistory.dropoffTime, dateFormat: "dd-MM-YYYY HH:mm:ss")),
                             ("Vehicle Model" , pastBookingHistory.vehicleName),
                             ("Trip Distance", "\(pastBookingHistory.distance ?? "0") km"),
                             ("Trip Duration", UtilityClass.convertTimeStampToFormat(unixtimeInterval: pastBookingHistory.tripDuration, dateFormat: "HH:mm:ss")),
                             ("Base Fare", "\(Currency) \(pastBookingHistory.baseFare ?? "0")"),
                             ("Distance Fare", "\(Currency) \(pastBookingHistory.distanceFare ?? "0")"),
                             ("Subtotal" , "\(Currency) \(pastBookingHistory.subTotal ?? "0")"),
                             ("Discount" , "\(Currency) \(pastBookingHistory.discount ?? "")"),
                             ("Grand Total" ,"\(Currency) \(pastBookingHistory.grandTotal ?? "")"),
                             ("Payment Status", pastBookingHistory.paymentStatus),
                             ("Trip Status", pastBookingHistory.status.capitalized)
                ] as [Any]
            
            
            if(pastBookingHistory.promocode.count != 0)
            {
                tempArray.insert( ("Promocode" , pastBookingHistory.promocode), at: tempArray.count-1)
            }
            return tempArray as! [(String, String)]
        }
    }

//    fileprivate func setPastDescription() -> [(String, String)]
//    {
//        return [("Title" ,"Past"),
//                ("PickupLocation" , "Obj pickupLocation"),
//                ("DropoffLocation" , "Obj dropoffLocation"),
//                ("Date" , "Obj pickupDateTime"),
//                ("BookingId" , "Obj id")]
//    }
    
    fileprivate func setFutureDescription(section: Int)
    {
        
    }
    
//    fileprivate func setUpcomingDescription() -> [(String, String)]{
//        return [("Title" ,"Upcoming"),
//                ("PickupLocation" , "Obj pickupLocation"),
//                ("DropoffLocation" , "Obj dropoffLocation"),
//                ("Date" , "Obj pickupDateTime"),
//                ("BookingId" , "Obj id"),
//                ("PickupLocation" , "Obj pickupLocation"),
//                ("DropoffLocation" , "Obj dropoffLocation"),
//                ("Date" , "Obj pickupDateTime"),
//                ("BookingId" , "Obj id")]
//    }
    
    fileprivate func setUpcomingDescription(pastBookingHistory : PastBookingHistoryResponse) -> [(String, String)]{
        
        let inter = TimeInterval("\(pastBookingHistory.pickupDateTime!)") ?? 0
        let date = Date(timeIntervalSince1970: inter)
        let dateFormatter = DateFormatter()
        //        dateFormatter.locale = Locale.currentf
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss" //Specify your format that you want
        var strDate = dateFormatter.string(from: date)
        
        if pastBookingHistory.pickupDateTime == "" {
            strDate = "N/A"
        }
        
        return [("Pickup Time" , strDate),
                ("Trip Status" , pastBookingHistory.status.capitalized)]
    }
}
