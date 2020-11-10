//
//  LoginViewController.swift
//  ezygo-Driver
//
//  Created by Excellent WebWorld on 10/09/18.
//  Copyright © 2018 Excellent WebWorld. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SSSpinnerButton

class LoginViewController: UIViewController {
    @IBOutlet var txtMail: SkyFloatingLabelTextField!
    @IBOutlet var txtPassword: SkyFloatingLabelTextField!
    @IBOutlet var btnLogin: SSSpinnerButton!
    @IBOutlet var btnForgotPass: UIButton!
    @IBOutlet var btnSignUp: SSSpinnerButton!
    @IBOutlet var lblDontHaveAccount: UILabel!

    var strLatitude = Double()
    var strLongitude = Double()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        lblDontHaveAccount.font = UIFont.regular(ofSize: 15)
        btnLogin.submitButtonLayout(isDark : true)
//        btnSignUp.submitButtonLayout(isDark : false)
        
        
        if UIDevice.current.name == "EWW iPhone 7 Plus"  || UIDevice.current.name == "Excellent’s iPhone Second" || UIDevice.current.name == "Administrator’s iPhone" {
            txtMail.text = "bbb@gmail.com"
            txtPassword.text = "12345678"
        }
//
        #if targetEnvironment(simulator)
            txtMail.text = "bhavesh@ymail.com" 
            txtPassword.text = "12345678" // "qwerty"
        #else
        // your real device code
        #endif


//        setRightViewForPassword(textField: txtPassword)
      
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
    }

    @IBAction func btnSignUp(_ sender: Any)
    {
        self.performSegue(withIdentifier: RegistrationViewController.identifier, sender: self)
    }

    @IBAction func btnForgotPassClicked(_ sender: Any)
    {

    }
    @IBAction func btnLoginClicked(_ sender: Any)
    {
        guard validateFields() else { return }
        webserviceForLogin()
//        (UIApplication.shared.delegate as! AppDelegate).setHome()
    }


    func validateFields() -> Bool{
        
        let validationParameter :[(String?,String, ValidatiionType)] =  [(txtMail.text,"Please enter email/mobile number", .isEmpty),
            (txtPassword.text,"Please enter password", .password)]
        guard Validator.validate(validationParameter) else{
            return false
        }
        return true
    }
    
    func webserviceForLogin() {
       
        let logInModel : loginModel = loginModel()
        
        if txtMail.text!.isEmail
        {
            logInModel.username = txtMail.text ?? ""
        }
        else
        {
//            if txtMail.text!.count == 9
//            {
                logInModel.username = "+44" + txtMail.text!
//            }
//            else
//            {
//                AlertMessage.showMessageForError(phoneNumberErrorString)
//                return
//            }
        }
        
        logInModel.password = txtPassword.text ?? ""
        logInModel.device_type = "ios"
        logInModel.lat = "23.072633"
        logInModel.lng = "72.516421"
        logInModel.device_token = ""
        #if targetEnvironment(simulator)
        logInModel.device_token = "ertet34525353532453"
        #else
        
        #endif
        if let token = UserDefaults.standard.object(forKey: "Token") as? String
        {
            logInModel.device_token = token
        }
        Loader.showHUD(with: UIApplication.shared.keyWindow)

        UserWebserviceSubclass.login(loginModel: logInModel) { (json, status) in
            Loader.hideHUD()

            if status{
           
                UserDefaults.standard.set(true, forKey: "isUserLogin")

                let loginModelDetails = LoginModel.init(fromJson: json)
                do {
                    
                    Singleton.shared.walletBalance = loginModelDetails.responseObject.walletBalance
                    try UserDefaults.standard.set(object: loginModelDetails, forKey: "userProfile")
                    UserDefaults.standard.synchronize()
                    Singleton.shared.userProfile = loginModelDetails
                    Singleton.shared.driverId = loginModelDetails.responseObject.id
                    Singleton.shared.isDriverOnline = !(loginModelDetails.responseObject.duty == "0")
                    Singleton.shared.bookingInfo = BookingInfo.init(fromJson: json.dictionary?["booking_info"])
                    Singleton.shared.bookingInfoLoginModel = BookingInfoLoginModel(fromJson: json.dictionary?["booking_info"])
                }
                catch {
                    AlertMessage.showMessageForError("error")
                    return
                }
                (UIApplication.shared.delegate as! AppDelegate).setHome()
                
            }
            else{
                AlertMessage.showMessageForError(json["message"].stringValue)
            }
        }
    }

    func setRightViewForPassword(textField: UITextField)
    {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "iconHidePassword"), for: .normal)
        button.setImage(UIImage(named: "iconShowPassword"), for: .selected)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(textField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button.addTarget(self, action: #selector(self.showHidePassword), for: .touchUpInside)
        textField.rightView = button
        textField.rightViewMode = .always
    }

    @objc func showHidePassword(sender : UIButton)
    {
        sender.isSelected = !sender.isSelected
        txtPassword.isSecureTextEntry = !sender.isSelected

    }
}
