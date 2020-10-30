//
//  VerifyCustomerPopupViewController.swift
//  Peppea
//
//  Created by EWW074 on 09/01/20.
//  Copyright © 2020 Mayur iMac. All rights reserved.
//

import UIKit

class VerifyCustomerPopupViewController: UIViewController {

   
    // MARK: - Outlets
    var redirectToPaymentList : (() -> ())?
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet var txtCode: UITextField!
    @IBOutlet var btnAction: UIButton!
    var shouldRedirect = Bool()
    
    // MARK: - Variables declaration
    var strPlaceholder = String()
    var strTitle = String()
    var strOTP = String()
    var strBtnTitle = String()
    var completeTripOnEndCode : ((Bool)->()) = { _ in}
    
    // MARK: - Base Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = strTitle
        txtCode.placeholder = strPlaceholder
        btnAction.setTitle(strBtnTitle, for: .normal)
    }
    
    // MARK: - Actions
    
    @IBAction func btnOkAction(_ sender: UIButton) {
        
        if txtCode.text?.isEmpty ?? false {
            AlertMessage.showMessageForError("Please enter OTP number")
        }else if strOTP != txtCode.text{
             AlertMessage.showMessageForError("Invalid OTP number")
        } else {
            self.dismiss(animated: true, completion: {
                self.completeTripOnEndCode(true)
            })
        }
    }
}
