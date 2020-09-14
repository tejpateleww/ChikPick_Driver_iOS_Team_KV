//
//  PasscodeSettingsViewController.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 11/05/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit

class PasscodeSettingsViewController: BaseViewController {

    @IBOutlet weak var viewSetPasscode: UIView!
    @IBOutlet weak var viewChangePasscode: UIView!
    @IBOutlet weak var viewProfile: UIView!
    
    @IBOutlet weak var switchPasscode: UISwitch!
    
    @IBOutlet weak var btnSetPassword: UIButton!
    @IBOutlet weak var btnChangePasssworld: UIButton!
    
    @IBOutlet weak var btnProfile: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        navType = .opaque
        title = "Set Passcode"
    }
    @IBAction func setPasscode(_ sender: UIButton){
        self.performSegue(withIdentifier: SetPasscodeViewController.identifier, sender: sender)
    }

}
