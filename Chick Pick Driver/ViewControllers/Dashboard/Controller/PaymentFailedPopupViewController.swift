//
//  PaymentFailedPopupViewController.swift
//  Chick Pick Driver
//
//  Created by EWW071 on 20/10/20.
//  Copyright © 2020 baps. All rights reserved.
//

import UIKit

class PaymentFailedPopupViewController: UIViewController {
    
    // MARK: - Outlets

        @IBOutlet weak var lblMessage: UILabel!

        
        // MARK: - Variables declaration
        var strMessage = ""
        var strBookingId = ""


    override func viewDidLoad() {
        super.viewDidLoad()
        lblMessage.text = strMessage
    }
    
    @IBAction func btnReceivedAction(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
        Loader.showHUD(with: self.view)
        webserviceForPaymentReceivedOrNot(status: "1")
    }
    
    @IBAction func btnNotReceivedAction(_ sender: Any) {
        UtilityClass.showAlert(message: "Please confirm that passenger had not paid you", isCancelShow: true) {
            print("ok")
            Loader.showHUD(with: self.view)
            self.webserviceForPaymentReceivedOrNot(status: "0")
        }
    }
    
    func webserviceForPaymentReceivedOrNot(status : String) {
        
        let param = strBookingId  + "/" + "\(status)"
        UserWebserviceSubclass.paymentReceivedOrNot(strURL: param) { (response, status) in
            print(response)
            Loader.hideHUD()
            
            if(status) {
               self.dismiss(animated: true, completion: nil)
            }
            else {
                AlertMessage.showMessageForError(response["message"].stringValue)
            }
        }
    }
}
