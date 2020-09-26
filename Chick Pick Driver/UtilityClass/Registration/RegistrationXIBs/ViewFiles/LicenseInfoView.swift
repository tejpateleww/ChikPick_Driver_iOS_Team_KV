//
//  LicenseInfoView.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 19/04/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
class LicenseInfoView: UIView{

      var parameterArray = RegistrationParameter.shared
    @IBOutlet weak var txtV5logbook: UITextField!
    @IBOutlet weak var txtInsuranceDocument: UITextField!
    @IBOutlet weak var txtPrivateHireLicence: UITextField!
    @IBOutlet weak var txtDVLA: UITextField!
    @IBOutlet weak var txtPCO: UITextField!
    @IBOutlet weak var txtPHV: UITextField!
    @IBOutlet weak var txtPrivateHireInsuranceCertificate: UITextField!
    @IBOutlet weak var txtRoadTax: UITextField!
    @IBOutlet weak var txtMOT: UITextField!
    
    @IBOutlet var buttons : [UIButton]!

    private func assignDelegate(){
        txtV5logbook.delegate = self
        txtInsuranceDocument.delegate = self
        txtPrivateHireLicence.delegate = self
        txtDVLA.delegate = self
        txtPCO.delegate = self
        txtPHV.delegate = self
        txtPrivateHireInsuranceCertificate.delegate = self
        txtRoadTax.delegate = self
        txtMOT.delegate = self
    }
    
    
    override func validationWithCompletion(_ completion: @escaping ((Bool) -> ())){
        let validationParameter: [(String?,String, ValidatiionType)] = [(txtV5logbook.text, V5logbookDateMissing, .isEmpty),
                                                                        (txtInsuranceDocument.text, InsuranceDocumentDateMissing, .isEmpty),
                                                                        (txtPrivateHireLicence.text, PrivateHireLicenceDateMissing, .isEmpty),
                                                                        (txtDVLA.text, DVLALicenseDateMissing, .isEmpty),
                                                                        (txtPCO.text, PCODateMissing, .isEmpty),
                                                                        (txtPHV.text, PHVLicenceDateMissing, .isEmpty),
                                                                        (txtPrivateHireInsuranceCertificate.text, PrivateHireInsuranceCertificateDateMissing, .isEmpty),
                                                                        (txtRoadTax.text, RoadTaxDateMissing, .isEmpty),
                                                                        (txtMOT.text, MOTDateMissing, .isEmpty)]
        
        guard Validator.validate(validationParameter) else {
            completion(false)
            return
        }
        
//        if txtClearanceReceipt.text!.isEmpty || txtClearanceReceipt.text == "Police Clearance Certificate/  Receipt (Expiry Date) 🗓" {
//            AlertMessage.showMessageForError(PoliceClearanceDateMissing)
//            completion(false)
//            return
//        }
        
        var status = true
        
        for button in buttons {
            guard let defaultImage = button.currentImage else { return }
            if defaultImage.isEqualToImage(#imageLiteral(resourceName: "camera-icon")) {
                
                switch button.tag {
                case 0:
                    AlertMessage.showMessageForError(driverImageMissing)
                    status = false
                    completion(status)
                    return
                case 1:
                    AlertMessage.showMessageForError(V5logbookImageMissing)
                    status = false
                    completion(status)
                    return
                case 2:
                    AlertMessage.showMessageForError(InsuranceDocumentImageMissing)
                    status = false
                    completion(status)
                    return
                case 3:
                    AlertMessage.showMessageForError(PrivateHireLicenceImageMissing)
                    status = false
                    completion(status)
                    return
                case 4:
                    AlertMessage.showMessageForError(DVLALicenseImageMissing)
                    status = false
                    completion(status)
                    return
                case 5:
                    AlertMessage.showMessageForError(PCOImageMissing)
                    status = false
                    completion(status)
                    return
                case 6:
                    AlertMessage.showMessageForError(PHVLicenceImageMissing)
                    status = false
                    completion(status)
                    return
                case 7:
                AlertMessage.showMessageForError(PrivateHireInsuranceCertificateImageMissing)
                    status = false
                    completion(status)
                    return
                case 8:
                    AlertMessage.showMessageForError(RoadTaxImageMissing)
                    status = false
                    completion(status)
                    return
                case 9:
                    AlertMessage.showMessageForError(MOTImageMissing)
                    status = false
                    completion(status)
                    return
                default:
                    AlertMessage.showMessageForError(documentImageErrorString)
                    status = false
                    completion(status)
                    return
                }
            }
        }
       
        if !status {
            completion(status)
            return
        }
        
        do {
            //            let parameter = try UserDefaults.standard.get(objectType: RegistrationParameter.self, forKey: keyRegistrationParameter)
            let loginData = try UserDefaults.standard.get(objectType: LoginModel.self, forKey: "userProfile") // .set(object: loginModelDetails, forKey: "userProfile")
            let parameterID = loginData?.responseObject.id
            parameterArray.driver_id = parameterID ?? ""
        } catch{
            print(error.localizedDescription)
            return
        }
        
        parameterArray.v5_exp_date = sendToApiFormat(strDate: txtV5logbook.text!)
        parameterArray.vehicle_insurance_exp_date = sendToApiFormat(strDate: txtInsuranceDocument.text!)
        parameterArray.driver_licence_exp_date = sendToApiFormat(strDate: txtPrivateHireLicence.text!)
        
        parameterArray.dlva_exp_date = sendToApiFormat(strDate: txtDVLA.text!)
        parameterArray.pco_badge_exp_date = sendToApiFormat(strDate: txtPCO.text!)
        
        parameterArray.phv_exp_date = sendToApiFormat(strDate: txtPHV.text!)
        parameterArray.private_exp_date = sendToApiFormat(strDate: txtPrivateHireInsuranceCertificate.text!)
        
        parameterArray.road_exp_date = sendToApiFormat(strDate: txtRoadTax.text!)
        parameterArray.mot_exp_date = sendToApiFormat(strDate: txtMOT.text!)
        
        parameterArray.presentIndex = 0
        do{
            try UserDefaults.standard.set(object: parameterArray, forKey: keyRegistrationParameter)
        }
        catch{
            completion(false)
            return
        }
        completion(true)
    }
    override func setupTextField() {
        assignDelegate()
        
//        txtLogBook.isEnabled = false
//        txtNationalId.isEnabled = false
    }
    
    func fillAllFields() {
        
        do {
//            let parameter = try UserDefaults.standard.get(objectType: RegistrationParameter.self, forKey: keyRegistrationParameter)
            let loginData = try UserDefaults.standard.get(objectType: LoginModel.self, forKey: "userProfile") // .set(object: loginModelDetails, forKey: "userProfile")
            let parameter = loginData?.responseObject.driverDocs
            
            let parameterRegisterArray = try UserDefaults.standard.get(objectType: RegistrationParameter.self, forKey: keyRegistrationParameter)
            
            if parameterRegisterArray != nil {
                print("----------------------------------------------------------")
                print("----------------------------------------------------------")
                print("SCREEN Licence Info ")
                print("----------------------------------------------------------")
                print("----------------------------------------------------------")
                print(parameterRegisterArray as Any)
                print("----------------------------------------------------------")
                print("----------------------------------------------------------")
            }
   
            
            txtV5logbook.text = changeFormat(strDate: parameter?.v5ExpDate ?? "") // parameter?.ntsaExpDate
            txtInsuranceDocument.text = changeFormat(strDate: parameter?.vehicleInsuranceExpDate ?? "")
            txtPrivateHireLicence.text = changeFormat(strDate: parameter?.driverLicenceExpDate ?? "")
            txtDVLA.text = changeFormat(strDate: parameter?.dlvaExpDate ?? "")
            txtPCO.text = changeFormat(strDate: parameter?.pcoBadgeExpDate ?? "")
            txtPHV.text = changeFormat(strDate: parameter?.phvExpDate ?? "")
            txtPrivateHireInsuranceCertificate.text = changeFormat(strDate: parameter?.privateExpDate ?? "")
            txtRoadTax.text = changeFormat(strDate: parameter?.roadExpDate ?? "")
            txtMOT.text = changeFormat(strDate: parameter?.motExpDate ?? "")
            
            let imageBase = NetworkEnvironment.imageBaseURL
          
            let driverImage = imageBase + "\(parameter?.driverImage ?? "")"
            let V5LogbookImage = imageBase + "\(parameter?.v5LogBook ?? "")"
            let InsuranceDocumentImage = imageBase + "\(parameter?.vehicleInsuranceCerti ?? "")"
            let PrivateHireLicenceImage = imageBase + "\(parameter?.driverLicenceImage ?? "")"
            let DVLAImage = imageBase + "\(parameter?.dlvaLicenceImage ?? "")"
            let PCOImage = imageBase + "\(parameter?.pcoBadgeImage ?? "")"
            let PHVImage = imageBase + "\(parameter?.phvLicenceImage ?? "")"
            let PrivateHireInsuranceCertificateImage = imageBase + "\(parameter?.privateInsuranceCerti ?? "")"
            let RoadTaxImage = imageBase + "\(parameter?.roadTaxCerti ?? "")"
            let MOTImage = imageBase + "\(parameter?.motCerti ?? "")"
            
            for btn in buttons {
                btn.sd_setIndicatorStyle(.gray)
                btn.sd_addActivityIndicator()
                btn.isUserInteractionEnabled = true
                btn.isEnabled = true
                
                if btn.tag == 0 {
                    btn.sd_setImage(with: URL(string: driverImage), for: .normal, completed: { (image, error, cacheType, url) in
                        if(image == nil){
                            btn.setImage(UIImage.init(named: "camera-icon"), for: .normal)
                        } else {
                            self.setButtonData(tag: 0, urlString: parameter?.driverImage ?? "")
                        }
                    })
                } else if btn.tag == 1 {
                    btn.sd_setImage(with: URL(string: V5LogbookImage), for: .normal, completed: { (image, error, cacheType, url) in
                        if(image == nil){
                            btn.setImage(UIImage.init(named: "camera-icon"), for: .normal)
                        } else {
                            self.setButtonData(tag: 1, urlString: parameter?.v5LogBook ?? "")
                        }
                    })
                } else if btn.tag == 2 {
                    btn.sd_setImage(with: URL(string: InsuranceDocumentImage), for: .normal, completed: { (image, error, cacheType, url) in
                        if(image == nil){
                            btn.setImage(UIImage.init(named: "camera-icon"), for: .normal)
                        } else {
                            self.setButtonData(tag: 2, urlString: parameter?.vehicleInsuranceCerti ?? "")
                        }
                    })
                } else if btn.tag == 3 {
                    btn.sd_setImage(with: URL(string: PrivateHireLicenceImage), for: .normal, completed: { (image, error, cacheType, url) in
                        if(image == nil){
                            btn.setImage(UIImage.init(named: "camera-icon"), for: .normal)
                        } else {
                            self.setButtonData(tag: 3, urlString: parameter?.driverLicenceImage ?? "")
                        }
                    })
                } else if btn.tag == 4 {
                    btn.sd_setImage(with: URL(string: DVLAImage), for: .normal, completed: { (image, error, cacheType, url) in
                        if(image == nil){
                            btn.setImage(UIImage.init(named: "camera-icon"), for: .normal)
                        } else {
                            self.setButtonData(tag: 4, urlString: parameter?.dlvaLicenceImage ?? "")
                        }
                    })
                } else if btn.tag == 5 {
                    btn.sd_setImage(with: URL(string: PCOImage), for: .normal, completed: { (image, error, cacheType, url) in
                        if(image == nil){
                            btn.setImage(UIImage.init(named: "camera-icon"), for: .normal)
                        } else {
                            self.setButtonData(tag: 5, urlString: parameter?.pcoBadgeImage ?? "")
                        }
                    })
                } else if btn.tag == 6 {
                    btn.sd_setImage(with: URL(string: PHVImage), for: .normal, completed: { (image, error, cacheType, url) in
                        if(image == nil){
                            btn.setImage(UIImage.init(named: "camera-icon"), for: .normal)
                        } else {
                             self.setButtonData(tag: 6, urlString: parameter?.phvLicenceImage ?? "")
                        }
                    })
                } else if btn.tag == 7 {
                    btn.sd_setImage(with: URL(string: PrivateHireInsuranceCertificateImage), for: .normal, completed: { (image, error, cacheType, url) in
                        if(image == nil){
                            btn.setImage(UIImage.init(named: "camera-icon"), for: .normal)
                        } else {
                            self.setButtonData(tag: 7, urlString: parameter?.privateInsuranceCerti ?? "")
                        }
                    })
                } else if btn.tag == 8 {
                    btn.sd_setImage(with: URL(string: RoadTaxImage), for: .normal, completed: { (image, error, cacheType, url) in
                        if(image == nil) {
                            btn.setImage(UIImage.init(named: "camera-icon"), for: .normal)
                        } else {
                            self.setButtonData(tag: 8, urlString: parameter?.roadTaxCerti ?? "")
                        }
                    })
                } else if btn.tag == 9 {
                    btn.sd_setImage(with: URL(string: MOTImage), for: .normal, completed: { (image, error, cacheType, url) in
                        if(image == nil) {
                            btn.setImage(UIImage.init(named: "camera-icon"), for: .normal)
                        } else {
                             self.setButtonData(tag: 9, urlString: parameter?.motCerti ?? "")
                        }
                    })
                }
            }
        } catch{
            print(error.localizedDescription)
            return
        }
    }
    
    func changeFormat(strDate: String) -> String {
        
        let apiFormat = "yyyy-MM-dd"
        let dateFormat = "dd/MM/yy" // "dd MMM yyyy"
        
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        datePickerView.locale = .current
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = apiFormat
        guard let givenDate = dateFormatter.date(from: strDate) else { return "" }
       
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = dateFormat
         
        let givenDateString = dateFormatter2.string(from: givenDate)
        
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

    
    @IBAction func openPicImage(_ sender : UIButton) {
        
        let msg = Document(rawValue: sender.tag)
        
        let alert = UIAlertController(title: AppName.kAPPName, message: msg?.messageString(), preferredStyle: .alert)
        let ok = UIAlertAction(title: "Upload", style: .default) { (action) in
            self.showImagePickerScreen(sender: sender)
        }
        //        ok.setValue(UIColor.blue, forKey: "titleTextColor")
        alert.addAction(ok)
       
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(cancel)
        
        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func showImagePickerScreen(sender : UIButton) {
        if let vc = self.parentContainerViewController() as? RegistrationViewController {
            let imageVC : ImagePickerViewController = UIViewController.viewControllerInstance(storyBoard: .picker)
            imageVC.onDismiss = {
                sender.imageView?.contentMode = .scaleAspectFit
                sender.setImage(imageVC.pickedImage, for: .normal)
                self.uploadImages(image:imageVC.pickedImage, selected: sender.tag)
                self.addDismissButton(sender)
                
                imageVC.dismiss(animated: true)
                vc.dismiss(animated: true)
            }
            vc.present(imageVC, animated: true)
        }
        else
        {
            let imageVC : ImagePickerViewController = UIViewController.viewControllerInstance(storyBoard: .picker)
            imageVC.onDismiss = {
                sender.imageView?.contentMode = .scaleAspectFit
                sender.setImage(imageVC.pickedImage, for: .normal)
                self.uploadImages(image:imageVC.pickedImage, selected: sender.tag)
                self.addDismissButton(sender)
                
                imageVC.dismiss(animated: true)
                (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.dismiss(animated: true, completion: nil)
            }
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(imageVC, animated: true)
        }
    }
    func addDismissButton(_ sender: UIButton){
        let height: CGFloat = 14
        let button = UIButton(frame: CGRect(x: sender.bounds.width - height - 1, y: -(height / 3), width: height, height: height))
        button.layer.cornerRadius = (height / 2)
        button.clipsToBounds = true
        button.setImage(#imageLiteral(resourceName: "Minus"), for: .normal)

        button.backgroundColor = .red
        button.tag = sender.tag
        button.addTarget(self, action: #selector(removeImage(_:)), for: .touchUpInside)
        sender.addSubview(button)
    }
    @objc func removeImage(_ sender: UIButton){
       let button = buttons.first(where: { $0.tag == sender.tag })
        button?.setImage(#imageLiteral(resourceName: "camera-icon"), for: .normal)
        self.setButtonData(tag: sender.tag, urlString: "")
        
        sender.removeFromSuperview()
    }
    
}
extension LicenseInfoView{
    func uploadImages(image: UIImage, selected index: Int){
        Loader.showHUD(with: self.parentContainerViewController()?.view)
        WebService.shared.postDataWithImage(api: .docUpload, parameter: [:],  image: image, imageParamName: "image"){ json,status in
            Loader.hideHUD()
            if status{
                let urlString = json["url"].stringValue
                self.setButtonData(tag: index, urlString: urlString)
            }
        }
    }
    
    func setButtonData(tag: Int, urlString: String){
        switch tag{
        case 0:
            self.parameterArray.driver_image = urlString
        case 1:
            self.parameterArray.v5_log_book = urlString
        case 2:
            self.parameterArray.vehicle_insurance_certi = urlString
        case 3:
            self.parameterArray.driver_licence_image = urlString
        case 4:
            self.parameterArray.dlva_licence_image = urlString
        case 5:
            self.parameterArray.pco_badge_image = urlString
        case 6:
            self.parameterArray.phv_licence_image = urlString
        case 7:
            self.parameterArray.private_insurance_certi = urlString
        case 8:
            self.parameterArray.road_tax_certi = urlString
        case 9:
            self.parameterArray.mot_certi = urlString
            
        default:
            break
        }
    }
}
extension LicenseInfoView : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.textColor = UIColor.init(custom: .theme)
        openDatePicker(textField)
        return false
    }
    
    func openDatePicker(_ textField: UITextField){
        if let vc = self.parentContainerViewController() as? RegistrationViewController{
            let dateVC : DatePickerViewController = UIViewController.viewControllerInstance(storyBoard: .picker)
            dateVC.onDismiss = {
                textField.text = dateVC.date
//                vc.dismiss(animated: true)
            }
            vc.present(dateVC, animated: true)
        }
        else {
            let dateVC : DatePickerViewController = UIViewController.viewControllerInstance(storyBoard: .picker)
            dateVC.onDismiss = {
                textField.text = dateVC.date
                //                vc.dismiss(animated: true)
            }
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(dateVC, animated: true)
        }
    }
}
