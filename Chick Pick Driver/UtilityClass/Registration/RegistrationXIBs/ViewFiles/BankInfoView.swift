//
//  BankInfoView.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 19/04/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class BankInfoView: UIView {

    var parameterArray = RegistrationParameter.shared
    
    @IBOutlet var btnNext: UIButton!
    @IBOutlet weak var bntLogin: UIButton!
  
    @IBOutlet var txtAccountHolderName: SkyFloatingLabelTextField!
    @IBOutlet var txtBankName: SkyFloatingLabelTextField!

    @IBOutlet var txtSortCode: SkyFloatingLabelTextField!
    @IBOutlet var txtAccountNumber: SkyFloatingLabelTextField!

    
    override func validationWithCompletion(_ completion: @escaping ((Bool) -> ())){

        let validationParameter :[(String?,String, ValidatiionType)] = [(txtAccountHolderName.text,accountHolderNameErrorString, .isEmpty),
                                                                        (txtAccountHolderName.text,NameAlphaErrorString, .isAlpha),
                                                                         (txtBankName.text,bankNameErrorString, .isEmpty),
                                                                         (txtSortCode.text,branchNameErrorString, .isEmpty),
                                                                         (txtAccountNumber.text,accountNumberErrorString, .numeric)]
        
        guard Validator.validate(validationParameter) else {
            completion(false)
            return
        }
        
        guard txtSortCode.text!.count >= 6 else {
            AlertMessage.showMessageForError(sortCodeValidErrorString)
            completion(false)
            return
        }
        
        
        parameterArray.account_holder_name = txtAccountHolderName.text!
        parameterArray.bank_name = txtBankName.text!
        parameterArray.bank_branch = txtSortCode.text!
        parameterArray.account_number = txtAccountNumber.text!
        parameterArray.presentIndex = 4
        
        
        do {
            //            let parameter = try UserDefaults.standard.get(objectType: RegistrationParameter.self, forKey: keyRegistrationParameter)
            let parameterRegisterArray = try UserDefaults.standard.get(objectType: RegistrationParameter.self, forKey: keyRegistrationParameter)
            
            if parameterRegisterArray != nil {
                try UserDefaults.standard.set(object: parameterArray, forKey: keyRegistrationParameter)
            } else {
                let loginData = try UserDefaults.standard.get(objectType: LoginModel.self, forKey: "userProfile") // .set(object: loginModelDetails, forKey: "userProfile")
                let parameter = loginData?.responseObject.driverDocs
                parameterArray.driver_id = parameter?.driverId ?? ""
            }
        } catch{
            completion(false)
            print(error.localizedDescription)
            return
        }
        
        completion(true)
        return
    }
    
    override func setupTextField() {
        do{
            let parameterRegisterArray = try UserDefaults.standard.get(objectType: RegistrationParameter.self, forKey: keyRegistrationParameter)
            
            print("----------------------------------------------------------")
            print("----------------------------------------------------------")
            print("SCREEN Email Details")
            print("----------------------------------------------------------")
            print("----------------------------------------------------------")
            print(parameterRegisterArray as Any)
            print("----------------------------------------------------------")
            print("----------------------------------------------------------")
            if parameterRegisterArray != nil {
                txtAccountHolderName.text = parameterRegisterArray?.account_holder_name ?? ""
                txtBankName.text = parameterRegisterArray?.bank_name ?? ""
                txtSortCode.text = parameterRegisterArray?.bank_branch ?? ""
                txtAccountNumber.text = parameterRegisterArray?.account_number ?? ""
            } else {
                 let parameterArray = try UserDefaults.standard.get(objectType: LoginModel.self, forKey: "userProfile")
                txtAccountHolderName.text = parameterArray?.responseObject.accountHolderName ?? ""
                txtBankName.text = parameterArray?.responseObject.bankName ?? ""
                txtSortCode.text = parameterArray?.responseObject.bankBranch ?? ""
                txtAccountNumber.text = parameterArray?.responseObject.accountNumber ?? ""
            }
        }
        catch{
            print(error.localizedDescription)
            return
        }
    }
}
