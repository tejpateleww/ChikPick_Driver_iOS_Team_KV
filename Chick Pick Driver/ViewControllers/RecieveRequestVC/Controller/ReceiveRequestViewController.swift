

import UIKit
import MarqueeLabel
import SwiftyJSON
class ReceiveRequestViewController: UIViewController {
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet weak var viewRequestReceive: UIView!
    
    @IBOutlet weak var lblReceiveRequest: UILabel!
    
    @IBOutlet weak var lblMessage: UILabel!
    
    @IBOutlet weak var lblGrandTotal: UILabel!
    @IBOutlet weak var lblPickUpLocationInfo: UILabel!
    @IBOutlet weak var lblPickupLocation: MarqueeLabel!
    @IBOutlet weak var lblDropoffLocationInfo: UILabel!
    @IBOutlet weak var lblDropoffLocation: MarqueeLabel!
    
    @IBOutlet weak var lblFlightNumber: UILabel!
    @IBOutlet weak var lblNotes: UILabel!

    @IBOutlet weak var stackViewFlightNumber: UIStackView!

    @IBOutlet weak var stackViewNotes: UIStackView!
    
    @IBOutlet weak var btnReject: UIButton!
    @IBOutlet weak var btnAccepted: UIButton!
    
    @IBOutlet weak var viewDetails: UIView!
    //    @IBOutlet var constratintHorizontalSpaceBetweenButtonAndTimer: NSLayoutConstraint!
    
    var requestData : JSON?
    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        CountDownView()
//        fillAllFields()
//        
//    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        setLocalization()
//    }
//    
//    func setLocalization(){
//        lblReceiveRequest.text = "Receive Request".localized
//        lblMessage.text = "New booking request arrived".localized
//        //        lblGrandTotal.text = "Grand Total is".localized
//        lblPickUpLocationInfo.text = "Pick up location".localized
//        lblDropoffLocationInfo.text = "Drop off location".localized
//        btnReject.setTitle("Reject".localized, for: .normal)
//        btnAccepted.setTitle("Accept".localized, for: .normal)
//        
//    }
//   
//    func CountDownView() {
//        
//        viewCountdownTimer.labelFont = UIFont(name: "HelveticaNeue-Light", size: 30.0)
//        //                    self.timerView.timerFinishingText = "End"
//        viewCountdownTimer.lineWidth = 4
//        viewCountdownTimer.lineColor = UIColor.black
//        viewCountdownTimer.trailLineColor = ThemeYellowColor
//        viewCountdownTimer.labelTextColor = UIColor.black
//        viewCountdownTimer.delegate = self
//        viewCountdownTimer.start(beginingValue: 30, interval: 1)
//        //        lblMessage.text = "New booking request arrived from \(appName.kAPPName)"
//        
//    }
//    
//    func fillAllFields() {
//        
//        //        if Singletons.sharedInstance.passengerType == "" {
//        //
//        //            viewDetails.isHidden = true
//        //
//        //            lblGrandTotal.isHidden = true
//        ////            constratintHorizontalSpaceBetweenButtonAndTimer.priority = 1000
//        ////            stackViewFlightNumber.isHidden = true
//        ////            stackViewNotes.isHidden = true
//        //        }
//        //        else {
//        viewDetails.isHidden = false
//        print(strGrandTotal)
//        print(strPickupLocation)
//        print(strDropoffLocation)
//        print(strFlightNumber)
//        print(strNotes)
//        //            if strGrandTotal != "0" {
//        //                lblGrandTotal.text = "Grand Total : \(strGrandTotal) \(currency)"
//        //            } else if strEstimateFare != "0" {
//        lblGrandTotal.text = "\("Estimate Fare".localized) : \(strEstimateFare) \(currency)"
//        //            }
//        
//        lblMessage.text = strRequestMessage
//        lblPickupLocation.text = strPickupLocation
//        lblDropoffLocation.text = strDropoffLocation
//        
//        //            if strFlightNumber.count == 0 {
//        //                stackViewFlightNumber.isHidden = true
//        //            }
//        //            else {
//        //                stackViewFlightNumber.isHidden = false
//        //                lblFlightNumber.text = strFlightNumber
//        //            }
//        //
//        //            if strNotes.count == 0 {
//        //                stackViewNotes.isHidden = true
//        //            }
//        //            else {
//        //                stackViewNotes.isHidden = false
//        //                lblNotes.text = strNotes
//        //            }
//        //        }
//        
//    }
//    
//    func timerDidEnd() {
//        
//        if (isAccept == false)
//        {
//            if (boolTimeEnd) {
//                self.dismiss(animated: true, completion: nil)
//            }
//            else {
//                print(#function)
//                self.delegate.didRejectedRequest()
//                self.dismiss(animated: true, completion: nil)
//            }
//        }
//    }
//    
//    //-------------------------------------------------------------
//    // MARK: - Actions
//    //-------------------------------------------------------------
//    
//    var boolTimeEnd = Bool()
//    
//    @IBAction func btnRejected(_ sender: UIButton) {
//        if Connectivity.isConnectedToInternet() == false {
//            UtilityClass.showAlert("App Name".localized, message: "Sorry! Not connected to internet".localized, vc: self)
//            return
//        }
//        
//        Singletons.sharedInstance.firstRequestIsAccepted = false
//        isAccept = false
//        boolTimeEnd = true
//        delegate.didRejectedRequest()
//        self.viewCountdownTimer.end()
//        //        self.stopSound()
//        self.dismiss(animated: true, completion: nil)
//        
//    }
//    
//    @IBAction func btnAcceped(_ sender: UIButton) {
//        if Connectivity.isConnectedToInternet() == false {
//            UtilityClass.showAlert("App Name".localized, message: "Sorry! Not connected to internet".localized, vc: self)
//            return
//        }
//        
//        Singletons.sharedInstance.firstRequestIsAccepted = false
//        
//        isAccept = true
//        boolTimeEnd = true
//        delegate.didAcceptedRequest()
//        self.viewCountdownTimer.end()
//        self.stopSound()
//        self.dismiss(animated: true, completion: nil)
//    }
//    // ------------------------------------------------------------
//    
//    
//    
//    
}

