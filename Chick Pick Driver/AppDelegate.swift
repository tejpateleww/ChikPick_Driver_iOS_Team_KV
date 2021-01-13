//
//  AppDelegate.swift
//  Pappea Driver
//
//  Created by EWW-iMac Old on 26/06/19.
//  Copyright © 2019 baps. All rights reserved.
//


import UIKit
import IQKeyboardManagerSwift
import SideMenuSwift
import GoogleMaps
import GooglePlaces
import Fabric
import Crashlytics
import SocketIO
import Firebase
import FirebaseMessaging
import UserNotifications



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,MessagingDelegate
{
    
    var window: UIWindow?
    let locationManager = CLLocationManager()
    //    var map = Map()
    var resetMap : (() -> ())?
    
    let googlApiKey = "AIzaSyDbeyMFesrTnaEqiiHsuRMPLaVbT_ZhVe8" // -> Chick Pick
    // "AIzaSyDcug87uBhFLMo1KlqyaO10shE-sNTBCmw" -> Peppea
    let googlPlacesApiKey = "AIzaSyDbeyMFesrTnaEqiiHsuRMPLaVbT_ZhVe8" // -> Chick Pick
    // "AIzaSyDcug87uBhFLMo1KlqyaO10shE-sNTBCmw" -> Peppea
    
    var gcmMessageIDKey = String()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after a+--pplication launch.
        
        // While send to client build some features not everything
        Singleton.shared.isClientBuild = false
        
        // For stop the screen from going to sleep
        UIApplication.shared.isIdleTimerDisabled = true
        
        // Forcefully light mode
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        
        // Temp Commented by Bhautik
        
        //        for fontFamilyName in UIFont.familyNames{
        //            for fontName in UIFont.fontNames(forFamilyName: fontFamilyName){
        //                print("Family: \(fontFamilyName)     Font: \(fontName)")
        //            }
        //        }
        //
        Fabric.with([Crashlytics.self])
        FirebaseApp.configure()
        
        if UserDefaults.standard.value(forKey: keyRegistrationParameter) != nil {
            do {
                let parameterSavedArray = try UserDefaults.standard.get(objectType: RegistrationParameter.self, forKey: keyRegistrationParameter)
                //                var tamp = RegistrationParameter.shared
                if parameterSavedArray != nil {
                    //                    tamp = parameterSavedArray!
                    RegistrationParameter.shared = parameterSavedArray!
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        print(RegistrationParameter.shared.email)
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
   
        GMSServices.provideAPIKey(googlApiKey)
        GMSPlacesClient.provideAPIKey(googlPlacesApiKey)
        
        isGPSOn()
   
        window = UIWindow(frame: UIScreen.main.bounds)
        setSplash()
        setUpUserData()
        setupPushNotification(application: application)
        //        SocketIOManager.shared.socket.connect()
        //        SocketIOManager.shared.establishConnection()
        
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -200, vertical: 0), for:UIBarMetrics.default)
        
        return true
    }
    func setUpUserData()
    {
        let isLogin = UserDefaults.standard.bool(forKey: "isUserLogin")
        var LoginDetail : LoginModel = LoginModel()
        
        if isLogin
        {
            if(UserDefaults.standard.object(forKey: "userProfile") == nil) {
                return
            }
            do {
                LoginDetail = try UserDefaults.standard.get(objectType: LoginModel.self, forKey: "userProfile")!
                Singleton.shared.userProfile = LoginDetail
                Singleton.shared.driverId = LoginDetail.responseObject.id
            } catch {
                AlertMessage.showMessageForError("error")
                return
            }
        }
    }
    
    func setSplash(){
        let vc: SplashScreenViewController = UIViewController.viewControllerInstance(storyBoard: .registration)
        
        window?.rootViewController = UINavigationController(rootViewController: vc)
        window?.makeKeyAndVisible()
    }
    func setLogin(){
        let vc: LoginViewController = UIViewController.viewControllerInstance(storyBoard: .registration)
        window?.rootViewController = UINavigationController(rootViewController: vc)
        window?.makeKeyAndVisible()
    }
    func setHome(){
        let homeVC : HomeViewController = UIViewController.viewControllerInstance(storyBoard: .home)
        let menuVC : SideMenuViewController = UIViewController.viewControllerInstance(storyBoard: .home)
        
        homeVC.switchBtn.setOn(Singleton.shared.isDriverOnline, animated: false)
        
        let homeNav = NavigationController(rootViewController: homeVC)//NavigationController(rootViewController: homeVC)//
        let vc = SideMenuController(contentViewController: homeNav, menuViewController: menuVC)
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
    func setLogout()
    {
        // 1. Reset User defaults
        self.window?.rootViewController?.resetUserDefaults()
        
        // 2. Clear Singleton class
        Singleton.shared.clearSingletonClass()
        
        //3. Set isLogin USer Defaults to false
        UserDefaults.standard.set(false, forKey: "isUserLogin")
        
        //4. Remove all sockets from memory
        if let homeVC = self.window?.rootViewController?.children.first?.children.first as? HomeViewController {
            homeVC.allSocketOffMethods()
        }
        
        self.setLogin()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("App is in Background mode")
        SocketIOManager.shared.establishConnection()
        

        
        SocketIOManager.shared.socket.on(clientEvent: .connect) {data, ack in
            print ("socket connected")
            UIApplication.shared.isIdleTimerDisabled = true
            
        }
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        if (CLLocationManager.authorizationStatus() == .denied) || CLLocationManager.authorizationStatus() == .restricted || CLLocationManager.authorizationStatus() == .notDetermined {
            let alert = UIAlertController(title: AppName.kAPPName, message: "Please enable location from settings", preferredStyle: .alert)
            let enable = UIAlertAction(title: "Enable", style: .default) { (temp) in
                
                if let url = URL.init(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(URL(string: "App-Prefs:root=Privacy&path=LOCATION") ?? url, options: [:], completionHandler: nil)
                }
            }
            alert.addAction(enable)
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func setupPushNotification(application : UIApplication)
    {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_,_ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                Singleton.shared.token = result.token
                UserDefaults.standard.set(Singleton.shared.token, forKey: "Token")
                UserDefaults.standard.synchronize()
            }
        }
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        Messaging.messaging().apnsToken = deviceToken
        
        //        if let fcmToken = Messaging.messaging().fcmToken
        //        {
        //            Singleton.shared.token = fcmToken
        //        }
        //        UserDefaults.standard.set(Singleton.shared.token, forKey: "Token")
        //        UserDefaults.standard.synchronize()
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print(response)
        
        //        let content = response.notification.request.content
        let userInfo = response.notification.request.content.userInfo
        if userInfo["gcm.notification.type"] == nil { return }
        let key = (userInfo as NSDictionary).object(forKey: "gcm.notification.type")!
        
        print("USER INFo : ",userInfo)
        print("KEY : ",key)
        
        if userInfo["gcm.notification.type"] as! String == "new_book_later" {
            
            for childVc in self.window?.rootViewController?.children.first?.children ?? [] {
                if childVc.isKind(of: MyTripsViewController.self) {
                   let vc = childVc as? MyTripsViewController
                    vc?.tripType = .upcoming
                    vc?.collectionTableView.loadTheSection(ofNumber: 1)
                    vc?.LoadNewData()
                    return
                }
            }
        
            let storyboard = UIStoryboard(name: "MyTrips", bundle: nil)
            if let controller = storyboard.instantiateViewController(withIdentifier: "MyTripsViewController") as? MyTripsViewController {
                
                controller.tripType = .upcoming
                
                if let vc = self.window?.rootViewController?.children.first as? NavigationController {
                    vc.pushViewController(controller, animated: true)
                }
            }
        }
        else if userInfo["gcm.notification.type"] as! String == "canceled_trip" {
            
            for childVc in self.window?.rootViewController?.children.first?.children ?? [] {
                if childVc.isKind(of: MyTripsViewController.self) {
                   let vc = childVc as? MyTripsViewController
                    vc?.tripType = .ongoing
                    vc?.collectionTableView.loadTheSection(ofNumber: 2)
                    vc?.LoadNewData()
                    return
                }
            }
        
            let storyboard = UIStoryboard(name: "MyTrips", bundle: nil)
            if let controller = storyboard.instantiateViewController(withIdentifier: "MyTripsViewController") as? MyTripsViewController {
                
                controller.tripType = .ongoing
                
                if let vc = self.window?.rootViewController?.children.first as? NavigationController {
                    vc.pushViewController(controller, animated: true)
                }
            }
        }
        else if userInfo["gcm.notification.type"] as! String == "mpesa_payment_failed" {
            
            let storyboard = UIStoryboard(name: "Popup", bundle: nil)
            if let controller = storyboard.instantiateViewController(withIdentifier: "PaymentFailedPopupViewController") as? PaymentFailedPopupViewController {
                
                if let dic = (userInfo["aps"] as? [String : Any]) {
                    //                   print(dic["alert"])
                    if let alert = (dic["alert"] as? [String : Any]) {
                        //                        print(alert["body"])
                        controller.strMessage = alert["body"] as? String ?? ""
                    }
                }
                
                controller.strBookingId = userInfo["gcm.notification.extra_data"] as? String ?? ""
                
                if let vc = self.window?.rootViewController?.children.first as? NavigationController {
                    vc.present(controller, animated: true)
                }
            }
        }
       else if userInfo["gcm.notification.type"] as! String == "change_vehicle_request" {
            
            var strMsg = ""
            
            if let dic = (userInfo["aps"] as? [String : Any]) {
                //                   print(dic["alert"])
                if let alert = (dic["alert"] as? [String : Any]) {
                    //                        print(alert["body"])
                    strMsg = alert["body"] as? String ?? ""
                }
            }
            UtilityClass.showAlert(message: strMsg)
        }
        else if userInfo["gcm.notification.type"] as! String == "Logout" {
            self.setLogout()
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print(#function, notification.request.content.userInfo)
        //        let content = notification.request.content
        
//        completionHandler([.alert, .sound])
        
        let userInfo = notification.request.content.userInfo
        if userInfo["gcm.notification.type"] == nil { return }
        
        let key = (userInfo as NSDictionary).object(forKey: "gcm.notification.type")!
        
        print("USER INFo : ",userInfo)
        print("KEY : ",key)
        
        if userInfo["gcm.notification.type"] as! String == "mpesa_payment_failed" {
            
            let storyboard = UIStoryboard(name: "Popup", bundle: nil)
            if let controller = storyboard.instantiateViewController(withIdentifier: "PaymentFailedPopupViewController") as? PaymentFailedPopupViewController {
                
                if let dic = (userInfo["aps"] as? [String : Any]) {
                    //                   print(dic["alert"])
                    if let alert = (dic["alert"] as? [String : Any]) {
                        //                        print(alert["body"])
                        controller.strMessage = alert["body"] as? String ?? ""
                    }
                }
                
                controller.strBookingId = userInfo["gcm.notification.extra_data"] as? String ?? ""
                
                if let vc = self.window?.rootViewController?.children.first as? NavigationController {
                    vc.present(controller, animated: true)
                }
            }
        }
        else if userInfo["gcm.notification.type"] as! String == "new_book_later" {
            
            completionHandler([.alert, .sound])
            
            //           let storyboard = UIStoryboard(name: "MyTrips", bundle: nil)
            //           if let controller = storyboard.instantiateViewController(withIdentifier: "MyTripsViewController") as? MyTripsViewController {
            //
            //               if let vc = self.window?.rootViewController?.children.first as? NavigationController {
            //                   vc.pushViewController(controller, animated: true)
            //               }
            //           }
        }
        else if userInfo["gcm.notification.type"] as! String == "canceled_trip" {
            
            completionHandler([.alert, .sound])
            
            //           let storyboard = UIStoryboard(name: "MyTrips", bundle: nil)
            //           if let controller = storyboard.instantiateViewController(withIdentifier: "MyTripsViewController") as? MyTripsViewController {
            //
            //               if let vc = self.window?.rootViewController?.children.first as? NavigationController {
            //                   vc.pushViewController(controller, animated: true)
            //               }
            //           }
        }
        else if userInfo["gcm.notification.type"] as! String == "change_vehicle_request" {
            completionHandler([.alert, .sound])
            
            var strMsg = ""
            
            if let dic = (userInfo["aps"] as? [String : Any]) {
                //                   print(dic["alert"])
                if let alert = (dic["alert"] as? [String : Any]) {
                    //                        print(alert["body"])
                    strMsg = alert["body"] as? String ?? ""
                }
            }
            UtilityClass.showAlert(message: strMsg)
        }
        else if userInfo["gcm.notification.type"] as! String == "Logout" {
            completionHandler([.alert, .sound])
            self.setLogout()
        }
    }
}

// ----------------------------------------------------
// MARK: - Custom Methods
// ----------------------------------------------------

extension AppDelegate {
    
    func isGPSOn() {
        
        if CLLocationManager.locationServicesEnabled() == true {
            
            if CLLocationManager.authorizationStatus() == .restricted || CLLocationManager.authorizationStatus() == .denied ||  CLLocationManager.authorizationStatus() == .notDetermined {
                locationManager.requestWhenInUseAuthorization()
            }
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            //            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        } else {
            print("Please turn on location services or GPS")
            UtilityClass.showAlert(message: "Please turn on location services or GPS")
        }
    }
}

