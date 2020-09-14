//
//  RegistrationViewController.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 19/04/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit
import SSSpinnerButton
class RegistrationViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var indexView: IndexCollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnNext: SSSpinnerButton!
    @IBOutlet weak var btnPrevious: SSSpinnerButton!
    
    var presentViewType = RegistrationView.emailInfo
    var presentView : UIView!
    var pickerViewManufYear = UIPickerView()
    var pickerViewVehicleName = UIPickerView()
    var pickerViewComapanyName = UIPickerView()
    var arrYearMenufacList = [String]()
    var arrVehicleTypeName = [String]()
    var arrCompanyName = [String]()
    var pickerViewVehicleSubName = UIPickerView()
    var arrVehicleTypeSubName = VehicleData()
    var arrVehicleData = [VehicleData]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
//        pickerViewManufYear.dataSource = self
//        pickerViewManufYear.delegate = self
        
//        pickerViewVehicleName.dataSource = self
//        pickerViewVehicleName.delegate = self
         webserviceForVehicleMenufactureYearList()
//        self.webserviceForVehicleList()
//        self.webserviceForCompanyList()
        btnNext.submitButtonLayout(isDark : true)
        btnPrevious.submitButtonLayout(isDark : false)
        getFirstView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setNavBar()
    }
    
    private func setNavBar(){
//        setTitleImage()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.title = "Register"
    
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = .white
    }
   
    private func getFirstView(){
        let availableParameter = try? UserDefaults.standard.get(objectType: RegistrationParameter.self, forKey: keyRegistrationParameter)
        presentViewType = RegistrationView.allCases[((availableParameter ?? RegistrationParameter.shared) ?? RegistrationParameter.shared).presentIndex]
        presentView = presentViewType.fromNib()
        setupIndexView()
        changeView()
    }
    
    private func setupIndexView(){
        indexView.count = RegistrationView.allCases.count
        indexView.userIntraction = false
        indexView.selectedIndex = presentViewType.presentIndex
        indexView.isCircle = true
        indexView.textColor = .clear
        indexView.selectedTextColor = .clear
      }
    
    @IBAction func next(_ sender: UIButton){
        btnNext.isEnabled = false
//        view.isUserInteractionEnabled = false
        presentView.validationWithCompletion(){
            status in
            Loader.showHUD(with: UIApplication.shared.keyWindow)
            self.btnNext.isEnabled = true
            if status{
                
                if self.presentViewType.presentIndex == RegistrationView.allCases.count - 1{
                    self.webserviceRegistration()
                    return
                }
                self.presentView = self.presentViewType.nextView()
                self.changeView()
            }
//            self.view.isUserInteractionEnabled = true
             Loader.hideHUD()
        }
    }
    
    func webserviceForVehicleMenufactureYearList()
    {
//        Loader.showHUD(with: UIApplication.shared.keyWindow)
        UserWebserviceSubclass.vehicleTypeModelList(strType: ["" : ""]) { (response, status) in
//            Loader.hideHUD()
            if status
            {
                print(response)

                
                let vehicleListRes = VehicleListModel.init(fromJson: response)//init(fromJson: response)
                Singleton.shared.menufacturingYearList = vehicleListRes.yearList
                
                print(vehicleListRes.yearList)
                self.arrYearMenufacList = Singleton.shared.menufacturingYearList
                //                arrYearMenufacList = vehicleListRes.yearList
//                let arrTemp = vehicleListRes.data

//                print(arrTemp)

                self.arrVehicleData = vehicleListRes.data
                
                print(self.arrVehicleData)
                
                self.arrVehicleTypeName = vehicleListRes.data.map({$0.manufacturerName})
                let strSelectName = self.arrVehicleTypeName[0]
                _ = (self.arrVehicleData.filter({$0.manufacturerName == strSelectName}).first)
                
//                self.arrVehicleTypeSubName = (tempDic!).vehicleModel //.map({$0.vehicleTypeName as! String})
            }
            else
            {
                print(response)
            }
            
            self.webserviceForVehicleList()
        }
        
    }
    func webserviceForVehicleList()
    {
//        Loader.showHUD(with: UIApplication.shared.keyWindow)
        let param: [String: Any] = ["": ""]
        UserWebserviceSubclass.VehicleTypeListApi(strType: param) { (json, status) in
//            Loader.hideHUD()
            if status
            {
                
                print(json)
                let VehicleListDetails = VehicleListResultModel.init(fromJson: json)
                do {
                    
                    Singleton.shared.vehicleListData = VehicleListDetails
                  
                }
                catch {
                    AlertMessage.showMessageForError("error")
                    return
                }
                //                self.resetUserDefaults()
                //                UserDefaults.standard.set(false, forKey: "isUserLogin")
                //                (UIApplication.shared.delegate as! AppDelegate).setLogin()
            }
            else
            {
                AlertMessage.showMessageForError(json["message"].stringValue)
            }
            
            self.webserviceForCompanyList()
        }
    }
    func webserviceForCompanyList()
    {
//        Loader.showHUD(with: UIApplication.shared.keyWindow)
        
        let param: [String: Any] = ["": ""]
        UserWebserviceSubclass.companyList(strType: param) { (json, status) in
//            Loader.hideHUD()
//             Loader.hideHUD()
            if status
            {
                
                print(json)
                let CompanyListDetails = CompanyListModel.init(fromJson: json)
                do {
                    
                    Singleton.shared.companyListData = CompanyListDetails
                    
                    self.arrCompanyName = CompanyListDetails.data.map({$0.companyName as! String})
                }
                catch
                {
                    AlertMessage.showMessageForError("error")
                    return
                }
                //                self.resetUserDefaults()
                //                UserDefaults.standard.set(false, forKey: "isUserLogin")
                //                (UIApplication.shared.delegate as! AppDelegate).setLogin()
            }
            else
            {
                AlertMessage.showMessageForError(json["message"].stringValue)
            }
        }
    }
    
    @IBAction func back(_ sender: UIButton){
        guard presentViewType.presentIndex != 0 else {
            self.navigationController?.popViewController(animated: true	)
            return
        }
//        guard presentViewType.previousType != .otp, presentViewType.presentType != .otp else {
//            return
//        }
      
        presentView = presentViewType.previousView()
        changeView()
    }
    
    func changeView(){
       containerView.customAddSubview(presentView)
        indexView.selectedIndex = presentViewType.presentIndex
        presentView.setupTextField()
    }
    
    @IBAction func login(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    //-------------------------------------------------------------
    // MARK: - PicketView Methods
    //-------------------------------------------------------------

    
}

extension RegistrationViewController{
    
    func webserviceRegistration(){
        
        
        let parameter = try! RegistrationParameter.shared.asDictionary()
        let image = RegistrationImageParameter.shared.profileImage
        
        WebService.shared.postDataWithImage(api: .register, parameter: parameter as [String : AnyObject], image: image, imageParamName: "profile_image"){ json,status in
             Loader.hideHUD()
            if status{
//                let userDefault = UserDefaults.standard
//                userDefault.set(true, forKey: "isUserLogin")
                 AlertMessage.showMessageForSuccess(json["message"].arrayValue.first?.stringValue ?? json["message"].stringValue)
                
                (UIApplication.shared.delegate as! AppDelegate).setLogin()
            }else{
                AlertMessage.showMessageForError(json["message"].array?.first?.stringValue ?? json["message"].stringValue)
            }
        }
    }
}
