//
//  TransferToBankVC.swift
//  Peppea
//
//  Created by EWW80 on 11/07/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit

class TransferToBankVC: BaseViewController {

    // ----------------------------------------------------
    // MARK: - Outlets
    // ----------------------------------------------------
    @IBOutlet weak var lblWalletAmount: UILabel!
    
    @IBOutlet weak var btnTransferToBank: UIButton!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtAccountHolderName: ThemeTextFieldLoginRegister!
    @IBOutlet weak var txtBankName: ThemeTextFieldLoginRegister!
    @IBOutlet weak var txtBankAccountNo: ThemeTextFieldLoginRegister!
    @IBOutlet weak var txtBankCode: ThemeTextFieldLoginRegister!
    
    var transferToBankReqModel : transferMoneyToBank = transferMoneyToBank()
    var LoginDetails : LoginModel = LoginModel()
    
    // ----------------------------------------------------
    // MARK: - Base Methods
    // ----------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        lblWalletAmount.text = Singleton.shared.currentBalance
        
        self.setNavBarWithBack(Title: "Transfer To Bank", IsNeedRightButton: false)
        self.lblWalletAmount.text = Singleton.shared.walletBalance
        do {
            LoginDetails = try UserDefaults.standard.get(objectType: LoginModel.self, forKey: "userProfile")!
        } catch {
            AlertMessage.showMessageForError("error")
            return
        }
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.lblWalletAmount.text = Singleton.shared.walletBalance//LoginDetail.loginData.walletBalance
    }    // ----------------------------------------------------
    // MARK: - Actions
    // ----------------------------------------------------
    @IBAction func btnTransferToBankClicked(_ sender: Any) {
        
        let profile = LoginDetails.responseObject
        transferToBankReqModel.driver_id = profile!.id
        transferToBankReqModel.amount = txtPrice.text ?? ""
        transferToBankReqModel.account_holder_name = txtAccountHolderName.text ?? ""
        transferToBankReqModel.bank_name = txtBankName.text ?? ""
        transferToBankReqModel.bank_branch = txtBankCode.text ?? ""
        transferToBankReqModel.account_number = txtBankAccountNo.text ?? ""
        
        if validation().0
        {
            webserviceForTransferToBank()
        }
        else
        {
            UtilityClass.showAlert(message: validation().1)
        }
    }
    
    // ----------------------------------------------------
    // MARK: - Custom Methods
    // ----------------------------------------------------
    
    func validation() -> (Bool, String) {
        
        if txtPrice.text!.isBlank {
            return (false, "Please enter price")
        } else if txtAccountHolderName.text!.isBlank {
            return (false, "Please enter account holder name")
        } else if txtBankName.text!.isBlank {
            return (false, "Please enter bank name")
        } else if txtBankAccountNo.text!.isBlank {
            return (false, "Please enter bank account number")
        } else if txtBankCode.text!.isBlank {
            return (false, "Please enter branch code")
        }
        
        return (true, "")
    }
}

// ----------------------------------------------------
// MARK: - Webservice Method
// ----------------------------------------------------

extension TransferToBankVC {
    
    func webserviceForTransferToBank()
    {
        let model = TransferToBank()
        model.driver_id = (Singleton.shared.userProfile?.responseObject.id)!
        model.amount = txtPrice.text!
        model.account_holder_name = txtBankName.text!
        model.bank_name = txtBankName.text!
        model.account_number = txtBankAccountNo.text!
        model.bank_branch = txtBankCode.text!
        
        Loader.showHUD(with: UIApplication.shared.keyWindow)
        UserWebserviceSubclass.transferToBankService(transferMoneyModel: model) { (response, status) in
            Loader.hideHUD()

             if status
            {
                Loader.hideHUD()
                Singleton.shared.walletBalance = response["wallet_balance"].stringValue
                self.lblWalletAmount.text = Singleton.shared.walletBalance
                self.navigationController?.popViewController(animated: true)
                AlertMessage.showMessageForSuccess(response["message"].stringValue)
            }
            else
            {
                Loader.hideHUD()
                AlertMessage.showMessageForError(response["message"].stringValue)
            }
        }
    }
}
