//
//  VerifyPasscodeViewController.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 17/05/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit

class VerifyPasscodeViewController: BaseViewController {

    @IBOutlet var btnNumber: [UIButton]!
    @IBOutlet var imgPasscodes: [UIImageView]!
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var lblPassword: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navType = .opaque
        title = "Verify Passcode"
    }
    
    @IBAction func btnNumbersAction(_ sender: UIButton) {
        
      
        
    }
   

}
