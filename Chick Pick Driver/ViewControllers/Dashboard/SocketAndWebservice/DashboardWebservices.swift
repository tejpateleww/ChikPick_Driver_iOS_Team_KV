//
//  DashboardWebservices.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 03/05/19.
//  Copyright © 2019 baps. All rights reserved.
//

import Foundation

protocol DashboardWebservices {
        
    //-------------------------------------------------------------
    // MARK: - Webservice Methods Current Booking
    //-------------------------------------------------------------
    func webserviceOfCurrentBooking()
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods Change Duty
    //-------------------------------------------------------------
    func webserviceForChangeDuty()
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods Get Passenger Location Distance
    //-------------------------------------------------------------
    func getPassengerLocationDistance()
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods Cancel Trip After Accepted Trip
    //-------------------------------------------------------------
    func cancelTripAfterAccept()
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods Did Rating Is Submit Successfully
    //-------------------------------------------------------------
    func didRatingIsSubmitSuccessfully()
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods For Completeing Current Booking
    //-------------------------------------------------------------
    func webserviceCallForCompleteTrip(dictOFParam : AnyObject)
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods For Completeing Advance Booking
    //-------------------------------------------------------------
    func webserviceCallForAdvanceCompleteTrip(dictOFParam : AnyObject)
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods Sign Out
    //-------------------------------------------------------------
    func webserviceOFSignOut()
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods Running Trip Track
    //-------------------------------------------------------------
    func webserviceOfRunningTripTrack()
    
    //-------------------------------------------------------------
    // MARK: - Trip Bookings
    //-------------------------------------------------------------
    func btnRoadPickUp(_ sender: Any)
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods Calculate Distance And Price
    //-------------------------------------------------------------
    func calculateDistanceAndPrice()
    
}
