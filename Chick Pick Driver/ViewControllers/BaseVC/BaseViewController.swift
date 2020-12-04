//
//  BaseViewController.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 14/05/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit
import AVKit

/*
 * Every ViewController should inherit this Class (not if Presented )
 
 * Every subclass must provide
 - title
 - navType (in viewWillAppear)
 
 */
 
class BaseViewController: UIViewController {
   
    static var previousType = NavType.opaque


    func setNavBarWithMenu(Title:String, IsNeedRightButton:Bool){
        setAttributedTitle(title: Title)
        setMenuIcon()
    }

    func setNavBarWithBack(Title:String, IsNeedRightButton:Bool) {
        setAttributedTitle(title: Title)
        setBackIcon()
    }
  
    var navType: NavType = .opaque {
        didSet{
         //   customizeNavBar(type: navType)
            BaseViewController.previousType = navType
            previousNavType = navType
        }
    }
    override var title: String?{
        didSet{
         //   setAttributedTitle()
        }
    }
    var previousNavType = BaseViewController.previousType
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        guard previousNavType != navType else { return }
      //  customizeNavBar(type: previousNavType)
    }

    func isCameraAllow() -> Bool {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authStatus {
        case .authorized: return true // Do your stuff here i.e. callCameraMethod()
        case .denied: alertToEncourageCameraAccessInitially()
        case .notDetermined: alertToEncourageCameraAccessInitially()
        default: alertToEncourageCameraAccessInitially()
        }
        return false
    }

    func alertToEncourageCameraAccessInitially() {
        let alert = UIAlertController(
            title: "IMPORTANT",
            message: "Camera access required for capturing photos!",
            preferredStyle: UIAlertController.Style.alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Allow Camera", style: .cancel, handler: { (alert) -> Void in

            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        }))
        self.present(alert, animated: true)
    }
    
    func callNumber(phoneNumber:String) {

        if let phoneCallURL = URL(string: "telprompt://\(phoneNumber)") {

            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                     application.openURL(phoneCallURL as URL)

                }
            }
        }
    }
}
