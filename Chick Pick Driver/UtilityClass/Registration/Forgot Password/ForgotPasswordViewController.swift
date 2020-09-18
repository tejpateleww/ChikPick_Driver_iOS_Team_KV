//
//  ForgotPasswordViewController.swift
//  Pappea Driver
//
//  Created by Mayur iMac on 13/07/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SSSpinnerButton


class ForgotPasswordViewController: UIViewController {

    // ----------------------------------------------------
    // MARK: - Outlets
    // ----------------------------------------------------
    
    @IBOutlet weak var txtEmail: SkyFloatingLabelTextField!
    @IBOutlet var btnReset: SSSpinnerButton!
    
    // ----------------------------------------------------
    // MARK: - Base Methods
    // ----------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        btnReset.submitButtonLayout(isDark : true)
    }
    
    @IBAction func btnGoBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    // ----------------------------------------------------
    // MARK: - Actions
    // ----------------------------------------------------
    @IBAction func btnResetPassword(_ sender: UIButton) {
        
        let validationParameter :[(String?,String, ValidatiionType)] =  [ (txtEmail.text,emailEmptyErrorString, .isEmpty),
            (txtEmail.text,emailErrorString, .email), ]
        
        guard Validator.validate(validationParameter) else {
            
            return
        }
        
//        if txtEmail.text!.isBlank {
//            AlertMessage.showMessageForError("Please enter email id")
//        } else {
            webserviceForForrgotPassword()
//        }
    }
    
    
    // ----------------------------------------------------
    // MARK: - Webservice Methods
    // ----------------------------------------------------
    func webserviceForForrgotPassword() {
        
        Loader.showHUD(with: self.view)
        
        UserWebserviceSubclass.forgotPassword(strType: ["email": txtEmail.text!]) { (response, status) in
            
            Loader.hideHUD()
            
            if status {
                AlertMessage.showMessageForSuccess(response["message"].stringValue)
                self.dismiss(animated: true, completion: nil)
                
            } else {
                AlertMessage.showMessageForError(response["message"].stringValue)
            }
        }
    }
}
