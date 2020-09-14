//
//  ChangePasswordViewController.swift
//  Pappea Driver
//
//  Created by Mayur iMac on 13/07/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SSSpinnerButton


class ChangePasswordViewController: BaseViewController {

    // ----------------------------------------------------
    // MARK: - Outlets
    // ----------------------------------------------------
    @IBOutlet weak var txtOldPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var txtNewPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var txtConfirmPassword: SkyFloatingLabelTextField!
    
    @IBOutlet weak var btnSubmit: SSSpinnerButton!
    // ----------------------------------------------------
    // MARK: - Base Methods
    // ----------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSubmit.submitButtonLayout(isDark : true)
        self.setNavBarWithBack(Title: "Change Password", IsNeedRightButton: false)

        txtOldPassword.tag = 0
        txtNewPassword.tag = 1
        txtConfirmPassword.tag = 2

//        setRightViewForPassword(textField: txtOldPassword)
//        setRightViewForPassword(textField: txtNewPassword)
 //       setRightViewForPassword(textField: txtConfirmPassword)
    }
    
    @IBAction func btnGoBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // ----------------------------------------------------
    // MARK: - Actions
    // ----------------------------------------------------
    @IBAction func btnSubmitAction(_ sender: UIButton) {
        
        if validation().0 {
            webserviceForChangePassword()
        } else {
            AlertMessage.showMessageForError(validation().1)
        }
    }
    
    // ----------------------------------------------------
    // MARK: - Custom Methods
    // ----------------------------------------------------
    
    func validation() -> (Bool, String) {
        
        if txtOldPassword.text!.isBlank {
            return (false, "Please enter current password")
        } else if txtNewPassword.text!.isBlank {
            return (false, "Please enter new password")
        } else if(txtNewPassword.text!.count < 6) {
            return (false,"New password length should be minimum 6 character")
        } else if txtConfirmPassword.text!.isBlank {
            return (false, "Please enter confirm password")
        } else if txtNewPassword.text != txtConfirmPassword.text {
            return (false , "Password and confirm password must be same")
        }
        
        return (true, "")
    }
    
    // ----------------------------------------------------
    // MARK: - WEbservice Methods
    // ----------------------------------------------------
    func webserviceForChangePassword() {
        
        let param: [String: Any] = ["driver_id": Singleton.shared.driverId, "new_password": txtNewPassword.text ?? "", "old_password": txtOldPassword.text ?? ""]
        
        UserWebserviceSubclass.changePassword(transferMoneyModel: param) { (response, status) in
            
            if status {
                AlertMessage.showMessageForSuccess(response["message"].stringValue)
//                self.dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
            } else {
                AlertMessage.showMessageForError(response["message"].stringValue)
            }
        }
    }

    func setRightViewForPassword(textField: UITextField)
    {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "iconHidePassword"), for: .normal)
        button.setImage(UIImage(named: "iconShowPassword"), for: .selected)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.tag = textField.tag
        button.frame = CGRect(x: CGFloat(textField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button.addTarget(self, action: #selector(self.showHidePassword), for: .touchUpInside)
        textField.rightView = button
        textField.rightViewMode = .always

    }

    @objc func showHidePassword(sender : UIButton)
    {
        sender.isSelected = !sender.isSelected

        if(sender.tag == 0)
        {
            txtOldPassword.isSecureTextEntry = !sender.isSelected
        }
        else if(sender.tag == 1)
        {
            txtNewPassword.isSecureTextEntry = !sender.isSelected
        }
        else if(sender.tag == 2)
        {
            txtConfirmPassword.isSecureTextEntry = !sender.isSelected
        }
//        txtPassword.isSecureTextEntry = !sender.isSelected

    }
}
