//
//  ThemeButton.swift
//  Pappea Driver
//
//  Created by Mayur iMac on 09/07/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit

class ThemeButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */


    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel?.font = UIFont.regular(ofSize: 16)
        self.backgroundColor = UIColor(custom: .theme)
//        self.setTitleColor(UIColor(custom: .textWhite), for: .normal)
    }
}
