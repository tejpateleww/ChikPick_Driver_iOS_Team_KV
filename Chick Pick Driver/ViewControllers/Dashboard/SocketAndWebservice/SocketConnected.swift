//
//  SocketMethods.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 29/04/19.
//  Copyright © 2019 baps. All rights reserved.
//

import Foundation
import  SwiftyJSON
typealias CompletionBlock = ((JSON) -> ())?


protocol SocketConnected{
   
    //var isSocketConnected: Bool { get set }
    
    // ----------------------------------------------------
    // MARK:- --- All Socket Methods ---
    // ----------------------------------------------------
    /// Socket On All
    
    func onSocket_ReceiveBookingRequest()
    
    func onSocket_AfterAcceptingRequest()
    
    func onSocket_StartTrip()
    
    func onSocket_OnTheWayBookLater()
    
    func onSocket_ReceiveTips()
    
    func onSocket_CancelTrip()
    
    func onSocket_RequestCodeForCompleteTrip()
    
    func onSocket_ArrivedAtPickupLocation()
    
    func onSocket_DriverArrived()
    
    func onSocket_UpdateDriverLocation()
    
    func onSocket_VerifyCustomer()
    
//    func socketCallForReceivingBookingRequest()
//    
//    func receiveBookLaterBookingRequest()
//
//    func updateDriverLocation()
//
//    func cancelBookLaterTripByCancelNotification()
//
//    func getBookingDetailsAfterBookingRequestAccepted()
//
//    func getAdvanceBookingDetailsAfterBookingRequestAccepted()
//
//    func cancelTripByPassenger()
//
//    func newBookLaterRequestArrivedNotification()
//
//    func getNotificationForReceiveMoneyNotify()
//
//    func onSessionError()
//
//    func getTimeOfStartTrip()
//
//    func getNotificationforReceiveTip()
//
//    func getNotificationforReceiveTipForBookLater()
//
//    func onAdvancedBookingPickupPassengerNotification()
    
}
