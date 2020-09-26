//
//  VehicleInfoView.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 19/04/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import ActionSheetPicker_3_0

class VehicleInfoView: UIView
{

    @IBOutlet weak var txtVehicleNumber: SkyFloatingLabelTextField!
    @IBOutlet var txtVehicleModel: SkyFloatingLabelTextField!
    @IBOutlet var txtVehicleManufactureYear: SkyFloatingLabelTextField!
    @IBOutlet weak var txtCarType: SkyFloatingLabelTextField!
    @IBOutlet var txtNoOfPassenger: SkyFloatingLabelTextField!
    @IBOutlet var txtCompanyName: SkyFloatingLabelTextField!
    
    @IBOutlet weak var txtVehicleSubName: SkyFloatingLabelTextField!
    @IBOutlet var viewOtherCompany: UIView!
    @IBOutlet var btnOtherCompany: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    var vehicleUpdatedType = String()
    var vehicleSelectedManuID = String()
    var vehicleSelectedSubModelID = String()
    @IBOutlet var collectionView: ColumnView!
    var defaultImage = [(parameter: String,image: UIImage)]()
    var parameterArray = RegistrationParameter.shared
    var arrYearMenufacList = [String]()
    var imagesTypes : [(parameter: String,image: UIImage)] = [("car_left",#imageLiteral(resourceName: "car-1")),
                                                              ("car_right",#imageLiteral(resourceName: "car-2")),
                                                              ("car_front",#imageLiteral(resourceName: "car-3")),
                                                              ("car_back",#imageLiteral(resourceName: "car-4"))]
    
     @IBAction func workWithOtherCompany(_ sender: UIButton){
        btnOtherCompany.isSelected = !btnOtherCompany.isSelected
        parameterArray.work_with_other_company = btnOtherCompany.isSelected ? "1" : "0"
        endEditing(true)
        txtCompanyName.isHidden = !btnOtherCompany.isSelected
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }
    
    private func assignDelegate(){
        txtVehicleNumber.delegate = self
        txtVehicleModel.delegate = self
        txtVehicleManufactureYear.delegate = self
        txtVehicleSubName.delegate = self
//        txtCarType.delegate = self
        txtNoOfPassenger.delegate = self
        txtCompanyName.delegate = self
        
        if let vc = self.parentContainerViewController() as? RegistrationViewController{
            vc.pickerViewVehicleName.delegate = self
            vc.pickerViewVehicleName.dataSource = self
            vc.pickerViewManufYear.delegate = self
            vc.pickerViewManufYear.dataSource = self
            vc.pickerViewComapanyName.delegate = self
            vc.pickerViewComapanyName.dataSource = self
            vc.pickerViewVehicleSubName.delegate = self
            vc.pickerViewVehicleSubName.dataSource = self
            
            vc.pickerViewVehicleName.backgroundColor = UIColor.white
            vc.pickerViewManufYear.backgroundColor = UIColor.white
            vc.pickerViewComapanyName.backgroundColor = UIColor.white
            vc.pickerViewVehicleSubName.backgroundColor = UIColor.white
        }
    }
    
    func setupColumnView()
    {
        collectionView.imageDataSource = true
        collectionView.imageArray = imagesTypes.map { $0.image }
        collectionView.imageCornerRadius = 5
        backgroundColor = .clear
        collectionView.spacing = 5
        collectionView.collectionViewScrollDirection = .vertical
        collectionView.imageContentMode = .scaleAspectFit
        collectionView.imageBorderColor = .lightGray
        collectionView.imageBorderWidth = 1
        collectionView.noOfColumn = 2
        collectionView.imageBackgroundColor = .groupTableViewBackground
        collectionView.itemSize = CGSize(width: frame.width / CGFloat(2), height: collectionView.frame.height / CGFloat(2.4))
        
        collectionView.didSelectItemAt = {
            indexPath in
            self.didSelect(indexPath: indexPath)
        }
     }

    func didSelect(indexPath: IndexPath){
        if let vc = self.parentContainerViewController() as? RegistrationViewController{
            let imageVC : ImagePickerViewController = UIViewController.viewControllerInstance(storyBoard: .picker)
            imageVC.onDismiss = {
                self.imagesTypes[indexPath.item].image = imageVC.pickedImage
                self.uploadImages(image:imageVC.pickedImage, selected: indexPath.item)
                
                self.collectionView.imageArray = self.imagesTypes.map { $0.image }
                self.collectionView.reloadData()
                imageVC.dismiss(animated: true)
                vc.dismiss(animated: true)
            }
            vc.present(imageVC, animated: true)
        }
    }
    
    func openVehiclePicker()
    {
        /*
        if let vc = self.parentContainerViewController() as? RegistrationViewController{
            
            print(Singleton.shared.vehicleListData?.data)
            let selectorVC : MultiplePickerViewController = UIViewController.viewControllerInstance(storyBoard: .picker)
            selectorVC.titlesArray = (Singleton.shared.vehicleListData?.data.map({$0.name as! String}))!//["Premium", "Micro", "Pool", "Luxury","Bike"]
            selectorVC.selectedIndices = self.parameterArray.vehicle_type != "" ? self.parameterArray.vehicle_type.components(separatedBy: ",") : []
            selectorVC.selectedTitles = self.parameterArray.vehicleTypeString != "" ? self.parameterArray.vehicleTypeString.components(separatedBy: ", ") : []
            selectorVC.onDismiss = {
                
                var arrSelectedID = [String]()
                
                for (item) in selectorVC.selectedTitles.enumerated()
                {
                    let selectedID = ((Singleton.shared.vehicleListData?.data.filter({$0.name == item.element}).first)?.id)
                    arrSelectedID.append(selectedID as! String)
                }
                self.parameterArray.vehicle_type = arrSelectedID.joined(separator: ",")
                self.parameterArray.vehicleTypeString = selectorVC.selectedTitles.joined(separator: ", ")
                
                self.txtCarType.text = selectorVC.selectedTitles.joined(separator: ", ")
            }
            vc.present(selectorVC, animated: true)
        }*/
    }

    override func setupTextField(){
        setupColumnView()
        defaultImage = imagesTypes
        assignDelegate()
        viewOtherCompany.isHidden = parameterArray.driver_role == "driver"
        btnOtherCompany.isSelected = !viewOtherCompany.isHidden
        txtCompanyName.isHidden = !btnOtherCompany.isSelected
        parameterArray.work_with_other_company = btnOtherCompany.isSelected ? "1" : "0"
//        txtCarType.setRightViewImage(name: "drop-icon", mode: .always)
        txtCompanyName.setRightViewImage(name: "drop-icon", mode: .always)
        do{
            let parameterArray = try UserDefaults.standard.get(objectType: RegistrationParameter.self, forKey: keyRegistrationParameter)
            
            print("----------------------------------------------------------")
            print("----------------------------------------------------------")
            print("SCREEN Vehicle Info ")
            print("----------------------------------------------------------")
            print("----------------------------------------------------------")
            print(parameterArray as Any)
            print("----------------------------------------------------------")
            print("----------------------------------------------------------")
            
            txtVehicleNumber.text = parameterArray?.plate_number ?? ""
            _ = parameterArray?.vehicle_type_model_name.components(separatedBy: " ")
            
//            txtVehicleModel.text = arrVehicleName?.first
//            txtVehicleSubName.text = arrVehicleName?.last
            txtVehicleManufactureYear.text = parameterArray?.year_of_manufacture ?? ""
//            txtCarType.text = parameterArray?.vehicleTypeString ?? ""
            txtNoOfPassenger.text = parameterArray?.no_of_passenger ?? ""
            txtCompanyName.text = parameterArray?.other_company_name ?? ""
            
            // ----------------------------------------------------------
            // ----------------------------------------------------------

//            txtVehicleModel.text = parameterArray?.vehicle_type_model_name // + " " + txtVehicleSubName.text!
            txtVehicleManufactureYear.text = parameterArray?.year_of_manufacture
            txtNoOfPassenger.text = parameterArray?.no_of_passenger
            txtCompanyName.text = parameterArray?.other_company_name
            txtVehicleNumber.text = parameterArray?.plate_number
            
//            txtVehicleSubName.text =  parameterArray?.vehicle_type_model_name //+ " " + txtVehicleSubModel.text!
//            txtVehicleModel.text = parameterArray?.vehicle_type_manufacturer_name //+ " " + txtVehicleSubModel.text!
            self.vehicleUpdatedType = parameterArray?.vehicle_type ?? ""
            
            self.vehicleSelectedSubModelID = parameterArray?.vehicle_type_model_id ?? ""
            self.vehicleSelectedManuID = parameterArray?.vehicle_type_manufacturer_id ?? ""
          
            // ----------------------------------------------------------
            // ----------------------------------------------------------

        }
        catch{
            print(error.localizedDescription)
            return
        }
    }
   
    override func validationWithCompletion(_ completion: @escaping ((Bool) -> ())){
        
        let validationParameter :[(String?,String, ValidatiionType)] =
                                    [(txtVehicleNumber.text,vehicleNumberErrorString, .isEmpty),
                                   (txtVehicleModel.text,vehicleModelErrorString, .isEmpty),
                                  (txtVehicleSubName.text,vehicleSubModelErrorString, .isEmpty), (txtVehicleManufactureYear.text,manufactureYearErrorString, .isEmpty),
                                   (txtNoOfPassenger.text,noOfPassengerErrorString, .numeric)]
 
        
//        (txtCarType.text,carTypeErrorString, .isEmpty),
        guard Validator.validate(validationParameter) else {
            completion(false)
            return
        }
        
        if btnOtherCompany.isSelected{
            guard Validator.validate([(txtCompanyName.text,companyNameErrorString, .isEmpty)]) else {
                completion(false)
                return
            }
        }
        var status = true
        
        
        if collectionView.imageArray.first == #imageLiteral(resourceName: "car-1") {
            AlertMessage.showMessageForError(vehicleLeftImageErrorString)
            status = false
            completion(false)
            return
        } else if collectionView.imageArray[1] == #imageLiteral(resourceName: "car-2") {
            AlertMessage.showMessageForError(vehicleRightImageErrorString)
            status = false
            completion(false)
            return
        } else if collectionView.imageArray[2] == #imageLiteral(resourceName: "car-3") {
            AlertMessage.showMessageForError(vehicleFrontImageErrorString)
            status = false
            completion(false)
            return
        } else if collectionView.imageArray.last == #imageLiteral(resourceName: "car-4") {
            AlertMessage.showMessageForError(vehicleBackImageErrorString)
            status = false
            completion(false)
            return
        }
        
        /*
        collectionView.imageArray.forEach{
        switch $0 {
            case #imageLiteral(resourceName: "car-1"):
                AlertMessage.showMessageForError(vehicleLeftImageErrorString)
                status = false
                completion(false)
                break
            case #imageLiteral(resourceName: "car-2"):
                AlertMessage.showMessageForError(vehicleRightImageErrorString)
                status = false
                completion(false)
                break
            case #imageLiteral(resourceName: "car-3"):
                AlertMessage.showMessageForError(vehicleFrontImageErrorString)
                status = false
                completion(false)
                break
            case #imageLiteral(resourceName: "car-4"):
                AlertMessage.showMessageForError(vehicleBackImageErrorString)
                status = false
                completion(false)
                break
            default:
                print("")
            }
        }
        */
        
//        for index in imagesTypes.indices{
//            if imagesTypes[index].image == defaultImage[index].image{
//                AlertMessage.showMessageForError(vehicleImageErrorString)
//                status = false
//            }
//        }
        
        if !status { completion(status); return }
        parameterArray.vehicle_type_model_name = txtVehicleModel.text!// + " " + txtVehicleSubName.text!
        parameterArray.year_of_manufacture = txtVehicleManufactureYear.text!
        parameterArray.no_of_passenger = txtNoOfPassenger.text!
        parameterArray.other_company_name = txtCompanyName.text!
        parameterArray.plate_number = txtVehicleNumber.text!

        parameterArray.vehicle_type_model_name = txtVehicleSubName.text! //+ " " + txtVehicleSubModel.text!
        parameterArray.vehicle_type_manufacturer_name = txtVehicleModel.text! //+ " " + txtVehicleSubModel.text!
        parameterArray.vehicle_type = self.vehicleUpdatedType
        
        parameterArray.vehicle_type_model_id = self.vehicleSelectedSubModelID
        parameterArray.vehicle_type_manufacturer_id = self.vehicleSelectedManuID
        
        
        if txtCompanyName.text != ""
        {
            if (self.parentContainerViewController() as? RegistrationViewController) != nil{
                
                let arTemp = Singleton.shared.companyListData?.data
//                print(arTemp)
                let strIDCompany = (arTemp?.filter({$0.companyName == txtCompanyName.text}).first)?.id
                parameterArray.company_id = strIDCompany ?? "1"
            }
        }
        parameterArray.presentIndex = 5
        do{
            try UserDefaults.standard.set(object: parameterArray, forKey: keyRegistrationParameter)
        }
        catch{
            completion(false)
            return
        }
        completion(true)
    }
    
    func openDatePicker()
    {
        
//        arrYearMenufacList = Singleton.shared.menufacturingYearList
//        txtVehicleManufactureYear.inputView = pickerViewManufYear
        
        if let vc = self.parentContainerViewController() as? RegistrationViewController{
//            let dateVC : DatePickerViewController = UIViewController.viewControllerInstance(storyBoard: .picker)
//            dateVC.isDateOfBirth = true
//            dateVC.onDismiss = {
//                self.txtVehicleManufactureYear.text = dateVC.date
//                //                vc.dismiss(animated: true)
//            }
//            vc.present(dateVC, animated: true)
      
                txtVehicleManufactureYear.inputView = vc.pickerViewManufYear
        }
    }
}

extension VehicleInfoView: UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == txtNoOfPassenger
        {
            let maxLength = 1
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            
            if newString.length <= maxLength
            {
                let aSet = NSCharacterSet(charactersIn:"12345678").inverted
                let compSepByCharInSet = string.components(separatedBy: aSet)
                let numberFiltered = compSepByCharInSet.joined(separator: "")
                return string == numberFiltered
            }
            return false
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        switch textField {
        case txtVehicleManufactureYear:
            openDatePicker()
            return true
        case txtCarType:
//            openVehiclePicker()
            return false
            
        case txtVehicleModel:
            self.endEditing(true)
            if let vc = self.parentContainerViewController() as? RegistrationViewController{
                txtVehicleModel.inputView = vc.pickerViewVehicleName
            }
             return true
            
        case txtVehicleSubName:
            
            if txtVehicleModel.text == ""
            {
                AlertMessage.showMessageForError("Please select vehicle model")
                return false
            }
            else
            {
                if let vc = self.parentContainerViewController() as? RegistrationViewController{
                txtVehicleSubName.inputView = vc.pickerViewVehicleSubName
                }
                return true
            }
            
        case txtCompanyName:
            self.endEditing(true)
            if let vc = self.parentContainerViewController() as? RegistrationViewController{
                txtCompanyName.inputView = vc.pickerViewComapanyName
            }
//            let arrRole = ["Maruti", "Suzuki", "Zen"]
//            let actionSheet = ActionSheetStringPicker(title: "Select Company Name",
//                                                      rows: arrRole,
//                                                      initialSelection: 0,
//                                                      doneBlock: { (picker, row, data) in
//                                                        print((picker, row, data))
//                                                        self.txtCompanyName.text = arrRole[row]
//            },
//                                                      cancel: nil,
//                                                      origin: self)
//            actionSheet?.show()
            return true
        default:
            return true
        }
    }
}

extension VehicleInfoView  : UIPickerViewDelegate,UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        
        if let vc = self.parentContainerViewController() as? RegistrationViewController{
            
            if pickerView == vc.pickerViewVehicleName
            {
                return vc.arrVehicleTypeName.count
            }
            else if pickerView == vc.pickerViewVehicleSubName
            {
                return vc.arrVehicleTypeSubName.vehicleModel.count
            }
            else if pickerView == vc.pickerViewComapanyName
            {
                return vc.arrCompanyName.count
            }
            else
            {
                return vc.arrYearMenufacList.count
            }
        }
        else
        {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if let vc = self.parentContainerViewController() as? RegistrationViewController
        {
            if pickerView == vc.pickerViewVehicleName
            {
                return vc.arrVehicleTypeName[row]
            }
            else if pickerView == vc.pickerViewVehicleSubName
            {
                return vc.arrVehicleTypeSubName.vehicleModel[row].vehicleTypeModelName
            }
            else if pickerView == vc.pickerViewComapanyName
            {
                return vc.arrCompanyName[row]
            }
            else
            {
                return vc.arrYearMenufacList[row]
            }
        }
            
        else
        {
            return ""
            
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if let vc = self.parentContainerViewController() as? RegistrationViewController
        {
            if pickerView == vc.pickerViewVehicleName
            {
                let strSelectName = vc.arrVehicleData[row].manufacturerName ?? "" // vc.arrVehicleTypeName[row]
                txtVehicleModel.text = "\(strSelectName)"
                txtVehicleSubName.text = ""

                txtCarType.text = ""
                let tempDic = (vc.arrVehicleData.filter({$0.manufacturerName == strSelectName}).first)
                vc.arrVehicleTypeSubName = tempDic! // .vehicleModel.map({$0.vehicleTypeName as! String})
            }
            else if pickerView == vc.pickerViewVehicleSubName
            {
                let strSelectSubName = vc.arrVehicleTypeSubName.vehicleModel[row].vehicleTypeModelName ?? ""
                txtVehicleSubName.text = "\(strSelectSubName)"

                txtCarType.text = vc.arrVehicleTypeSubName.vehicleModel[row].vehicleTypeName ?? ""
                
                parameterArray.vehicle_type_model_name = vc.arrVehicleTypeSubName.vehicleModel[row].vehicleTypeModelName
                parameterArray.vehicle_type_model_id = vc.arrVehicleTypeSubName.vehicleModel[row].id
                parameterArray.vehicle_type_manufacturer_name = vc.arrVehicleTypeSubName.manufacturerName
                parameterArray.vehicle_type_manufacturer_id = vc.arrVehicleTypeSubName.id
                parameterArray.vehicle_type = vc.arrVehicleTypeSubName.vehicleModel[row].vehicleTypeId
      
                let temp = (vc.arrVehicleData.filter({$0.manufacturerName == txtVehicleModel.text!}).first)?.vehicleModel
                
//                print(temp)

                let newData = temp?.filter({$0.vehicleTypeModelName == strSelectSubName})
                
                self.vehicleSelectedManuID = newData?.first?.vehicleTypeManufacturerId ?? ""
                self.vehicleSelectedSubModelID = newData?.first?.id ?? ""
                self.txtCarType.text = newData?.first?.vehicleTypeName
                self.vehicleUpdatedType =  newData?.first!.vehicleTypeId ?? ""
                
                
            }
            else if pickerView == vc.pickerViewComapanyName
            {
                let strSelectCompanyName = vc.arrCompanyName[row] // vehicleTypeName
                txtCompanyName.text = "\(strSelectCompanyName)"
            }
            else
            {
                let strSelectYear = vc.arrYearMenufacList[row]
                txtVehicleManufactureYear.text = "\(strSelectYear)"
            }
        }
        else
        {
            
        }
        
    }
    
}
extension VehicleInfoView{
    func uploadImages(image: UIImage, selected index: Int)
    {
        Loader.showHUD(with: self.parentContainerViewController()?.view)
        
        WebService.shared.postDataWithImage(api: .docUpload, parameter: [:],  image: image, imageParamName: "image"){ json,status in
            Loader.hideHUD()
            if status{
                let urlString = json["url"].stringValue
                switch index{
                case 0:
                    self.parameterArray.car_left = urlString
                case 1:
                    self.parameterArray.car_right = urlString
                case 2:
                    self.parameterArray.car_front = urlString
                case 3:
                    self.parameterArray.car_back = urlString
                default:
                    break
                }
            }
        }
    }
}


