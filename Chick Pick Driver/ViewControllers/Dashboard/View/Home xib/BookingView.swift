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

    @IBOutlet weak var viewAcceptReject: UIStackView!
    @IBOutlet weak var viewRequestAccepted: UIStackView!
    @IBOutlet weak var viewStartTrip: UIStackView!
    @IBOutlet weak var viewEndTrip: UIStackView!
    @IBOutlet weak var viewContactUs: UIStackView!
    @IBOutlet weak var viewEstimatePrice: UIStackView!
    @IBOutlet weak var viewWaitingTimer: UIStackView!
    
    var isArrived = Bool()
    var isStartTrip = Bool()
    var isAccepted = Bool()
    
   
    override func draw(_ rect: CGRect) {
//        btnReject.submitButtonLayout(isDark: true)
//        btnAccept.submitButtonLayout(isDark: true)
        btnCancelTrip.submitButtonLayout(isDark: true)
//        btnArrive.submitButtonLayout(isDark: true)
        btnStartWaitingTime.submitButtonLayout(isDark: true)
        btnEndWaitingTime.submitButtonLayout(isDark: true)
        btnCompleteTrip.submitButtonLayout(isDark: true)
//        btnStart.submitButtonLayout(isDark: true)
        
        btnCard.layer.cornerRadius = btnCard.frame.size.height / 2
        btnCard.clipsToBounds = true
        btnDiscount.layer.cornerRadius = 3
        btnDiscount.clipsToBounds = true
        
        btnStartWaitingTime.isHidden = true
        
        btnAccept.buttonLayout(withBgColor: UIColor.hexStringToUIColor(hex: "#2fa918"), textColor: .white)
        btnReject.buttonLayout(withBgColor: UIColor.hexStringToUIColor(hex: "#c90a12"), textColor: .white)
        btnArrive.buttonLayout(withBgColor: UIColor(custom: .themePink), textColor: UIColor(custom: .theme))
        btnStart.buttonLayout(withBgColor: UIColor(custom: .themePink), textColor: UIColor(custom: .theme))
        
//        btnReject.backgroundColor = UIColor.hexStringToUIColor(hex: "#c90a12")
//        btnReject.layer.cornerRadius = btnReject.frame.size.height / 2
//        btnReject.clipsToBounds = true
//        btnAccept.backgroundColor = UIColor.hexStringToUIColor(hex: "#2fa918")
//        btnAccept.layer.cornerRadius = btnAccept.frame.size.height / 2
//        btnAccept.clipsToBounds = true
    }
    
    func setupData() {
        txtPickup.text = Singleton.shared.bookingInfo?.pickupLocation
        txtDropOff.text = Singleton.shared.bookingInfo?.dropoffLocation
        
        btnCard.setTitle("Card", for: .normal)
        lblTripPrice.text = "N/A"
        btnDiscount.setTitle("N/A", for: .normal)
        lblTripDistance.text = "N/A"
        
        guard let profile = Singleton.shared.bookingInfo?.customerInfo else { return }
        lblPassengerName.text = (profile.firstName ?? "") + " " + (profile.lastName ?? "")
        
        let passengerImage = profile.profileImage
        imgPassenger.sd_setImage(with: URL(string: imagBaseURL + (passengerImage ?? "")), completed: nil)
    }
    
    private func requestView() {
        showAllViews()
        hideShowViews(hide: true, views: [viewStartTrip, viewEndTrip, viewContactUs, viewRequestAccepted])
    }
    
    func setRequestAcceptedView() {
//        showAllViews()
//        hideShowViews(hide: true, views: [viewStartTrip, viewAcceptReject,txtDropOff, viewEndTrip, viewEstimatePrice])
        showAllViews()
        hideShowViews(hide: true, views: [viewAcceptReject, txtDropOff, viewEndTrip, viewEstimatePrice, btnCompleteTrip, btnStart, btnArrive])
        Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(showArriveButton), userInfo: nil, repeats: false)
    }
    
    @objc func showArriveButton(){
        if let vc: UIViewController = self.parentViewController {
            if let hVc = vc as? HomeViewController {
               if hVc.driverData.driverState == .requestAccepted {
                   btnArrive.isHidden = false
                btnArrive.setTitle("Start Request Code", for: .normal)
                } else {
                    btnArrive.isHidden = true
                }
            }
        }
    }
    
    func setArrivedView() {
        showAllViews()
        hideShowViews(hide: true, views: [viewAcceptReject, viewEndTrip, viewEstimatePrice, btnCompleteTrip])
    }
    
    func setStartTripView() {
        showAllViews()
        hideShowViews(hide: true, views: [viewAcceptReject, viewEndTrip, viewEstimatePrice, btnArrive, btnCompleteTrip])
    }
    
    private func setWaitingView() {
        showAllViews()
        hideShowViews(hide: true, views: [viewAcceptReject, viewRequestAccepted, viewStartTrip])
    }
    
    func setTripView() {
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
        
        setUserInteractionEnable(views: [btnAccept, btnStart, btnArrive, btnReject, btnCancelTrip, btnCompleteTrip, btnEndWaitingTime, btnStartWaitingTime])
        
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
            
        case .ratingView:
            print("Rating View")
        }
    }
    
    // ----------------------------------------------------
    // MARK: - Button Actions
    // ----------------------------------------------------
    
    // Accept Trip
    @IBAction func btnAcceptAction(_ sender: UIButton) {
        print(#function)
        
        btnAccept.isUserInteractionEnabled = false
        
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
        
        btnReject.isUserInteractionEnabled = false
        
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
        //        txtDropOff.becomeFirstResponder()
        
        btnAccept.isUserInteractionEnabled = false
        
        if(sender.titleLabel?.text == "Start Request Code")
        {
//            isAccepted = false
//            isArrived = true
//            isStartTrip = false
//            setConstraintOfHomeVc()
//            setStartTripView()
            
            guard let bookingData = Singleton.shared.bookingInfo else { return }
            var param = [String: Any]()
            param["booking_id"] = bookingData.id
            
            if let vc: UIViewController = self.parentViewController {
                if let hVc = vc as? HomeViewController {
                    var param = [String: Any]()
                    param["driver_id"] = Singleton.shared.driverId
                    param["booking_id"] = bookingData.id
                    param["customer_id"] = bookingData.customerId
                    hVc.emitSocket_VerifyCustomer(param: param)
                }
            }
        }
        else
        {
            isAccepted = false
            isArrived = true
            isStartTrip = false
            setConstraintOfHomeVc()
            setStartTripView()
            
            guard let bookingData = Singleton.shared.bookingInfo else { return }
            var param = [String: Any]()
            param["booking_id"] = bookingData.id
            
            if let vc: UIViewController = self.parentViewController {
                if let hVc = vc as? HomeViewController {
                    hVc.emitSocket_ArrivedAtPickupLocation(param: param)
                }
            }
        }
        //        DispatchQueue.main.async {
        //            self.txtDropOff.resignFirstResponder()
        //        }
        //        DispatchQueue.main.async {
        //            self.resignFirstResponder()
        //        }
    }
    
    @IBAction func btnStartTrip(_ sender: UIButton) {
        
        btnStart.isUserInteractionEnabled = false
        
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
        
        Loader.showHUD(with: UIApplication.shared.keyWindow)
        self.webserviceForCancellationCharges()
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
//            vc.emitSocket_AskForTips(param: param)
            vc.emitSocket_RequestCodeForCompleteTrip(param: param)
        }
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
    
    func alertForCancellation(charges : String) {
        UtilityClass.showAlert(message: "Cancelling a trip after accepting it attracts a fee of \(Currency)\(charges). Please confirm whether you still wish to cancel?", isCancelShow: true) {
            self.setConstraintOfHomeVc()
            //        setDeiverInfoView()
            if let vc: UIViewController = self.parentViewController {
                if let hVc = vc as? HomeViewController {
                    hVc.cancelTripAfterAccept()
                }
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
                hVc.resetMap()
            }
        }
    }
    
    func webserviceForCancellationCharges() {
        
        let param = Singleton.shared.bookingInfo?.vehicleType.id ?? ""
        
        UserWebserviceSubclass.CancellationCharges(strURL: param) { (response, status) in
            //            print(response)
            Loader.hideHUD()
           
            if(status) {
                let data = response["data"].dictionaryValue
                let charges = data["driver_cancellation_fee"]?.stringValue
                self.alertForCancellation(charges: charges ?? "")
            }
            else {
                AlertMessage.showMessageForError(response["message"].stringValue)
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
