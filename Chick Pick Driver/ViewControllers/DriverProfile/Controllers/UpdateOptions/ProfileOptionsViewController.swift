//
//  UpdateProfileViewController.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 11/05/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit

class ProfileOptionsViewController: BaseViewController {
    
    @IBOutlet weak var columns: UIView!
    var isFromCheckinScreen = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBarWithBack(Title: "Profile", IsNeedRightButton: false)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    @IBAction func didSelectItemAt(button: UIButton){
    
        let title = button.tag
        
        switch title {
        case 0:
            let next = self.storyboard?.instantiateViewController(withIdentifier: "UpdateProfileViewController") as! UpdateProfileViewController
            self.navigationController?.pushViewController(next, animated: true)
        case 1:
            print("")
            let next = self.storyboard?.instantiateViewController(withIdentifier: "UpdateVehicleInfoViewController") as! UpdateVehicleInfoViewController
            self.navigationController?.pushViewController(next, animated: true)
        case 2:
            let next = self.storyboard?.instantiateViewController(withIdentifier: "UpdateAccountViewController") as! UpdateAccountViewController
            self.navigationController?.pushViewController(next, animated: true)
        case 3:
            let next = self.storyboard?.instantiateViewController(withIdentifier: "UpdateDocumentViewController") as! UpdateDocumentViewController
            self.navigationController?.pushViewController(next, animated: true)
        default:
            print("")
        }
    }

    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}


