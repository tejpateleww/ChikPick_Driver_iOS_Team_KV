//
//  First.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 19/04/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SDWebImage

class EmailDetailsView: UIView
{
    @IBOutlet var txtFirstName: SkyFloatingLabelTextField!
    @IBOutlet var txtLastName: SkyFloatingLabelTextField!
    @IBOutlet var txtPassword: SkyFloatingLabelTextField!
    @IBOutlet var txtEmail: SkyFloatingLabelTextField!
    @IBOutlet var txtConPassword: SkyFloatingLabelTextField!
    @IBOutlet var txtMobile: SkyFloatingLabelTextField!
    @IBOutlet var txtReferalCode: SkyFloatingLabelTextField!
    
    @IBOutlet weak var btnCheckBox: UIButton!
    @IBOutlet weak var btnTermsAndConditiond: UIButton!

    var parameterArray = RegistrationParameter.shared
    
    
    override func setupTextField(){
        
        txtMobile.delegate = self
        txtFirstName.delegate = self
        txtLastName.delegate = self

        txtPassword.tag = 0
        txtConPassword.tag = 1

//        setRightViewForPassword(textField: txtPassword)
//        setRightViewForPassword(textField: txtConPassword)

        let yourAttributes: [NSAttributedString.Key: Any] = [
              .font: UIFont.systemFont(ofSize: 12),
              .foregroundColor: UIColor(custom: .themePink),
              .underlineStyle: NSUnderlineStyle.single.rawValue]
        let attributeString = NSMutableAttributedString(string: "Terms and Conditions", attributes: yourAttributes)
             btnTermsAndConditiond.setAttributedTitle(attributeString, for: .normal)
        
        fillData()
    }
    
    @IBAction func btnTermsAndConditionsAction(_ sender: Any) {
        if let url = URL(string: "http://18.133.15.111/terms-conditions-driver") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func btnCheckBoxAction(_ sender: Any) {
        btnCheckBox.isSelected = !btnCheckBox.isSelected
    }
    
    override func validationWithCompletion(_ completion: @escaping ((Bool) -> ())){
    
        
        let validationParameter :[(String?,String, ValidatiionType)] =  [(txtFirstName.text,firstNameErrorString, .isEmpty),
        (txtLastName.text,lastNameErrorString, .isEmpty), (txtEmail.text,emailEmptyErrorString, .isEmpty),
        (txtEmail.text,emailErrorString, .email), (txtMobile.text,phoneNumberEmptyErrorString, .isEmpty),  (txtPassword.text,passwordEmptyErrorString, .isEmpty), (txtPassword.text,passwordValidErrorString, .password)]
//        (txtMobile.text,phoneNumberErrorString, .isPhoneNumber),
        
        guard Validator.validate(validationParameter) else {
            completion(false)
            return
        }
        
//        guard txtMobile.text!.count > 8 else {
//            AlertMessage.showMessageForError(phoneNumberErrorString)
//            completion(false)
//            return
//        }
        
        guard txtPassword.text!.count >= 6 else {
            AlertMessage.showMessageForError(passwordValidErrorString)
            completion(false)
            return
        }
        
        if txtConPassword.text!.count == 0 {
            AlertMessage.showMessageForError(confirmPasswordEmptyErrorString)
            completion(false)
            return
        }

        guard txtConPassword.text == txtPassword.text else {
            AlertMessage.showMessageForError(passwordMatchErrorString)
            completion(false)
            return
        }
        
        if !btnCheckBox.isSelected {
            AlertMessage.showMessageForError("Please accept the terms and conditions!")
            completion(false)
            return
        }
        
        parameterArray.first_name = txtFirstName.text!
        parameterArray.last_name =  txtLastName.text!
        parameterArray.password = txtPassword.text!
        parameterArray.mobile_no = "+44" + txtMobile.text! //"254" +  txtMobile.text!
        parameterArray.email = txtEmail.text!
        parameterArray.referral_code = txtReferalCode.text!
        
        do{
            try UserDefaults.standard.set(object: parameterArray, forKey: keyRegistrationParameter)
        }
        catch{
            completion(false)
        }
        webserviceForLogin { (status) in
            completion(status)
        }
    }
    
    func fillData() {
        
        do{
            let parameterSavedArray = try UserDefaults.standard.get(objectType: RegistrationParameter.self, forKey: keyRegistrationParameter)
            print("----------------------------------------------------------")
            print("----------------------------------------------------------")
            print("SCREEN Email Details")
            print("----------------------------------------------------------")
            print("----------------------------------------------------------")
            print(parameterArray as Any)
            print("----------------------------------------------------------")
            print("----------------------------------------------------------")
            txtFirstName.text = parameterSavedArray?.first_name
            txtLastName.text = parameterSavedArray?.last_name
            txtMobile.text = parameterSavedArray?.mobile_no.replacingOccurrences(of: "+44", with: "")
            txtEmail.text = parameterSavedArray?.email
            txtReferalCode.text = parameterSavedArray?.referral_code
            txtPassword.text = parameterSavedArray?.password
            txtConPassword.text = parameterSavedArray?.password
        }
        catch{
            print(error.localizedDescription)
            return
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
            txtPassword.isSecureTextEntry = !sender.isSelected
        }
        else if(sender.tag == 1)
        {
            txtConPassword.isSecureTextEntry = !sender.isSelected
        }
        //        txtPassword.isSecureTextEntry = !sender.isSelected

    }
    
    func webserviceForLogin(completion: @escaping (Bool) -> ()){
        let parameter = try! parameterArray.asDictionary()

        _ = UIImageView()
//        imgView.sd_setIndicatorStyle(<#T##style: UIActivityIndicatorView.Style##UIActivityIndicatorView.Style#>)

//        Loader.showHUD(with: self.parentContainerViewController()?.view)
        WebService.shared.requestMethod(api: .otp, httpMethod: .post, parameters: parameter){ json,status in
//            Loader.hideHUD()
            if status{
                self.parameterArray.otp = json["otp"].stringValue
                AlertMessage.showMessageForSuccess(json["message"].stringValue)
             }else{
                 AlertMessage.showMessageForError(json["message"].stringValue)
            }
            completion(status)
        }
    }
}


extension EmailDetailsView : UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
/*        if textField == txtMobile
        {
            let maxLength = 9
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            
            if newString.length <= maxLength
            {
                let aSet = NSCharacterSet(charactersIn:"1234567890").inverted
                let compSepByCharInSet = string.components(separatedBy: aSet)
                let numberFiltered = compSepByCharInSet.joined(separator: "")
                return string == numberFiltered
            }
            return false
        }
 */
        return true
    }
}

