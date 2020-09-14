//
//  BookingView.swift
//  Pappea Driver
//
//  Created by EWW-iMac Old on 02/07/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import MessageUI


class BookingView: UIView,MFMessageComposeViewControllerDelegate {


    @IBOutlet weak var imgPassenger: UIImageView!
    @IBOutlet weak var lblPassengerName: UILabel!
    @IBOutlet weak var lblTitleWaitingTime: UILabel!
    @IBOutlet weak var lblWaitingTime: UILabel!
   
    @IBOutlet weak var btnReject: UIButton!
    @IBOutlet weak var btnAccept: UIButton!
    
    @IBOutlet weak var txtPickup: SkyFloatingLabelTextField!
    @IBOutlet weak var txtDropOff: SkyFloatingLabelTextField!
    
    @IBOutlet weak var lblTripPrice: UILabel!
    @IBOutlet weak var lblTripDistance: UILabel!
    
    @IBOutlet weak var btnCancelTrip: UIButton!
    @IBOutlet weak var btnArrive: UIButton!
    @IBOutlet weak var btnStart: UIButton!
    
    @IBOutlet weak var btnCard: UIButton!
    @IBOutlet weak var btnDiscount: UIButton!
    
    @IBOutlet weak var btnStartWaitingTime: UIButton!
    
    @IBOutlet weak var btnEndWaitingTime: UIButton!
    @IBOutlet weak var btnCompleteTrip: UIButton!
    
    @IBOutlet weak var btnMessage: UIButton!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var btnNavigate: UIButton!

    @IBOutlet weak var viewAcceptReject: UIView!
    @IBOutlet weak var viewRequestAccepted: UIView!
    @IBOutlet weak var viewStartTrip: UIView!
    @IBOutlet weak var viewEndTrip: UIView!
    @IBOutlet weak var viewContactUs: UIStackView!
    @IBOutlet weak var viewEstimatePrice: UIStackView!
    @IBOutlet weak var viewWaitingTimer: UIStackView!
    
    var isArrived = Bool()
    var isStartTrip = Bool()
    var isAccepted = Bool()
    
   
    override func draw(_ rect: CGRect) {
        btnReject.submitButtonLayout(isDark: true)
        btnAccept.submitButtonLayout(isDark: true)
        btnCancelTrip.submitButtonLayout(isDark: true)
        btnArrive.submitButtonLayout(isDark: true)
        btnStartWaitingTime.submitButtonLayout(isDark: true)
        btnEndWaitingTime.submitButtonLayout(isDark: true)
        btnCompleteTrip.submitButtonLayout(isDark: true)
        btnStart.submitButtonLayout(isDark: true)
        
        btnCard.layer.cornerRadius = 3
        btnCard.clipsToBounds = true
        btnDiscount.layer.cornerRadius = 3
        btnDiscount.clipsToBounds = true
    }
    
    func setupData() {
       
        guard let profile = Singleton.shared.bookingInfo?.customerInfo else { return }
        lblPassengerName.text = (profile.firstName ?? "") + " " + (profile.lastName ?? "")
    
        let passengerImage = profile.profileImage
        imgPassenger.sd_setImage(with: URL(string: imagBaseURL + (passengerImage ?? "")), completed: nil)
        
        btnCard.setTitle("N/A", for: .normal)
        lblTripPrice.text = "N/A"
        btnDiscount.setTitle("N/A", for: .normal)
        lblTripDistance.text = "N/A"
        
        txtPickup.text = Singleton.shared.bookingInfo?.pickupLocation
        txtDropOff.text = Singleton.shared.bookingInfo?.dropoffLocation
    }
    
    private func requestView() {
        showAllViews()
        hideShowViews(hide: true, views: [viewStartTrip, viewEndTrip, viewContactUs, viewRequestAccepted])
    }
    
    func setRequestAcceptedView() {
//        showAllViews()
//        hideShowViews(hide: true, views: [viewStartTrip, viewAcceptReject,txtDropOff, viewEndTrip, viewEstimatePrice])
        showAllViews()
        hideShowViews(hide: true, views: [viewAcceptReject, txtDropOff, viewEndTrip, viewEstimatePrice, btnCompleteTrip, btnStart])
    }
    
    private func setArrivedView() {
        showAllViews()
        hideShowViews(hide: true, views: [viewAcceptReject, viewEndTrip, viewEstimatePrice,btnCompleteTrip])
    }
    
    func setStartTripView() {
        showAllViews()
        hideShowViews(hide: true, views: [viewAcceptReject, viewEndTrip, viewEstimatePrice, btnArrive, btnCompleteTrip])
    }
    
    private func setWaitingView() {
        showAllViews()
        hideShowViews(hide: true, views: [viewAcceptReject, viewRequestAccepted, viewStartTrip])
    }
    
    private func setTripView() {
        showAllViews()
        hideShowViews(hide: true, views: [viewAcceptReject, viewEndTrip, viewEstimatePrice, viewRequestAccepted])
    }
    
    func setCompleteTripView() {
        showAllViews()
        hideShowViews(hide: true, views: [viewStartTrip, viewEndTrip, viewContactUs, viewRequestAccepted])
    }
    
    private func setStopWaitingView() {
        showAllViews()
        hideShowViews(hide: true, views: [viewAcceptReject, txtDropOff, viewEndTrip, viewEstimatePrice, btnCompleteTrip])
    }
    
    private func setRequestRejectedView() {
        showAllViews()
        hideShowViews(hide: true, views: [viewAcceptReject, viewRequestAccepted, viewStartTrip, viewEndTrip, viewContactUs, txtDropOff, btnCompleteTrip, viewEstimatePrice, viewWaitingTimer, btnStart])
    }
    
    func setLastCompleteView() {
        showAllViews()
        hideShowViews(hide: true, views:[ viewAcceptReject, viewEndTrip, viewEstimatePrice, viewRequestAccepted])
    }
    
    func stopWaitingTimeFrom(beforeStartTrip: Bool) {
        showAllViews()
        
        if isAccepted {
            setRequestAcceptedView()
        } else if isArrived {
            showAllViews()
            hideShowViews(hide: true, views: [viewAcceptReject, txtDropOff, viewEndTrip, viewEstimatePrice, btnCompleteTrip, btnArrive])
        } else if isStartTrip {
            hideShowViews(hide: true, views:[viewAcceptReject, viewEndTrip, viewEstimatePrice, viewRequestAccepted])
        }
        
//        if beforeStartTrip {
////             setRequestAcceptedView()
//            if isStartTrip {
//                hideShowViews(hide: true, views:[viewAcceptReject, viewEndTrip, viewEstimatePrice, viewRequestAccepted])
//            }
//            else {
//                setRequestAcceptedView()
//            }
//        } else {
//
//            hideShowViews(hide: true, views:[viewAcceptReject, viewEndTrip, viewEstimatePrice, viewRequestAccepted])
//        }
    }
    
    private func showAllViews() {
        hideShowViews(hide: false, views: [viewAcceptReject,
            viewRequestAccepted,
            viewStartTrip,
            viewEndTrip,
            viewContactUs,
            txtDropOff,
            btnCompleteTrip,
            viewEstimatePrice,
            viewWaitingTimer, btnStart])
    }
    
    func setView(type: DriverState) {
        switch type {
        case .available:
            requestView()
            
        case .request:
            requestView()
            
        case .requestAccepted:
            setRequestAcceptedView()
            
        case .arrived:
            setArrivedView()
            
        case .waiting:
            setWaitingView()
            
        case .inTrip:
            setTripView()
            
        case .tripComplete:
            setCompleteTripView()
            
        case .requestRejected:
            setRequestRejectedView()
            
        case .cancelTrip:
            setRequestRejectedView()
            
        case .stopWaiting:
            setStopWaitingView()
            
        case .lastCompleteView:
            setCompleteTripView()
        }
    }
    
    // ----------------------------------------------------
    // MARK: - Button Actions
    // ----------------------------------------------------
    
    // Accept Trip
    @IBAction func btnAcceptAction(_ sender: UIButton) {
        print(#function)
        
//        isAccepted = true
//        isArrived = false
//        isStartTrip = false
//
//        setConstraintOfHomeVc()
//        setRequestAcceptedView()
        setConstraintOfHomeVc()
        guard let bookingData = Singleton.shared.bookingInfo else { return }
        var param = [String: Any]()
        param["driver_id"] = Singleton.shared.driverId
        param["booking_id"] = bookingData.id
        param["booking_type"] = bookingData.bookingType
        
        if let vc: UIViewController = self.parentViewController {
            if let hVc = vc as? HomeViewController {
                hVc.emitSocket_AcceptRequest(param: param)
            }
        }
    }
    
    // Cancel Trip
    @IBAction func btnRejectAction(_ sender: UIButton) {
        print(#function)
        setConstraintOfHomeVc()
        setRequestRejectedView()
        
        guard let bookingData = Singleton.shared.bookingInfo else { return }
        var param = [String: Any]()
        param["driver_id"] = Singleton.shared.driverId
        param["booking_id"] = bookingData.id
        
        if let vc: UIViewController = self.parentViewController {
            if let hVc = vc as? HomeViewController {
                hVc.timerProgressRequest?.invalidate()
                hVc.count = 0
                hVc.progressRequest.progress = 0.0
                hVc.progressRequest.isHidden = true
                hVc.emitSocket_RejectRequest(param: param)
            }
        }
    }
    
    // Arrived to pickup location
    @IBAction func btnArrivedAction(_ sender: UIButton) {
        print(#function)
        txtDropOff.becomeFirstResponder()
        isAccepted = false
        isArrived = true
        isStartTrip = false
        setConstraintOfHomeVc()
        setStartTripView()
        DispatchQueue.main.async {
            self.txtDropOff.resignFirstResponder()
        }
        DispatchQueue.main.async {
            self.resignFirstResponder()
        }
    }
    
    @IBAction func btnStartTrip(_ sender: UIButton) {
        isAccepted = false
        isArrived = false
        isStartTrip = true
        setConstraintOfHomeVc()
//        setArrivedView()
//        setCompleteTripView()
        setTripView()
        guard let bookingData = Singleton.shared.bookingInfo else { return }
        var param = [String: Any]()
        param["booking_id"] = bookingData.id
        
        if let vc: UIViewController = self.parentViewController {
            if let hVc = vc as? HomeViewController {
                hVc.emitSocket_StartTrip(param: param)
            }
        }
    }
    
    // Cancel trip
    @IBAction func btnCancelAction(_ sender: UIButton) {
        print(#function)
        setConstraintOfHomeVc()
        setDeiverInfoView()
        if let vc: UIViewController = self.parentViewController {
            if let hVc = vc as? HomeViewController {
                hVc.cancelTripAfterAccept()
            }
        }
    }
    
    // Start Waiting Time
    @IBAction func btnStartWaitingTimeAction(_ sender: UIButton) {
        print(#function)
        setConstraintOfHomeVc()
        setWaitingView()
    }
    
    // End Waiting Trip
    @IBAction func btnEndWaitingTimeAction(_ sender: UIButton) {
        print(#function)
        setConstraintOfHomeVc()
//        setStopWaitingView()
        stopWaitingTimeFrom(beforeStartTrip: isArrived)
    }
    
    // Complete Trip
    @IBAction func btnCompleteTripAction(_ sender: UIButton) {
        print(#function)
        setConstraintOfHomeVc()
        setDeiverInfoView()
        guard let bookingData = Singleton.shared.bookingInfo else { return }
        var param = [String: Any]()
        param["booking_id"] = bookingData.id
        
        if let vc = ((UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.children)?.first?.children.first as? HomeViewController {
            vc.emitSocket_AskForTips(param: param)
        }
        
//        if let vc: UIViewController = self.parentViewController {
//            if let hVc = vc as? HomeViewController {
//                hVc.emitSocket_AskForTips(param: param)
//            }
//        }
    }
    
    // Message to passenger
    @IBAction func btnMessageAction(_ sender: UIButton) {
        print(#function)
        setConstraintOfHomeVc()
    }
    
    // Call to passenger
    @IBAction func btnCallAction(_ sender: UIButton) {
        print(#function)
        setConstraintOfHomeVc()
        
        guard let profile = Singleton.shared.bookingInfo else { return }
        dialNumber(number: profile.customerInfo.mobileNo)
    }
    
    // Navigation to third party map application
    @IBAction func btnNavigationAction(_ sender: UIButton) {
        print(#function)
        setConstraintOfHomeVc()
        
        guard let bookingData = Singleton.shared.bookingInfo else { return }
        let DropOffLat = bookingData.dropoffLat ?? ""
        let DropOffLon = bookingData.dropoffLng ?? ""


        let url =  "comgooglemaps://?saddr=&daddr=\(String(describing: Float(DropOffLat)!)),\(String(describing: Float(DropOffLon)!))&directionsmode=driving"

        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            UIApplication.shared.canOpenURL(URL(string: url)!)
        } else {
            if let url = URL(string: "https://itunes.apple.com/us/app/google-maps-transit-food/id585027354") {
                UIApplication.shared.canOpenURL(url)
            }
        }
    }
    
    func setConstraintOfHomeVc() {
        if let vc: UIViewController = self.parentViewController {
            if let hVc = vc as? HomeViewController {
                hVc.containerBottomConstraint.constant = 0
            }
        }
    }
    
    func setDeiverInfoView() {
        if let vc: UIViewController = self.parentViewController {
            if let hVc = vc as? HomeViewController {
                hVc.getFirstView()
            }
        }
    }
    
    func dialNumber(number : String) {
        
        if let url = URL(string: "tel://\(number)"),
            UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            // add error message here
            UtilityClass.showAlert(message: "Your device is not able to call right now.")
        }
    }


    func sendSMS(phoneNumber : String)
    {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = "Message Body"
            controller.recipients = [phoneNumber]
            controller.messageComposeDelegate = self
            self.parentViewController?.present(controller, animated: true, completion: nil)
        }
    }


    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {

    }




}
