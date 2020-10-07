//
//  DashboardWebserviceList.swift
//  Pappea Driver
//
//  Created by Apple on 22/07/19.
//  Copyright © 2019 baps. All rights reserved.
//

import Foundation
import UIKit

extension HomeViewController: DashboardWebservices {
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods Cancel Trip After Accepted Trip
    //-------------------------------------------------------------
    func cancelTripAfterAccept() {
        let model = CompleteModel()
        model.booking_id = Singleton.shared.bookingInfo?.id ?? ""
        
        UserWebserviceSubclass.CancelTripService(cancelTripDetailModel: model) { (response, status) in
            if status {
                Singleton.shared.bookingInfo = nil
                self.getFirstView()
            } else {
                UtilityClass.showAlert(message: response.dictionary?["message"]?.stringValue ?? "Cancel trip is not possible due to some reason, \nPlease restart application.")
            }
        }
    }
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods Current Booking
    //-------------------------------------------------------------
    func webserviceOfCurrentBooking() {
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods Change Duty
    //-------------------------------------------------------------
    func webserviceForChangeDuty() {
        
        let model = ChangeDutyStatus()
        model.driver_id = Singleton.shared.driverId
        model.lat = "\(Singleton.shared.driverLocation.coordinate.latitude)"
        model.lng = "\(Singleton.shared.driverLocation.coordinate.longitude)"
        UserWebserviceSubclass.changeDuty(transferMoneyModel: model) { (response, status) in
            
            if status {
                
                let duty = response.dictionaryValue["duty"]?.stringValue ?? ""
                _ = response.dictionaryValue["message"]?.stringValue ?? ""
                
                if duty == "online" {
                    Singleton.shared.isDriverOnline = true
                    SocketIOManager.shared.establishConnection()
                    self.updateDriverLocation()
                    self.driverData.driverState = .available // added for frequent location update
                    self.switchBtn.setOn(true, animated: true)
                    self.offlineView.isHidden = true
                    if self.constantHeightOfOfflineView != nil {
                        self.constantHeightOfOfflineView.constant = 0
                    }
                    UIView.animate(withDuration: 0.3) {
                        self.view.layoutIfNeeded()
                    }
                } else {
                    Singleton.shared.isDriverOnline = false
                    SocketIOManager.shared.closeConnection()
                    self.driverData.driverState = .tripComplete // added for stop timer
                    self.switchBtn.setOn(false, animated: true)
                    if self.constantHeightOfOfflineView != nil {
                        self.constantHeightOfOfflineView.constant = 60
                    }
                    self.offlineView.isHidden = false

                    UIView.animate(withDuration: 0.3) {
                        self.view.layoutIfNeeded()
                    }
                }
                self.getFirstView()
            } else {
               AlertMessage.showMessageForError(response["message"].stringValue)
                self.switchBtn.setOn(false, animated: true)
            }
        }
    }
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods Get Passenger Location Distance
    //-------------------------------------------------------------
    func getPassengerLocationDistance() {
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods Did Rating Is Submit Successfully
    //-------------------------------------------------------------
    func didRatingIsSubmitSuccessfully() {
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods For Completeing Current Booking
    //-------------------------------------------------------------
    func webserviceCallForCompleteTrip(dictOFParam : AnyObject) {

        let model = CompleteModel()
        model.booking_id = dictOFParam["booking_id"] as! String
        model.dropoff_lat = dictOFParam["dropoff_lat"] as! String
        model.dropoff_lng = dictOFParam["dropoff_lng"] as! String
        UserWebserviceSubclass.CompleteTripService(MobileNoDetailModel: model) { (response, status) in
            if status {
                
                let res = response.dictionary?["data"]
                Singleton.shared.bookingInfo = BookingInfo(fromJson: res)
                self.getLastView()
                Singleton.shared.bookingInfo = nil
                
//                let myMapView = MapView()
                self.driverData.driverState = .available
                self.resetMap()
               
            } else {
                 AlertMessage.showMessageForError(response["message"].stringValue)
            }
        }
    }

    
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods For Completeing Advance Booking
    //-------------------------------------------------------------
    func webserviceCallForAdvanceCompleteTrip(dictOFParam : AnyObject) {
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods Sign Out
    //-------------------------------------------------------------
    func webserviceOFSignOut() {
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods Running Trip Track
    //-------------------------------------------------------------
    func webserviceOfRunningTripTrack() {
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Trip Bookings
    //-------------------------------------------------------------
    func btnRoadPickUp(_ sender: Any) {
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods Calculate Distance And Price
    //-------------------------------------------------------------
    func calculateDistanceAndPrice() {
        
    }
    
}
