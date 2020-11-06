//
//  UpdateProfileViewController.swift
//  Pappea Driver
//
//  Created by Apple on 10/07/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SSSpinnerButton

class UpdateProfileViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    // ----------------------------------------------------
    // MARK: - Outlets
    // ----------------------------------------------------
    @IBOutlet weak var lblEmail: UILabel!
    
    @IBOutlet weak var lblMobile: UILabel!
    
    @IBOutlet var selectGender: [UIImageView]!
    @IBOutlet var selectCartype: [UIImageView]!
    
    @IBOutlet weak var txtFirstName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtLastName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtAddress: SkyFloatingLabelTextField!
    @IBOutlet weak var txtMobile: SkyFloatingLabelTextField!
    @IBOutlet weak var txtDOB: SkyFloatingLabelTextField!
    @IBOutlet weak var txtPaymentMethod: SkyFloatingLabelTextField!
    
    @IBOutlet weak var iconRadioMale: UIImageView!
    
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var btnProfilePic: UIButton!
    @IBOutlet weak var iconRadioFemale: UIImageView!
    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnChangePassword: SSSpinnerButton!
    @IBOutlet weak var btnSave: SSSpinnerButton!
    
    @IBOutlet var textFields: [SkyFloatingLabelTextField]!
    var arrPickerData = ["Cash","Wallet","Card","Mpesa"]
    var isImageSelected:Bool = false
    var isEmailedit = false
    var strDateOfBirth = String()
    
    var loginModelDetails: LoginModel = LoginModel()
    
    var didSelectMale: Bool = true {
        didSet {
            if(didSelectMale) {
                selectGender.first?.image = UIImage(named: "redio-button-select")
                selectGender.last?.image = UIImage(named: "redio-button-unselect")
            } else {
                selectGender.last?.image = UIImage(named: "redio-button-select")
                selectGender.first?.image = UIImage(named: "redio-button-unselect")
            }
        }
    }
    var pickerViewSelectPayment = UIPickerView()

    var isSelectOwnCar: Bool = true {
        didSet {
            selectCartype.first?.image = UIImage(named: isSelectOwnCar ? "redio-button-select" : "redio-button-unselect")
            selectCartype.last?.image = UIImage(named: !isSelectOwnCar ? "redio-button-select" : "redio-button-unselect")
        }
    }
    // ----------------------------------------------------
    // MARK: - Base Methods
    // ----------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Personal Information"
        
        self.btnMale.isSelected = true
        selectGender.first?.tintColor = UIColor(custom: .theme)
        selectGender.last?.tintColor = UIColor(custom: .theme)
        
        txtFirstName.titleFormatter = { $0 }
        txtLastName.titleFormatter = { $0 }
        txtAddress.titleFormatter = { $0 }
        txtMobile.titleFormatter = { $0 }
        txtDOB.titleFormatter = { $0 }
        txtPaymentMethod.titleFormatter = { $0 }
        pickerViewSelectPayment.delegate = self
        txtPaymentMethod.inputView = pickerViewSelectPayment
        
        btnChangePassword.submitButtonLayout(isDark : false)
        btnSave.submitButtonLayout(isDark : true)
        
        if UserDefaults.standard.object(forKey: "userProfile") != nil {
            do {
                loginModelDetails = try UserDefaults.standard.get(objectType: LoginModel.self, forKey: "userProfile")!
            } catch {
                AlertMessage.showMessageForError("error")
                return
            }
        }
        setData()
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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.btnProfilePic.layer.cornerRadius = self.btnProfilePic.frame.size.width/2
        self.btnProfilePic.layer.masksToBounds = true
        self.btnProfilePic.contentMode = .scaleAspectFill
        self.imgProfilePic.layer.cornerRadius = self.imgProfilePic.frame.size.width/2
        self.imgProfilePic.layer.masksToBounds = true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "updateMobile" {
            if let vc = segue.destination as? UpdateMobileEmailVC {
                vc.isFromEmail = isEmailedit
                vc.strEmailOrMobile = isEmailedit ? lblEmail.text! : txtMobile.text!
                vc.delegate = self
            }
        }
    }
    // ----------------------------------------------------
    // MARK: - Custom Methods
    // ----------------------------------------------------
    
    func validation() -> (Bool, String) {
    
        for textField in textFields {
            if (textField.text?.isBlank)! {
                return (false, "Please enter \(textField.placeholder?.lowercased() ?? "all fields")")
            }
        }
        return (true, "")
    }
    
    func createRequestModel() {
        
        let profile = loginModelDetails.responseObject
        
        if validation().0 {
            
            let model:UpdatePersonalInfo = UpdatePersonalInfo()
            
            model.first_name = txtFirstName.text!
            model.last_name = txtLastName.text!
            model.address = txtAddress.text!
            model.dob = sendToApiFormat(strDate: txtDOB.text!)
//            model.gender = didSelectMale == true ? "male" : "female"
            model.driver_id = (profile?.id)!
//            model.car_type = profile!.carType
            model.payment_method = "card"
//            if txtPaymentMethod.text == "Mpesa" {
//                model.payment_method = "m_pesa"
//            }else {
//                model.payment_method = txtPaymentMethod.text!.lowercased()
//            }
            
//            model.car_type = isSelectOwnCar ? "own" : "rent"
            model.mobile_no = lblMobile.text!
            model.email = lblEmail.text!
            
            webserviceForSavePersonalProfile(uerData: model)
            
        } else {
            AlertMessage.showMessageForError(validation().1)
        }
    }
    
    func setData() {
        
        let profile = loginModelDetails.responseObject
        
        lblEmail.text = profile?.email
        lblMobile.text = profile?.mobileNo
        
        txtFirstName.text = profile?.firstName
        txtLastName.text = profile?.lastName
        txtAddress.text = profile?.address
//        txtMobile.text =  profile!.mobileNo
        
        let strSubString = profile!.mobileNo[profile!.mobileNo.index(at: 3)...]
        txtMobile.text = String(strSubString)
        
        isSelectOwnCar = (profile!.carType == "own") ? true : false
        if profile?.paymentMethod == "m_pesa" {
            txtPaymentMethod.text = "Mpesa"
        }else {
            txtPaymentMethod.text = profile?.paymentMethod.capitalized
        }
        
        txtDOB.text = changeFormat(strDate: profile?.dob ?? "", isBirthDate: true)
        
        if profile?.gender.lowercased() == "male" {
            didSelectMale = true
        } else {
            didSelectMale = false
        }
        
//        btnProfilePic.sd_addActivityIndicator()
//        btnProfilePic.sd_setShowActivityIndicatorView(true)
//        btnProfilePic.sd_setIndicatorStyle(.gray)
//        btnProfilePic.sd_setImage(with: URL(string: NetworkEnvironment.imageBaseURL + (profile?.profileImage ?? "")), for: .normal, completed: nil)
//
//        btnProfilePic.layer.borderWidth = 1
//        btnProfilePic.layer.borderColor = UIColor.init(named: AppTheme.shared.themeData.colors.buttonTint)?.cgColor
//        btnProfilePic.layer.cornerRadius = (btnProfilePic.frame.width / 2)
//        btnProfilePic.layer.masksToBounds = true
        
        let strImage = NetworkEnvironment.imageBaseURL + profile!.profileImage
        
        imgProfilePic.sd_setImage(with: URL(string: strImage), placeholderImage: UIImage(named: "iconPlaceHolderUser")) { (image, error, catchType, url) in
            self.imgProfilePic.layer.borderWidth = image?.isEqualToImage(UIImage(named: "iconPlaceHolderUser")!) ?? true ? 0 : 3
        }
        
        imgProfilePic.layer.borderColor = UIColor.lightGray.cgColor
        imgProfilePic.layer.masksToBounds = true
    }
    
    @IBAction func btnSaveClicked(_ sender: Any) {
        createRequestModel()
    }
    
    @IBAction func btnProfilePicClicked(_ sender: Any) {
        self.TapToProfilePicture()
    }
    
    @IBAction func btnMaleClicked(_ sender: UIButton) {
        //        self.iconRadioMale.image = UIImage.init(named: "SelectedCircle")
        //        self.iconRadioFemale.image = UIImage.init(named: "UnSelectedCircle")
        if(sender.tag == 1) // Male
        {
            didSelectMale = true
        }
        else if (sender.tag == 2) // Female
        {
            didSelectMale = false
        }
    }
    @IBAction func cartypeClick(_ sender: UIButton) {
        isSelectOwnCar = (sender.tag == 101)
        
    }
    @IBAction func btnFemaleClicked(_ sender: Any) {
        //        self.iconRadioFemale.image = UIImage.init(named: "SelectedCircle")
        //        self.iconRadioMale.image = UIImage.init(named: "UnSelectedCircle")
    }
    
    @IBAction func editClick(_ sender: UIButton) {
 //       isEmailedit = (sender.tag == 111) // For updating email
//        if sender.tag == 111 {
//
//        }else {
//
//        }
    }
    // MARK: - Pick Image
    func TapToProfilePicture() {
        let message = "Please upload a clear picture of yourself on a while background. The picture must show your full face and should not include sunglasses, headset, earphones. This picture will be visible to passengers."
        
        let alert = UIAlertController(title: AppName.kAPPName, message: message, preferredStyle: .alert)
         let ok = UIAlertAction(title: "Upload", style: .default) { (action) in
            
             let alert = UIAlertController(title: "Choose Options", message: nil, preferredStyle: .alert)
             
             let Gallery = UIAlertAction(title: "Gallery", style: .default, handler: { ACTION in
                 self.PickingImageFromGallery()
             })
             let Camera  = UIAlertAction(title: "Camera", style: .default, handler: { ACTION in
                 self.PickingImageFromCamera()
             })
             let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
             
             alert.addAction(Gallery)
             alert.addAction(Camera)
             alert.addAction(cancel)
             self.present(alert, animated: true, completion: nil)
         }
         //        ok.setValue(UIColor.blue, forKey: "titleTextColor")
         alert.addAction(ok)
        
         let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
         alert.addAction(cancel)
         
         self.present(alert, animated: true, completion: nil)
        
        
    }
    
    func PickingImageFromGallery() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        // picker.stopVideoCapture()
        //        picker.mediaTypes = [kUTTypeImage as String]
        //UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        
//        setNavigationFontBlack()
        present(picker, animated: true, completion: nil)
    }
    
    func PickingImageFromCamera() {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
//        setNavigationFontBlack()
        present(picker, animated: true, completion: nil)
    }
    
    // MARK: - Image Delegate and DataSource Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.isImageSelected = true
//            btnProfilePic.imageView?.contentMode = .scaleToFill
//            btnProfilePic.setImage(pickedImage, for: .normal)
            imgProfilePic.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func txtDateOfBirth(_ sender: SkyFloatingLabelTextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        datePickerView.maximumDate = Calendar.current.date(byAdding: .year, value: -21, to: Date())
        datePickerView.locale = .current
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.pickupdateMethod(_:)), for: UIControl.Event.valueChanged)
    }
    
    @objc func pickupdateMethod(_ sender: UIDatePicker) {
        let dateFormaterView = DateFormatter()
        dateFormaterView.dateFormat = "dd-MM-yyyy"
        txtDOB.text = dateFormaterView.string(from: sender.date)
        strDateOfBirth = txtDOB.text!
        
    }
    
    @IBAction func btnChangePasswordClicked(_ sender: Any) {
//        let storyborad = UIStoryboard(name: "LoginRegister", bundle: nil)
//        let ChangePwVC = storyborad.instantiateViewController(withIdentifier: "ChangePwVC") as! ChangePwVC
//        self.navigationController?.pushViewController(ChangePwVC, animated: true)
    }
    
    // ----------------------------------------------------
    // MARK: - Webservice Methods
    // ----------------------------------------------------

    func webserviceForSavePersonalProfile(uerData: UpdatePersonalInfo) {
        
        Loader.showHUD(with: UIApplication.shared.keyWindow)
        
        UserWebserviceSubclass.updatePersonal(transferMoneyModel: uerData, image: imgProfilePic.image!, imageParamName: "profile_image") { (response, status) in
            
            print(response)
            
            Loader.hideHUD()
            
            if status {
                
                let loginModelDetails = LoginModel.init(fromJson: response)
                do {
                    try UserDefaults.standard.set(object: loginModelDetails, forKey: "userProfile")
                    UserDefaults.standard.synchronize()
                }
                catch {
                    print("Error")
                }
                AlertMessage.showMessageForSuccess(response["message"].stringValue)
                self.navigationController?.popViewController(animated: true)
                
            } else {
                AlertMessage.showMessageForError(response["message"].arrayValue.first?.stringValue ?? response["message"].stringValue)
            }
        }
    }
}
extension UpdateProfileViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
}

extension UpdateProfileViewController: UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrPickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrPickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtPaymentMethod.text = arrPickerData[row]
    }
    
}

extension String {
    func index(at: Int) -> String.Index {
        return self.index(self.startIndex, offsetBy: at)
    }
}
extension UpdateProfileViewController: updateMobileOrEmailDataSource {
    func updateData(update: String, isEmail: Bool) {
        if isEmail {
            lblEmail.text = update
        }else {
            txtMobile.text = update
            lblMobile.text = update
        }
    }
}
