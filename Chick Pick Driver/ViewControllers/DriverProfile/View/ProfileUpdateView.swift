//
//  ProfileUpdateView.swift
//  Pappea Driver
//
//  Created by EWW-iMac Old on 05/07/19.
//  Copyright © 2019 baps. All rights reserved.

import UIKit
import SkyFloatingLabelTextField
 
class ProfileUpdateView: UIView {
    
    var parameterArray = RegistrationParameter.shared
    
    @IBOutlet var btnMale: UIButton!
    @IBOutlet var btnFemale: UIButton!
    @IBOutlet var btnChangePassword: UIButton!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var viewImgProfile: UIView!
    @IBOutlet weak var imgProfileHeight: NSLayoutConstraint!
    @IBOutlet weak var txtFirstName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtLastName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtDOB: SkyFloatingLabelTextField!
    @IBOutlet weak var txtAddress: SkyFloatingLabelTextField!
    
  
    
    var gender = Gender.male{
        didSet{
            parameterArray.gender = gender.rawValue
            btnMale.isSelected = gender == .male
            btnFemale.isSelected = !btnMale.isSelected
        }
    }
     @IBAction func genderMale(_ sender: UIButton){
        gender = .male
    }
    
    @IBAction func genderFemale(_ sender: UIButton){
        gender = .female
        
    }
    override func setupTextField() {
        setProfile()
        setDobField()
        gender = .male
        btnChangePassword.submitButtonLayout(isDark: false)
      
    }

    @IBAction func openPicImage(_ sender : UIButton){
        if let vc = self.parentContainerViewController() as? RegistrationViewController{
            let imageVC : ImagePickerViewController = UIViewController.viewControllerInstance(storyBoard: .picker)
            imageVC.onDismiss = {
                self.imgProfile.image = imageVC.pickedImage
                RegistrationImageParameter.shared.profileImage = imageVC.pickedImage
                imageVC.dismiss(animated: true)
                vc.dismiss(animated: true)
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
            }
            vc.present(dateVC, animated: true)
        }
    }
    
    
    
    private func setProfile(){
        imgProfile.layer.cornerRadius = imgProfileHeight.constant / 2
        imgProfile.layer.borderWidth = 3
        imgProfile.layer.borderColor = UIColor.lightGray.cgColor
        
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
        
       
        let validationParameter2: [(String?,String, ValidatiionType)] = [(txtFirstName.text,nameErrorString, .isEmpty),
                                                                         (txtLastName.text,nameErrorString, .isEmpty),
                                                                         (txtDOB.text,dobErrorString, .isEmpty),
                                                                         (txtAddress.text,addressErrorString, .isEmpty)]
        guard Validator.validate(validationParameter2) else {
            completion(false)
            return
        }
        parameterArray.first_name = txtFirstName.text!
        parameterArray.last_name =  txtLastName.text!
        parameterArray.dob = txtDOB.text!
        parameterArray.address = txtAddress.text!
        
        if let image = self.imgProfile.image{
            if let data = image.pngData(){
                UserDefaults.standard.setValue(data, forKeyPath: keyProfileImage)
            }
        }
    }
}
