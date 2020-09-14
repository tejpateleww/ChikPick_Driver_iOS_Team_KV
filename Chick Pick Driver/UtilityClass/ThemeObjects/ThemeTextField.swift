//
//  ThemeTextField.swift
//  Peppea
//
//  Created by Mayur iMac on 28/06/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class ThemeTextFieldLoginRegister: SkyFloatingLabelTextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectedLineHeight = 1.0
        self.lineHeight = 0.5
        self.tintColor = UIColor(custom: .theme)
        self.selectedTitleColor = UIColor(custom: .theme)
        self.placeholderColor = UIColor(custom: .theme)
        self.textColor = UIColor(custom: .theme)
        self.font = UIFont.regular(ofSize: 15)
    }

}


class ThemeTextField : UITextField
{
    override func awakeFromNib() {
        super.awakeFromNib()
        self.font = UIFont.regular(ofSize: 15)
        self.textColor = UIColor(custom: .theme)
    }
}
