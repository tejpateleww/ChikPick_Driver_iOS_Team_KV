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
    }


    func webserviceCallForInit()
    {
        let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"]  as! String
        var dictData = [String:Any]()
//        Singleton
        dictData["key"] = "ios_driver/\(buildNumber)/\(Singleton.shared.driverId)"

        WebService.shared.requestMethod(api: .Init, httpMethod: .get, parameters: dictData) { (json, status) in

            if status
            {
//                print(json)
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
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navType = .transparent
        staringImageView.startRotating()
        self.navigationController?.isNavigationBarHidden = true
        Timer.scheduledTimer(timeInterval: 1.1, target: self, selector: #selector(self.dismissSplashScreen), userInfo: nil, repeats: false)
    }
 
    @objc private func dismissSplashScreen(){
        staringImageView.stopRotating()
        self.performSegue(withIdentifier: LoginViewController.identifier, sender: self)
    }
}
