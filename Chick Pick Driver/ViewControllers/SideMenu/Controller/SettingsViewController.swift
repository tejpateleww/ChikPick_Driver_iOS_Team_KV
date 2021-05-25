//
//  SettingsViewController.swift
//  Chick Pick Driver
//
//  Created by EWW071 on 09/09/20.
//  Copyright © 2020 baps. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var arrMenuTitle = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        self.setNavBarWithBack(Title: "Settings", IsNeedRightButton: false)
        arrMenuTitle = ["Profile", "Change Password", "Help", "FAQ", "Payments", "Terms and Conditions"]
    }
    
    func pushThroughNavigationBar(viewController : UIViewController)
    {
        guard let navigationController = sideMenuController?.contentViewController as? NavigationController else {
            return
        }
        navigationController.pushViewController(viewController, animated: true)
    }
}


extension SettingsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrMenuTitle.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuTVC.identifier, for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = arrMenuTitle[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if arrMenuTitle[indexPath.row] == "Profile"
        {
            let vc : ProfileOptionsViewController = UIViewController.viewControllerInstance(storyBoard: .updateProfile)
            self.pushThroughNavigationBar(viewController: vc)
            return
        }
        
        if arrMenuTitle[indexPath.row] == "Change Password"
        {
           let vc : ChangePasswordViewController = UIViewController.viewControllerInstance(storyBoard: .updateProfile)
            self.pushThroughNavigationBar(viewController: vc)
            return
        }
        
        if arrMenuTitle[indexPath.row] == "Help"
        {
            let vc : HelpViewController = UIViewController.viewControllerInstance(storyBoard: .home)
            self.pushThroughNavigationBar(viewController: vc)
            return
        }
        
        if arrMenuTitle[indexPath.row] == "FAQ"
        {
           let vc : FAQViewController = UIViewController.viewControllerInstance(storyBoard: .home)
           self.pushThroughNavigationBar(viewController: vc)
            return
        }
        
        if arrMenuTitle[indexPath.row] == "Payments"
        {
           let vc : UpdateAccountViewController = UIViewController.viewControllerInstance(storyBoard: .updateProfile)
           self.pushThroughNavigationBar(viewController: vc)
            return
        }
        
        if arrMenuTitle[indexPath.row] == "Terms and Conditions"
        {
            if let url = URL(string: "http://18.133.15.111/terms-conditions-driver") {
                UIApplication.shared.open(url)
            }
            return
        }
    }
}
