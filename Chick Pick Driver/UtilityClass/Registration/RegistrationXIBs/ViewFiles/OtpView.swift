//
//  Second.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 19/04/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
class OtpView: UIView {
    
    var parameterArray = RegistrationParameter.shared

    @IBOutlet var btnResendOtp: UIButton!
    @IBOutlet var txtOTP: SkyFloatingLabelTextField!
    @IBOutlet var btnLogin: UIButton!

    override func setupTextField() {
//        txtOTP.text = parameterArray.otp
        print("----------------------------------------------------------")
        print("----------------------------------------------------------")
        print("SCREEN OTP")
        print("----------------------------------------------------------")
        print("----------------------------------------------------------")
        print(parameterArray as Any)
        print("----------------------------------------------------------")
        print("----------------------------------------------------------")
    }
    
    @IBAction func btnResendOTP(_ sender: UIButton) {
        
        do {
            let parameterSavedArray = try UserDefaults.standard.get(objectType: RegistrationParameter.self, forKey: keyRegistrationParameter)
            
            let parameter = try! parameterSavedArray.asDictionary()

            WebService.shared.requestMethod(api: .otp, httpMethod: .post, parameters: parameter){ json,status in
               
                if status{
                    self.parameterArray.otp = json["otp"].stringValue
                     AlertMessage.showMessageForSuccess(json["message"].stringValue)
                }else{
                    AlertMessage.showMessageForError(json["message"].stringValue)
                }
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func validationWithCompletion(_ completion: @escaping ((Bool) -> ())){
     
        guard Validator.validate([(txtOTP.text, otpEmptyErrorString, .isEmpty)]) else{
            completion(false)
            return
        }
        guard Validator.validate([(txtOTP.text, otpErrorString, .numeric)]) else{
            completion(false)
            return
        }
        guard txtOTP.text == parameterArray.otp else{
            AlertMessage.showMessageForError(otpErrorString)
            completion(false)
            return
        }
//        parameterArray.presentIndex = 2
        do{
            try UserDefaults.standard.set(object: parameterArray, forKey: keyRegistrationParameter)
            completion(true)
        }
        catch{
            completion(false)
            AlertMessage.showMessageForError("Please enter valid OTP")
            return
        }
        return
    }

}
