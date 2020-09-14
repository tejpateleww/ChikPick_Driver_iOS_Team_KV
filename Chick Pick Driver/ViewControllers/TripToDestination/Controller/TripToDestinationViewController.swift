//
//  TripToDestinationViewController.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 11/05/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit

class TripToDestinationViewController: BaseViewController {

    @IBOutlet var btnSelectDestination: UISwitch!
    @IBOutlet var txtDestination: UITextField!
    @IBOutlet weak var lblDestinationTrip: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSubmit.setTitle("Submit", for: .normal)
 }
    @IBAction func valueChangedOfTripToDestination(_ sender: UISwitch) {

        txtDestination.isHidden = !sender.isOn

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        navType = .opaque
        title = "Trip To Destination"
    }
    @IBAction func btnSubmit(_ sender: Any) {
    }
}
