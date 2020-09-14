//
//  ImageViewEx.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 14/05/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit
import SDWebImage

extension UIImageView{
    func setImageFromUrl(url: String){
        self.sd_addActivityIndicator()
        self.sd_setShowActivityIndicatorView(true)
        self.sd_setIndicatorStyle(.gray)
                
        self.sd_setImage(with: URL(string: url)) { (image, error, cacheType, url) in
            self.layer.cornerRadius = self.frame.size.width/2
            self.layer.masksToBounds = true
        }
    }
}

extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}

