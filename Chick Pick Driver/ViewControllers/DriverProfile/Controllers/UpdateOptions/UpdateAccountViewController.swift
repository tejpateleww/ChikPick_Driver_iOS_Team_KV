//
//  UpdateAccountViewController.swift
//  Pappea Driver
//
//  Created by Apple on 10/07/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit
import SSSpinnerButton

class UpdateAccountViewController: UIViewController {

    
    @IBOutlet weak var accountView: UIView!
    @IBOutlet weak var btnSave: SSSpinnerButton!
    
    let myCustomView: BankInfoView = .fromNib()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accountView.addSubview(myCustomView)
        btnSave.submitButtonLayout(isDark : true)
        myCustomView.setupTextField()
        
        self.title = "Account"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
        setupNavigationBarColor(navigationController)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (navigationController?.viewControllers.last is ProfileOptionsViewController) {
            let clubVC = navigationController?.viewControllers.last as? ProfileOptionsViewController
            clubVC?.isFromCheckinScreen = true
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if isMovingFromParent {
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.isTranslucent = true
        }
    }
    
  
    
//    BankInfoView
    
    @IBAction func btnSaveAction(_ sender: UIButton) {
        
        if validation().0 {
             webserviceForUpdateAccount()
        } else {
            AlertMessage.showMessageForError(validation().1)
        }
    }
    
    func validation() -> (Bool, String) {
        
        if myCustomView.txtAccountHolderName.text!.isBlank {
            return (false, "Please enter account holder name")
        } else if myCustomView.txtBankName.text!.isBlank {
            return (false, "Please enter bank name name")
        } else if myCustomView.txtBankBranch.text!.isBlank {
            return (false, "Please enter bank branch")
        } else if myCustomView.txtAccountNumber.text!.isBlank {
            return (false, "Please enter account number")
        }
        
        return (true, "")
    }
    
    func webserviceForUpdateAccount() {
        
        var loginModelDetails: LoginModel = LoginModel()
        
        do {
            loginModelDetails = try UserDefaults.standard.get(objectType: LoginModel.self, forKey: "userProfile")!
        }
        catch {
            AlertMessage.showMessageForError("error")
            return
        }
        
        let accountData : UpdateAccountData = UpdateAccountData()
        accountData.driver_id = loginModelDetails.responseObject.id
        accountData.account_holder_name = myCustomView.txtAccountHolderName.text!
        accountData.bank_name = myCustomView.txtBankName.text!
        accountData.account_number = myCustomView.txtAccountNumber.text!
        accountData.bank_branch = myCustomView.txtBankBranch.text!
    
        UserWebserviceSubclass.updateAccount(transferMoneyModel: accountData) { (response, status) in
            
            print("updateAccount: \n", response)
            if status {
                
                let loginModelDetails = LoginModel.init(fromJson: response)
                do {
                    try UserDefaults.standard.set(object: loginModelDetails, forKey: "userProfile")
                    UserDefaults.standard.synchronize()
                }
                catch {
                    print("error")
                }
               AlertMessage.showMessageForSuccess(response["message"].stringValue)
                self.navigationController?.popViewController(animated: true)
            } else {
                AlertMessage.showMessageForError(response["message"].arrayValue.first?.stringValue ?? response["message"].stringValue)
            }
        }
    }
}
