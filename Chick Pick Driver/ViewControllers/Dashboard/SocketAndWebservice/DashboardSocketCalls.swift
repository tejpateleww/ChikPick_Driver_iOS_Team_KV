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
        SocketIOManager.shared.socket.off(socketApiKeys.requestCodeForCompleteTrip.rawValue)// Socket Off 7
        SocketIOManager.shared.socket.off(socketApiKeys.arrivedAtPickupLocation.rawValue)   // Socket Off 8
        SocketIOManager.shared.socket.off(socketApiKeys.updateDriverLocation.rawValue)      // Socket Off 9
        SocketIOManager.shared.socket.off(socketApiKeys.verifyCustomer.rawValue)            // Socket Off 9
        SocketIOManager.shared.socket.off(socketApiKeys.LiveTracking.rawValue)            // Socket Off 10
        SocketIOManager.shared.socket.off(socketApiKeys.DriverLocation.rawValue)            // Socket Off 18
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
        onSocket_RequestCodeForCompleteTrip()   // Socket On 7
        onSocket_ArrivedAtPickupLocation()      // Socket On 8
        onSocket_UpdateDriverLocation()         // Socket On 9
        onSocket_VerifyCustomer()               // Socket On 9
        onSocket_DriverArrived()                // Socket On 18
        onSocket_CancelBookingBeforeAccept()    // Socket On 18
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
        print(#function)
        SocketIOManager.shared.socketEmit(for: socketApiKeys.RejectRequest.rawValue, with: param)
        Singleton.shared.bookingInfo = nil
        if let homeVC = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.children.first?.children.first as? HomeViewController {
//            Singleton.shared.bookingInfo = nil
            homeVC.stopProgress()
            homeVC.getFirstView(isDriverInfoUpdated: false)
        }
    }
    
    func emitSocket_RejectRequestForMultipleRequest(param: [String:Any]) {
        print(#function)
        SocketIOManager.shared.socketEmit(for: socketApiKeys.RejectRequest.rawValue, with: param)
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
    
    // Socket Emit 7
    func emitSocket_RequestCodeForCompleteTrip(param: [String:Any]) {
        SocketIOManager.shared.socketEmit(for: socketApiKeys.requestCodeForCompleteTrip.rawValue, with: param)
    }
    
    // Socket Emit 8
    func emitSocket_ArrivedAtPickupLocation(param: [String:Any]) {
        SocketIOManager.shared.socketEmit(for: socketApiKeys.arrivedAtPickupLocation.rawValue, with: param)
        print(#function)
    }
    
    // Socket Emit 9
    func emitSocket_VerifyCustomer(param: [String:Any]) {
        SocketIOManager.shared.socketEmit(for: socketApiKeys.verifyCustomer.rawValue, with: param)
        print(#function)
    }
    
    // Socket On 10
    func emitSocket_LiveTracking(param: [String:Any]) {
        SocketIOManager.shared.socketEmit(for: socketApiKeys.LiveTracking.rawValue, with: param)
        print(#function)
    }
    
    // Socket On 14
    func emitSocket_DriverLocation(param: [String:Any]) {
        SocketIOManager.shared.socketEmit(for: socketApiKeys.DriverLocation.rawValue, with: param)
//        print(#function)
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
            
            // TODO:- Uncomment for Rejecting 2nd request- Bhumi jani
            
            if Singleton.shared.bookingInfo != nil && Singleton.shared.bookingInfo?.id.count ?? 0 > 0 {
                var param = [String: Any]()
                let booking = bookingAcceptedeDataModel(fromJson: json.array?.first)
                param["driver_id"] = Singleton.shared.driverId
                param["booking_id"] = booking.bookingInfo.id
                self.emitSocket_RejectRequestForMultipleRequest(param: param)
                return
            }
            
            if (self.navigationController?.topViewController as? HomeViewController) == nil {
                if let homeVC = self.navigationController?.children.first {
                    self.navigationController?.popToViewController(homeVC, animated: true)
                }
            }
           
            let message = json.first?.1.dictionary?["message"]?.stringValue
            AlertMessage.showMessageForSuccess(message ?? "Booking Request Accepted")
            
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
            
            Loader.hideHUD()
            
            let message = json.first?.1.dictionary?["message"]?.stringValue
            AlertMessage.showMessageForSuccess(message ?? "Booking Request Accepted")
            
            if let bookingInfo = json.first?.1.dictionary?["booking_info"] {
                if bookingInfo["booking_type"] == "book_later" {
                    print("Book_later")
                    if let vc = self.navigationController?.children.last as? MyTripsViewController {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            vc.collectionTableView.loadTheSection(ofNumber: 2)
                        }
                    }
                }else {
                    self.setDataAfterAcceptingRequest()
                }
            }
        }
    }
    
    func setDataAfterAcceptingRequest()
    {
        if let homeVC = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.children.first?.children.first as? HomeViewController {
            homeVC.stopProgress()
            
            if let bookingView = homeVC.presentView as? BookingView {
                
                bookingView.btnAccept.isUserInteractionEnabled = true
                
                bookingView.isAccepted = true
                bookingView.isArrived = false
                bookingView.isStartTrip = false
                bookingView.setConstraintOfHomeVc()
                bookingView.setRequestAcceptedView()
                
                // Arrived Action
//                bookingView.txtDropOff.becomeFirstResponder()
                bookingView.isAccepted = false
                bookingView.isArrived = true
                bookingView.isStartTrip = false
                bookingView.setConstraintOfHomeVc()
                //                    bookingView.setStartTripView()
                bookingView.setRequestAcceptedView()
                
//                DispatchQueue.main.async {
//                    bookingView.txtDropOff.resignFirstResponder()
//                }
//                DispatchQueue.main.async {
//                    bookingView.resignFirstResponder()
//                }
            }
            //                if homeVC.mapView != nil {
//            self.bookingData = Singleton.shared.bookingInfo!
            self.driverData.driverState = .requestAccepted
            self.resetMap()
            //                }
        }
    }
    
    func setDataAfterDriverArrived()
    {
        if let homeVC = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.children.first?.children.first as? HomeViewController {
            homeVC.stopProgress()
            if let bookingView = homeVC.presentView as? BookingView {
               
                // Arrived Action
                bookingView.txtDropOff.becomeFirstResponder()
                bookingView.isAccepted = false
                bookingView.isArrived = true
                bookingView.isStartTrip = false
                bookingView.setConstraintOfHomeVc()
                bookingView.setStartTripView()
            }
//            self.bookingData = Singleton.shared.bookingInfo!
            self.driverData.driverState = .requestAccepted
            self.resetMap()
        }
    }
    
    // Socket On 3
    func onSocket_StartTrip() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.StartTrip.rawValue){ json in
            print(#function)
            print("\n \(json)")
            
            Loader.hideHUD()
            
            if ((UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.children.first?.children.first as? HomeViewController) != nil {
//                self.bookingData = Singleton.shared.bookingInfo!
                self.driverData.driverState = .inTrip
                self.resetMap()
            }
            let message = json.first?.1.dictionary?["message"]?.stringValue
            AlertMessage.showMessageForSuccess(message ?? "")
        }
    }
    
    // Socket On 4
    func onSocket_OnTheWayBookLater() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.onTheWayBookingRequest.rawValue){ json in
            print(#function)
            print("\n \(json)")
            self.navigationController?.popViewController(animated: true)
            Singleton.shared.bookingInfo = BookingInfo(fromJson: json.first?.1.dictionary?["booking_info"])
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.presentView = self.presentType.chooseTripMode(state: .request)
                self.bottomContentView?.customAddSubview(self.presentView)
                self.containerBottomConstraint.constant = 0
                self.setDataAfterAcceptingRequest()
            }
            
            let message = json.first?.1.dictionary?["message"]?.stringValue
            AlertMessage.showMessageForSuccess(message ?? "")
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
//                AlertMessage.showMessageForSuccess(msg.stringValue)
                AlertMessage.showMessageForError(msg.stringValue)
                Singleton.shared.bookingInfo = nil
//                if let homeVC = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.children.first?.children.first as? HomeViewController {
                    self.getFirstView(isDriverInfoUpdated: false)
                    self.driverData.driverState = .available
                    self.resetMap()
                    UserDefaults.standard.removeObject(forKey: "isDriverArrived")
//                }
            }
        }
    }
    
    // Socket On 18
    func onSocket_CancelBookingBeforeAccept() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.CancelBookingBeforeAccept.rawValue) { (json) in
            print(#function, "\n ", json)
            let titleMessage = json.array?.first?.dictionary?["message"]?.string ?? ""
//            AlertMessage.showMessageForSuccess(titleMessage)
            AlertMessage.showMessageForError(titleMessage)
            
            if let homeVC = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.children.first?.children.first as? HomeViewController {
                self.stopProgress()
                self.getFirstView(isDriverInfoUpdated: false)
                self.driverData.driverState = .available
                self.resetMap()
                UserDefaults.standard.removeObject(forKey: "isDriverArrived")
            }
        }
    }
    
    // Socket On 7
    func onSocket_RequestCodeForCompleteTrip() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.requestCodeForCompleteTrip.rawValue){ json in
            print(#function)
            print("\n \(json)")
            
            self.driverData.driverState = .lastCompleteView
            self.resetMap()
            
            let otp = json.array?.first?.dictionary?["otp"]?.string ?? ""
            
            let storyboard = UIStoryboard(name: "Popup", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "VerifyCustomerPopupViewController") as? VerifyCustomerPopupViewController {
                //                vc.strMessage = msg
                vc.strTitle = "Please Enter Complete Code From Customer To Complete This Trip"
                vc.strPlaceholder = "Enter Complete Code"
                vc.strOTP = otp
                vc.strBtnTitle = "Submit"
                vc.completeTripOnEndCode = { status in
                    print(status)
                    
                    if status {
                        var param = [String: Any]()
                        param["booking_id"] = Singleton.shared.bookingInfo?.id
                        param["dropoff_lat"] = Singleton.shared.bookingInfo?.dropoffLat
                        param["dropoff_lng"] = Singleton.shared.bookingInfo?.dropoffLng
                        self.webserviceCallForCompleteTrip(dictOFParam: param as AnyObject)
                    } else {
                        print("Fail webservice complete trip")
                        //                        self.present(vc, animated: true, completion: nil)
                    }
                }
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    // Socket On 8
    func onSocket_ArrivedAtPickupLocation() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.arrivedAtPickupLocation.rawValue){ json in
            print(#function)
            print("\n \(json)")
            
            Loader.hideHUD()
            
            if ((UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.children.first?.children.first as? HomeViewController) != nil {
                self.setDataAfterDriverArrived()
            }
            let message = json.first?.1.dictionary?["message"]?.stringValue
            AlertMessage.showMessageForSuccess(message ?? "")
        }
    }
    
    @objc func updateDriverLocation(){
        
        self.locationManager.startUpdatingLocation()
        
//        if Singleton.shared.driverId != nil {
//            if let driver = DriverData.shared.profile.responseObject {
                let token = UserDefaults.standard.object(forKey: "Token") as? String
                
                let myJSON = ["driver_id" : Singleton.shared.driverId, "lat": "\(Singleton.shared.driverLocation.coordinate.latitude)", "lng": "\(Singleton.shared.driverLocation.coordinate.longitude)","device_token": token ?? "123"] as [String : Any]
                emitSocket_UpdateDriverLatLng(param: myJSON)
//            }
//        }
    }
    
    // Socket On 9
    func onSocket_UpdateDriverLocation() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.updateDriverLocation.rawValue){ json in
            print(#function)
            print("\n \(json)")
        }
    }
    
    // Socket On 18
    func onSocket_DriverArrived() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.driverArrived.rawValue){ json in
            print(#function)
            print("\n \(json)")
           
            if Singleton.shared.bookingInfo?.arrivedTime.isEmpty ?? false {
                 UserDefaults.standard.set(false, forKey: "isDriverArrived")
            } else {
                UserDefaults.standard.set(true, forKey: "isDriverArrived")
                print("Driver arrived at pickup location")
            }
            
            if let homeVC = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.children.first?.children.first as? HomeViewController {
                //                homeVC.stopProgress()
//                if let bookingView = homeVC.presentView as? BookingView {
//                    if (UserDefaults.standard.object(forKey: "isDriverArrived") != nil) && UserDefaults.standard.object(forKey: "isDriverArrived") as? Bool != true {
//                         bookingView.btnArrive.setTitle("Arrive", for: .normal)
//                    } else {
//                         bookingView.btnArrive.setTitle("Start Request Code", for: .normal)
//                    }
//                }
            }
        }
    }
    
    // Socket On 7
    func onSocket_VerifyCustomer() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.verifyCustomer.rawValue){ json in
            print(#function)
            print("\n \(json)")
            
            let otp = json.array?.first?.dictionary?["otp"]?.string ?? ""
            
            let storyboard = UIStoryboard(name: "Popup", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "VerifyCustomerPopupViewController") as? VerifyCustomerPopupViewController {
                //                vc.strMessage = msg
                vc.strTitle = "Please Enter Start Code From Customer To Start This Trip"
                vc.strPlaceholder = "Enter Start Code"
                vc.strOTP = otp
                vc.strBtnTitle = "Submit"
                vc.completeTripOnEndCode = { status in
                    print(status)
                    
                    if status {
                        
                        if let homeVC = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.children.first?.children.first as? HomeViewController {
                            //                homeVC.stopProgress()
                            if let bookingView = homeVC.presentView as? BookingView {
                                // For Start Trip
                                if !bookingView.viewRequestAccepted.isHidden {
                                    bookingView.isAccepted = false
                                    bookingView.isArrived = false
                                    bookingView.isStartTrip = true
                                    bookingView.setConstraintOfHomeVc()
                                    bookingView.setTripView()
                                    
                                    guard let bookingData = Singleton.shared.bookingInfo else { return }
                                    var param = [String: Any]()
                                    param["booking_id"] = bookingData.id
                                    self.emitSocket_StartTrip(param: param)
                                }
                            } else {
                                // For Complete Trip
                                var param = [String: Any]()
                                param["booking_id"] = Singleton.shared.bookingInfo?.id
                                param["dropoff_lat"] = Singleton.shared.bookingInfo?.dropoffLat
                                param["dropoff_lng"] = Singleton.shared.bookingInfo?.dropoffLng
                                self.webserviceCallForCompleteTrip(dictOFParam: param as AnyObject)
                            }
                        }
                    } else {
                        print("Fail webservice complete/start trip")
                        //                        self.present(vc, animated: true, completion: nil)
                    }
                }
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
}


