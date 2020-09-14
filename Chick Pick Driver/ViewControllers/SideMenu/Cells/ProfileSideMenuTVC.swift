//
//  ProfileSideMenuTVC.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 03/05/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit

class ProfileSideMenuTVC:  UITableViewCell {
    
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    
    func setup(user: ResponseObject){
//        let imageView = UIImageView(frame: profileImageButton.bounds)
//        imageView.setImageFromUrl(url: NetworkEnvironment.imageBaseURL + user.profileImage)
//        profileImageButton.setImage(imageView.image, for: .normal)
        
//        profileImageButton.sd_addActivityIndicator()
//        profileImageButton.sd_setShowActivityIndicatorView(true)
//        profileImageButton.sd_setIndicatorStyle(.gray)
//        profileImageButton.sd_setImage(with: URL(string: NetworkEnvironment.imageBaseURL + user.profileImage), for: .normal, completed: nil)
        
        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.width/2
//        self.imgProfile.layer.borderWidth = 3
        self.imgProfile.layer.borderColor = UIColor.lightGray.cgColor
        self.imgProfile.layer.masksToBounds = true
        self.imgProfile.contentMode = .scaleAspectFill
        
        let strImage = NetworkEnvironment.imageBaseURL + user.profileImage
       
        imgProfile.sd_setImage(with: URL(string: strImage), placeholderImage: UIImage(named: "iconPlaceHolderUser")) { (image, error, catchType, url) in
            self.imgProfile.layer.borderWidth = image?.isEqualToImage(UIImage(named: "iconPlaceHolderUser")!) ?? true ? 0 : 3
        }
        
        labelName.text = user.firstName + " " + user.lastName
        labelEmail.text = user.email
        
//        profileImageButton.layer.borderWidth = 1
//        profileImageButton.layer.borderColor = UIColor.init(named: AppTheme.shared.themeData.colors.buttonTint)?.cgColor
//        profileImageButton.layer.cornerRadius = (profileImageButton.frame.width / 2)
//        profileImageButton.layer.masksToBounds = true
    }
}

class MenuTVC: UITableViewCell {
    
    @IBOutlet weak var labelTitle: UILabel!
    
    func setup(data: (image: String,title: String)){
        labelTitle.text = data.title
    }
}
