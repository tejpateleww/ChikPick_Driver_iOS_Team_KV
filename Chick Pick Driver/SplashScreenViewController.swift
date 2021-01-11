//
//  LaunchScreenViewController.swift
//  Pappea Driver
//
//  Created by EWW-iMac Old on 27/06/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit

class SplashScreenViewController: BaseViewController {
    var LoginDetail : LoginModel = LoginModel()
    @IBOutlet weak var staringImageView: UIImageView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        webserviceCallForInit()
        do {
        Singleton.shared.tripToDestinationDataModel = try UserDefaults.standard.get(objectType: TripToDestinationDataModel.self, forKey: "TripToDestinationDataModel")
//            UserDefaults.standard.object(forKey: "TripToDestinationDataModel") as? TripToDestinationDataModel
        } catch {
            print("error")
        }
        
    }


    func webserviceCallForInit()
    {
        let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"]  as! String
        var dictData = [String:Any]()

        dictData["key"] = "ios_driver/\(buildNumber)/\(Singleton.shared.driverId)"

        WebService.shared.requestMethod(api: .Init, httpMethod: .get, parameters: dictData) { (json, status) in

            if status
            {
                if json["update"].bool != nil {
                    
                    let alert = UIAlertController(title: nil, message: json["message"].stringValue, preferredStyle: .alert)
                    let UPDATE = UIAlertAction(title: "UPDATE", style: .default, handler: { ACTION in
                        
                        if let url = URL(string: AppName.kAPPUrl),
                            UIApplication.shared.canOpenURL(url) {
                            if #available(iOS 10, *) {
                                UIApplication.shared.open(url, options: [:], completionHandler:nil)
                            } else {
                                UIApplication.shared.openURL(url)
                            }
                        }
                        
                        //                        UIApplication.shared.openURL(NSURL(string: "https://itunes.apple.com/us/app/pick-n-go/id1320783092?mt=8")! as URL)
                    })
                    let Cancel = UIAlertAction(title: "Cancel", style: .default, handler: { ACTION in
                        
                        let isLogin = UserDefaults.standard.bool(forKey: "isUserLogin")
                        if isLogin
                        {
                            (UIApplication.shared.delegate as! AppDelegate).setHome()
                        } else {
                            (UIApplication.shared.delegate as! AppDelegate).setLogin()
                        }
                    })
                    alert.addAction(UPDATE)
                    alert.addAction(Cancel)
                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    
                    let responseModel = InitResponseModel(fromJson: json)
                    let booking = json.dictionary?["booking_info"]
                    //                let cancellationCharges = json.dictionary?["cancellation_charges"]
                    Singleton.shared.isDriverOnline = booking?["driver_duty"].boolValue ?? false
                    Singleton.shared.bookingInfo = BookingInfo(fromJson: booking)
                    Singleton.shared.bookingInfoLoginModel = BookingInfoLoginModel(fromJson: booking)
                    Singleton.shared.cancelltionCharges = responseModel.cancellationCharges
                    //                Singleton.shared.cancelltionFee = responseModel.bookingInfo.vehicleType.driverCancellationFee
                    
                    
                    let isLogin = UserDefaults.standard.bool(forKey: "isUserLogin")
                    
                    if isLogin
                    {
                        if(UserDefaults.standard.object(forKey: "userProfile") == nil) {
                            return
                        }
                        do {
                            self.LoginDetail = try UserDefaults.standard.get(objectType: LoginModel.self, forKey: "userProfile")!
                            Singleton.shared.userProfile = self.LoginDetail
                            Singleton.shared.driverId = self.LoginDetail.responseObject.id
                            //                        Singleton.shared.isDriverOnline = !(self.LoginDetail.responseObject.duty == "0")
                        } catch {
                            AlertMessage.showMessageForError("error")
                            return
                        }
                        (UIApplication.shared.delegate as! AppDelegate).setHome()
                    }
                }
            }
            else {
                if let update = json["update"].bool {
                    
                    if (update) {
                        
                        let alert = UIAlertController(title: "",
                                                      message: json["message"].stringValue,
                                                      preferredStyle: UIAlertController.Style.alert)
                        
                        let okAction = UIAlertAction(title: "Update", style: .default, handler: { (action) in
                            if let url = URL(string: AppName.kAPPUrl) {
                                UIApplication.shared.open(url)
                                (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
                            }
                        })
                        
                        alert.addAction(okAction)
                        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
                    }
                    else {
                        let alert = UIAlertController(title: "",
                                                      message: json["message"].stringValue,
                                                      preferredStyle: UIAlertController.Style.alert)
                        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navType = .transparent
//        staringImageView.startRotating()
        self.navigationController?.isNavigationBarHidden = true
        Timer.scheduledTimer(timeInterval: 1.1, target: self, selector: #selector(self.dismissSplashScreen), userInfo: nil, repeats: false)
    }
 
    @objc private func dismissSplashScreen(){
//        staringImageView.stopRotating()
        self.performSegue(withIdentifier: LoginViewController.identifier, sender: self)
    }
}
