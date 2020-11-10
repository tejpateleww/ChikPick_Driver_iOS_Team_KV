//
//  CompleteView.swift
//  Pappea Driver
//
//  Created by Apple on 12/08/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit

class CompleteView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBOutlet weak var lblTotal: UILabel!
    
    var strTotal : String?
    
    func setGrandTotal() {
        lblTotal.text = "Total : \(Currency)\(Singleton.shared.bookingInfo?.grandTotal ?? "0")"
//        Singleton.shared.bookingInfo = nil
    }
    
    @IBAction func btnOKAction(_ sender: UIButton) {
        
        if let vc: UIViewController = self.parentViewController {
            if let hVc = vc as? HomeViewController {
                hVc.driverData.driverState = .ratingView
                hVc.getRatingView()
            }
        }
    }
}
