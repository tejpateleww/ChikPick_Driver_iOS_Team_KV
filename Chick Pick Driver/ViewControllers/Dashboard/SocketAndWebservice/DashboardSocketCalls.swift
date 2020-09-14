//
//  DashboardSocketCalls.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 29/04/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit

extension HomeViewController: SocketConnected {
  
    // ----------------------------------------------------
    // MARK:- --- All Socket Methods ---
    // MARK:-
    // ----------------------------------------------------
    
    // Socket Off All
    func allSocketOffMethods() {
        
        SocketIOManager.shared.socket.off(socketApiKeys.WhenRequestArrived.rawValue)        // Socket Off 1
        SocketIOManager.shared.socket.off(socketApiKeys.AcceptRequest.rawValue)             // Socket Off 2
        SocketIOManager.shared.socket.off(socketApiKeys.StartTrip.rawValue)                 // Socket Off 3
        SocketIOManager.shared.socket.off(socketApiKeys.onTheWayBookingRequest.rawValue)    // Socket Off 4
        SocketIOManager.shared.socket.off(socketApiKeys.receiveTips.rawValue)               // Socket Off 5
        SocketIOManager.shared.socket.off(socketApiKeys.cancelTrip.rawValue)                // Socket Off 6
        SocketIOManager.shared.socket.off(clientEvent: .disconnect)                         // Socket Disconnect
    }

    /// Socket On All
    func allSocketOnMethods() {
        
        onSocket_ReceiveBookingRequest()        // Socket On 1
        onSocket_AfterAcceptingRequest()        // Socket On 2
        onSocket_StartTrip()                    // Socket On 3
        onSocket_OnTheWayBookLater()            // Socket On 4
        onSocket_ReceiveTips()                  // Socket On 5
        onSocket_CancelTrip()                   // Socket On 6
    }
    
    // ----------------------------------------------------
    // MARK:- --- Socket Emit Methods ---
    // MARK:-
    // ----------------------------------------------------
    
    // Socket Emit 1
    func emitSocket_UpdateDriverLatLng(param: [String : Any]) {
        SocketIOManager.shared.socketEmit(for: socketApiKeys.updateDriverLocation.rawValue, with: param)
    }
    
    // Socket Emit 2
    func emitSocket_AcceptRequest(param: [String : Any]) {
        SocketIOManager.shared.socketEmit(for: socketApiKeys.AcceptRequest.rawValue, with: param)
    }
    
    // Socket Emit 3
    func emitSocket_RejectRequest(param: [String:Any]) {
        SocketIOManager.shared.socketEmit(for: socketApiKeys.RejectRequest.rawValue, with: param)
        if let homeVC = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.children.first?.children.first as? HomeViewController {
            homeVC.stopProgress()
            homeVC.getFirstView()
        }
    }
    
    // Socket Emit 4
    func emitSocket_StartTrip(param: [String : Any]) {
        SocketIOManager.shared.socketEmit(for: socketApiKeys.StartTrip.rawValue, with: param)
    }
    
    // Socket Emit 5
    func emitSocket_OnTheWayBookingRequest(param: [String : Any]) {
        SocketIOManager.shared.socketEmit(for: socketApiKeys.onTheWayBookingRequest.rawValue, with: param)
    }
    
    // Socket Emit 6
    func emitSocket_AskForTips(param: [String:Any]) {
        SocketIOManager.shared.socketEmit(for: socketApiKeys.askForTips.rawValue, with: param)
    }
    
    // ----------------------------------------------------
    // MARK:- --- Socket On Methods ---
    // MARK:-
    // ----------------------------------------------------
   
    // Socket On 1
    func onSocket_ReceiveBookingRequest() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.WhenRequestArrived.rawValue){ json in
            print(#function)
            print("\n \(json)")
            AlertMessage.showMessageForSuccess(#function)
            
            let booking = bookingAcceptedeDataModel(fromJson: json.array?.first)
            Singleton.shared.bookingInfo = booking.bookingInfo
            
            self.presentView = self.presentType.chooseTripMode(state: .request)
            self.bottomContentView?.customAddSubview(self.presentView)
            self.containerBottomConstraint.constant = 0
            
            if let homeVC = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.children.first?.children.first as? HomeViewController {
                homeVC.setProgress()
            }
        }
    }
    
    // Socket On 2
    func onSocket_AfterAcceptingRequest() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.AcceptRequest.rawValue){ json in
            print(#function)
            print("\n \(json)")
            
            if let homeVC = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.children.first?.children.first as? HomeViewController {
                homeVC.stopProgress()
                if let bookingView = homeVC.presentView as? BookingView {
                    bookingView.isAccepted = true
                    bookingView.isArrived = false
                    bookingView.isStartTrip = false
                    bookingView.setConstraintOfHomeVc()
                    bookingView.setRequestAcceptedView()

                    
                    // Arrived Action
                    bookingView.txtDropOff.becomeFirstResponder()
                    bookingView.isAccepted = false
                    bookingView.isArrived = true
                    bookingView.isStartTrip = false
                    bookingView.setConstraintOfHomeVc()
                    bookingView.setStartTripView()
                    
                    DispatchQueue.main.async {
                        bookingView.txtDropOff.resignFirstResponder()
                    }
                    DispatchQueue.main.async {
                        bookingView.resignFirstResponder()
                    }
                    
                }
                
//                if homeVC.mapView != nil {
                    self.bookingData = Singleton.shared.bookingInfo!
                    self.driverData.driverState = .requestAccepted
                    self.resetMap()
//                }

            }
            let message = json.first?.1.dictionary?["message"]?.stringValue
            AlertMessage.showMessageForSuccess(message ?? "Booking Request Accepted")
        }
    }
    
    // Socket On 3
    func onSocket_StartTrip() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.StartTrip.rawValue){ json in
            print(#function)
            print("\n \(json)")
            
            if ((UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.children.first?.children.first as? HomeViewController) != nil {
                    self.bookingData = Singleton.shared.bookingInfo!
                    self.driverData.driverState = .inTrip
                    self.resetMap()
            }
            AlertMessage.showMessageForSuccess(#function)
        }
    }
    
    // Socket On 4
    func onSocket_OnTheWayBookLater() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.onTheWayBookingRequest.rawValue){ json in
            print(#function)
            print("\n \(json)")
            AlertMessage.showMessageForSuccess(#function)
        }
    }
    
    // Socket On 5
    func onSocket_ReceiveTips() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.receiveTips.rawValue){ json in
            print(#function)
            print("\n \(json)")
            
            if ((UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.children.first?.children.first as? HomeViewController) != nil {
                    self.resetMap()

            }
            
            
            if let msg = json.array?.first?.dictionary?["message"] {
                AlertMessage.showMessageForSuccess(msg.stringValue)
            }
            
            var param = [String: Any]()            
            param["booking_id"] = Singleton.shared.bookingInfo?.id
            param["dropoff_lat"] = Singleton.shared.bookingInfo?.dropoffLat
            param["dropoff_lng"] = Singleton.shared.bookingInfo?.dropoffLng
            self.webserviceCallForCompleteTrip(dictOFParam: param as AnyObject)
        }
    }
    
    // Socket On 6
    func onSocket_CancelTrip() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.cancelTrip.rawValue){ json in
            print(#function)
            print("\n \(json)")
            if let msg = json.array?.first?.dictionary?["message"] {
                AlertMessage.showMessageForSuccess(msg.stringValue)
                
                 if let homeVC = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.children.first?.children.first as? HomeViewController {
                        homeVC.getFirstView()
                        self.driverData.driverState = .available

                }
            }
        }
    }

    @objc func updateDriverLocation(){
        
        self.locationManager.startUpdatingLocation()
        
        if DriverData.shared.profile != nil {
            if let driver = DriverData.shared.profile.profile {
                
                let myJSON = [profileKeys.kDriverId : driver.id,RegistrationFinalKeys.kLat: "\(Singleton.shared.driverLocation.coordinate.latitude)",RegistrationFinalKeys.kLng: "\(Singleton.shared.driverLocation.coordinate.longitude)","Token": driver.token] as [String : Any]
                emitSocket_UpdateDriverLatLng(param: myJSON)
            }
        }
    }
}


