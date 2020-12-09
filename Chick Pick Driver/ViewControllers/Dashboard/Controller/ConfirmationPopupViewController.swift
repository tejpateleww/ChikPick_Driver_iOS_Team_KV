//
//  ConfirmationPopupViewController.swift
//  Chick Pick Driver
//
//  Created by Bhumi on 09/12/20.
//  Copyright © 2020 baps. All rights reserved.
//

import UIKit

class ConfirmationPopupViewController: UIViewController {
    
    // MARK: - Outlets
    var redirectToBack : (() -> ())?
    var cancelPopup : (() -> ())?
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblOTP: UILabel!
    @IBOutlet var btnAction: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    
    var shouldRedirect = Bool()
    
    // MARK: - Variables declaration
    var strMessage = String()
    var strTitle = String()
    var strOTP = String()
    var strBtnTitle = String()
    
    
    // MARK: - Base Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = strTitle
        lblMessage.text = strMessage
        lblOTP.text = strOTP
        btnAction.setTitle(strBtnTitle, for: .normal)
        
        lblTitle.isHidden = lblTitle.text?.count == 0 ? true : false
        lblOTP.isHidden = lblOTP.text?.count == 0 ? true : false
    }
    
    // MARK: - Actions
    
    @IBAction func btnOkAction(_ sender: UIButton) {
        if(shouldRedirect)
        {
            redirectToBack?()
        }
        else
        {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func btnCloseAction(_ sender: UIButton) {
        cancelPopup?()
//        self.dismiss(animated: true, completion: nil)
    }
}
