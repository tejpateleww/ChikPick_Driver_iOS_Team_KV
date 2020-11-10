//
//  SideMenuTableViewController.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 03/05/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit
import SideMenuSwift

class SideMenuViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var constraintMenuWidth : NSLayoutConstraint!
    var selectedIndex = 0

    var sideMenuPreference = SideMenuController.preferences.basic
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}

extension SideMenuViewController: UITableViewDataSource, UITableViewDelegate{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return SideMenuCase.allCases.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileSideMenuTVC.identifier, for: indexPath) as! ProfileSideMenuTVC
            cell.setup(user: Singleton.shared.userProfile!.responseObject)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: MenuTVC.identifier, for: indexPath)
            cell.textLabel?.text = SideMenuCase.allCases[indexPath.row].rawValue
//            cell.backgroundColor = selectedIndex == indexPath.row ? UIColor(custom: .theme) : UIColor.clear
//            cell.textLabel?.textColor = selectedIndex == indexPath.row ?  UIColor(custom: .textWhite) : UIColor(custom: .textDark)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 1 ? 50 : UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        sideMenuController?.hideMenu()
        switch indexPath.section {
            case 0:
                pushProfileVC()
        default:
            break
        }
        switch SideMenuCase.allCases[indexPath.row] {
        case .home:
            return
//            if Singleton.shared.isClientBuild {
//                UtilityClass.showAlert(message: "Feature is coming soon...", isCancelShow: false) {
//                    self.sideMenuController?.hideMenu()
//                    return
//                }
//            }

//            pushProfileVC()
        default:
            sideMenuAction(indexPath: indexPath)
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath)!
        cell.backgroundColor = UIColor.clear
    }

    func pushProfileVC(){
        let vc : ProfileOptionsViewController = UIViewController.viewControllerInstance(storyBoard: .updateProfile)
        self.pushThroughNavigationBar(viewController: vc)
    }
    func pushPaymentVC(){
        let vc : UpdateAccountViewController = UIViewController.viewControllerInstance(storyBoard: .updateProfile)
        self.pushThroughNavigationBar(viewController: vc)
    }
    func pushWalletVC(){
        let vc : WalletViewController = UIViewController.viewControllerInstance(storyBoard: .wallet)
        self.pushThroughNavigationBar(viewController: vc)
    }
    
    func pushSettingVC(){
        let vc : SettingsViewController = UIViewController.viewControllerInstance(storyBoard: .home)
        self.pushThroughNavigationBar(viewController: vc)
    }

    func pushMyTripsVC(){
        let vc : MyTripsViewController = UIViewController.viewControllerInstance(storyBoard: .myTrips)
        self.pushThroughNavigationBar(viewController: vc)
    }
    func pushInviteVC(){
        let vc : InviteDriverViewController = UIViewController.viewControllerInstance(storyBoard: .invite)
        self.pushThroughNavigationBar(viewController: vc)
    }
    func pushToTripToDestination(){
        let vc : TripToDestinationViewController = UIViewController.viewControllerInstance(storyBoard: .tripToDestination)
        self.pushThroughNavigationBar(viewController: vc)
    }

    func pushToBid(){
        let vc : BidListContainerViewController = UIViewController.viewControllerInstance(storyBoard: .Bid)
        self.pushThroughNavigationBar(viewController: vc)
    }

    func pushThroughNavigationBar(viewController : UIViewController)
    {
        guard let navigationController = sideMenuController?.contentViewController as? NavigationController else {
            return
        }
        navigationController.pushViewController(viewController, animated: true)

        //        let parentVC = self.parent?.children.first?.children.first as! HomeViewController
        //        parentVC.navigationController?.pushViewController(vc, animated: false)
    }

    //-------------------------------------
    // MARK:- Side Menu Action
    //-------------------------------------
    
    fileprivate func sideMenuAction(indexPath: IndexPath){
        selectedIndex = indexPath.row
        let type = SideMenuCase.allCases[selectedIndex]
        tableView.reloadData()
        
        if Singleton.shared.isClientBuild {
            if type.rawValue.lowercased() != "logout" {
                UtilityClass.showAlert(message: "Feature is coming soon...", isCancelShow: false) {
                    self.sideMenuController?.hideMenu()
                    return
                }
            }
        }
        
        switch type {
        case .myTrip:
            pushMyTripsVC()
        case .payments:
            pushPaymentVC()
        case .settings:
            pushSettingVC()
            
//        case .onDemand:
//            pushProfileVC()
//        case .tripToDestination:
//            pushToTripToDestination()
//        case .airportQueue:
//            pushProfileVC()
//        case .bidMyTrip:
//            pushToBid()
//        case .invite:
//            pushInviteVC()
//        case .logout:
//
//            UtilityClass.showAlert(message: "Are you sure you want to logout?", isCancelShow: true) {
//                self.webserviceForLogout()
//            }
            
        default:
            break
        }
    }
    
    // ----------------------------------------------------
    // MARK: - Logout Webservice Method
    // ----------------------------------------------------
    
    @IBAction func btnLogoutAction(_ sender: Any) {
        
        if Singleton.shared.bookingInfo?.id == nil || Singleton.shared.bookingInfo?.id == "" {
            UtilityClass.showAlert(message: "Are you sure you want to logout?", isCancelShow: true) {
                self.webserviceForLogout()
            }
            sideMenuController?.hideMenu()
        }
        return
    }

    func webserviceForLogout() {
        
        if let token = UserDefaults.standard.object(forKey: "Token") as? String
        {
            Singleton.shared.token = token
        }

//        let LoginID = Singleton.shared.userProfile?.responseObject.id ?? ""
//        let param: [String: Any] = ["driver_id": LoginID, "device_token": Singleton.shared.token]
        let param = Singleton.shared.userProfile!.responseObject.id + "/" + Singleton.shared.token
        UserWebserviceSubclass.LogoutApi(strURL: param) { (response, status) in
            
            if status {
                self.resetUserDefaults()
//                UserDefaults.standard.set(false, forKey: "isUserLogin")
                (UIApplication.shared.delegate as! AppDelegate).setLogout()
            } else {
                AlertMessage.showMessageForError(response["message"].stringValue)
            }
        }
    }
}
