//
//  UserInfo.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 19/04/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import ActionSheetPicker_3_0

class UserInfoView: UIView {
 
    var parameterArray = RegistrationParameter.shared
    
    @IBOutlet var btnMale: UIButton!
    @IBOutlet var btnFemale: UIButton!
    
    @IBOutlet var btnOwner: UIButton!
    @IBOutlet var btnRent: UIButton!
   
    @IBOutlet weak var viewOwner: UIView!

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var viewImgProfile: UIView!
    @IBOutlet weak var imgProfileHeight: NSLayoutConstraint!
    @IBOutlet weak var txtdriverRole: SkyFloatingLabelTextField!
    @IBOutlet weak var txtEmail: SkyFloatingLabelTextField!
   
    @IBOutlet weak var txtOwnerName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtOwnerMobile: SkyFloatingLabelTextField!
    @IBOutlet weak var txtPaymentMethod: SkyFloatingLabelTextField!
    @IBOutlet weak var txtFirstName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtLastName: SkyFloatingLabelTextField!


    @IBOutlet weak var txtDOB: SkyFloatingLabelTextField!
    @IBOutlet weak var txtAddress: SkyFloatingLabelTextField!
    @IBOutlet weak var txtInviteCode: SkyFloatingLabelTextField!
    
   
    var gender = Gender.male{
        didSet{
            parameterArray.gender = gender.rawValue
            btnMale.isSelected = gender == .male
            btnFemale.isSelected = !btnMale.isSelected
        }
    }
    var carType = CarType.own{
        didSet{
            parameterArray.car_type = carType.rawValue
            btnOwner.isSelected = carType == .own
            btnRent.isSelected = !btnOwner.isSelected
            
            hideOwnerDetails(btnOwner.isSelected)
        }
    }
    
    @IBAction func rentCar(_ sender: UIButton){
        carType = .rent
    }
    
   
    @IBAction func ownerCar(_ sender: UIButton){
        carType = .own
    }
    
    @IBAction func genderMale(_ sender: UIButton){
        gender = .male
    }
    
    @IBAction func genderFemale(_ sender: UIButton){
        gender = .female
        
    }
    override func setupTextField() {
        txtdriverRole.delegate = self
        txtOwnerName.delegate = self
        txtOwnerMobile.delegate = self
        txtEmail.delegate = self
        txtPaymentMethod.delegate = self
        txtFirstName.delegate = self
        txtLastName.delegate = self
        txtDOB.delegate = self
        txtAddress.delegate = self
        
//        txtOwnerMobile.leftViewMode = UITextField.ViewMode.always
//        let labelView = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: txtOwnerMobile.frame.height))
//        labelView.text = "254"
//        labelView.textAlignment = .center
//        txtOwnerMobile.leftView = labelView
        
        
        setProfile()
        setDobField()
        gender = .male
        carType = .own
        
//        txtdriverRole.setRightViewImage(name: "drop-icon", mode: .always)
        txtPaymentMethod.setRightViewImage(name: "drop-icon", mode: .always)
        
        

        do{
            let parameterArray = try UserDefaults.standard.get(objectType: RegistrationParameter.self, forKey: keyRegistrationParameter)
            
            print("----------------------------------------------------------")
            print("----------------------------------------------------------")
            print("SCREEN User Info")
            print("----------------------------------------------------------")
            print("----------------------------------------------------------")
            print(parameterArray as Any)
            print("----------------------------------------------------------")
            print("----------------------------------------------------------")
            
            txtOwnerName.text = parameterArray?.owner_name ?? ""
            txtOwnerMobile.text = parameterArray?.owner_mobile_no != "" ? parameterArray?.owner_mobile_no.replacingOccurrences(of: "+44", with: "") : ""
            txtEmail.text = parameterArray?.owner_email ?? ""
//            txtdriverRole.text = parameterArray?.driver_role.replacingOccurrences(of: "_", with: " ").capitalized ?? ""
            
            txtdriverRole.text = "Driver"
            txtdriverRole.isUserInteractionEnabled = false
            
            txtPaymentMethod.text = parameterArray?.payment_method.capitalized ?? ""
            txtFirstName.text = parameterArray?.first_name ?? ""
            txtLastName.text = parameterArray?.last_name ?? ""
            txtDOB.text = changeFormat(strDate: parameterArray?.dob ?? "")   
            txtAddress.text = parameterArray?.address ?? ""
            txtInviteCode.text = parameterArray?.invite_code ?? ""
        }
        catch{
            print(error.localizedDescription)
            return
        }
    }
    private func hideOwnerDetails(_ hide: Bool){
        endEditing(true)
        self.viewOwner.isHidden = hide
        self.txtOwnerMobile.isHidden = hide
        self.txtOwnerName.isHidden = hide
        self.txtEmail.isHidden = hide
      UIView.animate(withDuration: 0.0) {
            self.layoutIfNeeded()
        }
    }
    
    @IBAction func openPicImage(_ sender : UIButton){
        if let vc = self.parentContainerViewController() as? RegistrationViewController{
            let imageVC : ImagePickerViewController = UIViewController.viewControllerInstance(storyBoard: .picker)
            imageVC.onDismiss = {
               self.imgProfile.image = imageVC.pickedImage
                RegistrationImageParameter.shared.profileImage = imageVC.pickedImage
                imageVC.dismiss(animated: true)
                vc.dismiss(animated: true, completion: nil)
            }
            vc.present(imageVC, animated: true)
        }
    }
    
     func openDatePicker(){
        if let vc = self.parentContainerViewController() as? RegistrationViewController{
            let dateVC : DatePickerViewController = UIViewController.viewControllerInstance(storyBoard: .picker)
            dateVC.isDateOfBirth = true
            dateVC.onDismiss = {
                self.txtDOB.text = dateVC.date
//                vc.dismiss(animated: true)
            }
            vc.present(dateVC, animated: true)
        }
    }
    
    private func setProfile(){
        imgProfile.layer.cornerRadius = imgProfileHeight.constant / 2
//        imgProfile.layer.borderWidth = 3
//        imgProfile.layer.borderColor = UIColor.lightGray.cgColor
        
        imgProfile.clipsToBounds = true
        viewImgProfile.layer.shadowRadius = imgProfileHeight.constant / 2
        viewImgProfile.layer.shadowColor = UIColor.lightGray.cgColor
        viewImgProfile.layer.shadowOpacity = 1

    }
    private func setDobField(){
        let imageView = UIImageView(frame: CGRect(x: 0, y: 6, width: 30, height: 30))
        imageView.image = UIImage(named: "calendar")
        txtDOB.rightView = imageView
        txtDOB.rightViewMode = .always
    }
    

    override func validationWithCompletion(_ completion: @escaping ((Bool) -> ())){

        let validationParameter1: [(String?,String, ValidatiionType)] = [(txtdriverRole.text,driverRoleErrorString, .isEmpty)]
        
        
        let validationParameter2: [(String?,String, ValidatiionType)] = [(txtPaymentMethod.text,paymentMethodErrorString, .isEmpty),
                                                                         (txtFirstName.text,firstNameErrorString, .isEmpty),
                                                                         (txtLastName.text,lastNameErrorString, .isEmpty),
                                                                         (txtDOB.text,dobErrorString, .isEmpty),
                                                                         (txtAddress.text,addressErrorString, .isEmpty)]
        
        guard Validator.validate(validationParameter1) else {
            completion(false)
            return
        }
      
        if btnRent.isSelected{
             let validationOwner : [(String?,String, ValidatiionType)] = [(txtOwnerName.text,nameErrorString, .isEmpty),
                                                                         (txtOwnerMobile.text,numberErrorString, .isPhoneNumber),
                                                                         (txtEmail.text,emailErrorString, .email)]
            guard Validator.validate(validationOwner) else {
                completion(false)
                return
            }
        }
        
        guard Validator.validate(validationParameter2) else {
            completion(false)
            return
        }
        
        if imgProfile.image == #imageLiteral(resourceName: "iconPlaceHolderUser"){
            AlertMessage.showMessageForError("Please select profile image")
            completion(false)
            return
        }
        
        if btnRent.isSelected{
            parameterArray.owner_name = txtOwnerName.text!
            parameterArray.owner_mobile_no = "+44" + txtOwnerMobile.text!
            parameterArray.owner_email = txtEmail.text!
        }
        
        parameterArray.driver_role = txtdriverRole.text!.replacingOccurrences(of: " ", with: "_").lowercased()
        parameterArray.payment_method = txtPaymentMethod.text!.lowercased()
        parameterArray.first_name = txtFirstName.text!
        parameterArray.last_name =  txtLastName.text!
        parameterArray.dob = sendToApiFormat(strDate: txtDOB.text!) //
        parameterArray.address = txtAddress.text!
        parameterArray.invite_code = txtInviteCode.text!
        
        do {
            //            let parameter = try UserDefaults.standard.get(objectType: RegistrationParameter.self, forKey: keyRegistrationParameter)
            let loginData = try UserDefaults.standard.get(objectType: LoginModel.self, forKey: "userProfile") // .set(object: loginModelDetails, forKey: "userProfile")
            let parameter = loginData?.responseObject.driverDocs
            parameterArray.driver_id = parameter?.driverId ?? ""
        } catch{
            print(error.localizedDescription)
            return
        }
        
        if let image = self.imgProfile.image{
            if let data = image.pngData(){
              UserDefaults.standard.setValue(data, forKeyPath: keyProfileImage)
            }
            
        }
        parameterArray.presentIndex = 3
        do{ try UserDefaults.standard.set(object: parameterArray, forKey: keyRegistrationParameter)  }
        catch{  completion(false); return }
        completion(true)
        return
    }
    
    func changeFormat(strDate: String) -> String {
        
        let apiFormat = "yyyy-MM-dd"
        let dateFormat = "dd/MM/yy" // "dd MMM yyyy"
        
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        datePickerView.locale = .current
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = apiFormat
        let givenDate = dateFormatter.date(from: strDate)
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = dateFormat
        let givenDateString = dateFormatter2.string(from: givenDate ?? Date())
        
        return givenDateString
        
    }
    
    func sendToApiFormat(strDate: String) -> String {
        
        let apiFormat = "dd/MM/yy"
        let dateFormat = "yyyy-MM-dd" // "dd MMM yyyy"
        
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        datePickerView.locale = .current
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = apiFormat
        let givenDate = dateFormatter.date(from: strDate)
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = dateFormat
        let givenDateString = dateFormatter2.string(from: givenDate ?? Date())
        
        return givenDateString
    }
    
}
extension UserInfoView: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        
        case txtDOB:
            openDatePicker()
            return false
       
        case txtdriverRole:
            self.endEditing(true)
            let arrRole = ["Captain", "Super Driver", "Driver"]
          let actionSheet = ActionSheetStringPicker(title: "Select Driver Role",
                                    rows: arrRole,
                                    initialSelection: 0,
                                    doneBlock: { (picker, row, data) in
                                        print((picker, row, data))
                                            self.txtdriverRole.text = arrRole[row]
                                        },
                                    cancel: nil,
                                    origin: self)
            actionSheet?.show()
            return false
        case txtPaymentMethod:
            self.endEditing(true)
            let arrRole = ["Cash", "Wallet", "Card","Mpesa"]
            let actionSheet = ActionSheetStringPicker(title: "Select Payment Method",
                                                      rows: arrRole,
                                                      initialSelection: 0,
                                                      doneBlock: { (picker, row, data) in
                                                        print((picker, row, data))
                                                        self.txtPaymentMethod.text = arrRole[row]
                                                        },
                                                      cancel: nil,
                                                      origin: self)
            actionSheet?.show()
            return false
        default:
              return true
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == txtOwnerMobile
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
        return true
        
    }
}
