//
//  RatingView.swift
//  Chick Pick Driver
//
//  Created by EWW071 on 16/10/20.
//  Copyright © 2020 baps. All rights reserved.
//

import UIKit
import Cosmos
import SideMenuSwift

class RatingView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBOutlet weak var viewRating: CosmosView!
    @IBOutlet weak var txtComments: UITextField!
    @IBOutlet weak var lblText: UILabel!
    
    var bookingId = ""
    var myRating: Double = 0
    

    func setupView(){
        viewRating.settings.emptyBorderColor = UIColor.init(custom: .themePink)  //UIColor.init(hex: "2D2D2D")
        viewRating.settings.emptyBorderWidth = 2
        viewRating.settings.filledBorderColor = UIColor.init(custom: .themePink) //UIColor.init(hex: "2D2D2D")
        viewRating.settings.filledBorderWidth = 2
        viewRating.settings.emptyColor = UIColor.white
        viewRating.settings.filledColor = UIColor.init(custom: .themePink) //UIColor.init(hex: "2D2D2D")
        
        //        2D2D2D
        viewRating.settings.starSize = 35
        viewRating.settings.starMargin = 5
        viewRating.rating = 0
        
        viewRating.didFinishTouchingCosmos = { rating in
            self.myRating = rating
        }
        
        lblText.text = "How was your experience with Passenger \(Singleton.shared.bookingInfo?.customerInfo.firstName ?? "") \(Singleton.shared.bookingInfo?.customerInfo.lastName ?? "")?"
        
        SideMenuController.preferences.basic.enablePanGesture = false
    }
    
    @IBAction func btnSubmitAction(_ sender: Any) {
        SideMenuController.preferences.basic.enablePanGesture = true
        webserviceForReviewRating()
    }
    
    // ----------------------------------------------------
    // MARK: - Webservice Methods
    // ----------------------------------------------------
    
    func webserviceForReviewRating() {
        
        let model = ReviewRatingReqModel()
        model.booking_id = Singleton.shared.bookingInfo?.id ?? ""
        model.rating = "\(myRating)"
        model.comment = txtComments.text ?? ""
        
        UserWebserviceSubclass.ReviewRatingToDriver(bookingRequestModel: model) { (response, status) in
            print(response)
            if status {
                if let vc: UIViewController = self.parentViewController {
                    if let hVc = vc as? HomeViewController {
                        hVc.driverData.driverState = .available
                        hVc.getFirstView()
                    }
                }
                Singleton.shared.bookingInfo = nil
            } else {
                AlertMessage.showMessageForError(response.dictionary?["message"]?.stringValue ?? "")
            }
        }
    }
}
