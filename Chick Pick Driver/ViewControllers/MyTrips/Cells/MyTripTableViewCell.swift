//
//  MyTripTableViewCell.swift
//  Pappea Driver
//
//  Created by EWW-iMac Old on 04/07/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit

class MyTripTableViewCell: UITableViewCell {
    @IBOutlet weak var cellContainerView: UIView!
    @IBOutlet weak var lblPickup: UILabel!
    @IBOutlet weak var lblDropoff: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblBookin: UILabel!
    @IBOutlet weak var lblDate: UILabel!
   
    @IBOutlet weak var iconPickupToDestinationLocation: UIImageView!
    @IBOutlet weak var btnSendReceipt: UIButton!
    @IBOutlet weak var btnRequestAccept: UIButton!
    
    let AcceptBookLaterClosure:(PastBookingHistoryResponse) -> () = { model in
        print(model.bookingType)
    }
    
    override func layoutSubviews() {
        superview?.layoutSubviews()
        setup()
    }
   
    func setup(){
        selectionStyle = .none
        cellContainerView.roundCorners([.topLeft,.topRight], radius: 5)
        iconPickupToDestinationLocation.image = iconPickupToDestinationLocation.image?.imageWithTintColorCustomMethod(color: .black)
        btnSendReceipt.layer.cornerRadius = 15
        btnSendReceipt.layer.borderColor = UIColor.black.cgColor
        btnSendReceipt.layer.borderWidth = 1.5
        btnSendReceipt.titleLabel?.font = UIFont.regular(ofSize: 10)
        btnSendReceipt.clipsToBounds = true
    }
    
    @IBAction func btnAcceptAction(_ sender: Any) {
        
    }
}
