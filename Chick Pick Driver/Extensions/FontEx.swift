//
//  FontEx.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 17/05/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit

//MARK:- UIFont

let AppRegularFont:String = "ProximaNova-Regular"
let AppBoldFont:String = "ProximaNova-Bold"
let AppSemiboldFont:String = "ProximaNova-Semibold"

extension UIFont{

    class func regular(ofSize size: CGFloat) -> UIFont {
        return UIFont(name:  AppRegularFont, size: size)!
    }
    class func semiBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppSemiboldFont, size: size)!
    }
    class func bold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppBoldFont, size: size)!
    }

//    class func customFont(type: CustomFont.Weight, size: FontSize.Scale) -> UIFont{
//        return UIFont(name: type.fontName, size: size.size)!
//    }
//    
//    class func labelCustomFonts(labels: [UILabel],
//                                type: CustomFont.Weight, size: FontSize.Scale, colorType: Colors.Accent){
//        let color = UIColor(custom: colorType)
//        guard let font = UIFont(name: type.fontName, size: size.size)
//            else{
//                labels.forEach({
//                    $0.textColor = color
//                })
//                print("Font not available, applying system fonts!")
//                return
//        }
//        labels.forEach({
//            $0.font = font
//            $0.textColor = color
//        })
//    }
//    
//    class func buttonCustomFonts(buttons: [UIButton],type:  CustomFont.Weight, size: FontSize.Scale, colorType: Colors.Accent){
//
//        let color = UIColor(custom: colorType)
//        guard let font = UIFont(name: type.fontName, size: size.size) else{
//            print("Font not available, applying system fonts!")
//            return
//        }
//        buttons.forEach({
//            $0.titleLabel?.font = font
//            $0.setTitleColor(color, for: .normal)
//        })
//    }

    class func installedFontNames(){
        for family in UIFont.familyNames {
            print("\(family)")
            
            for name in UIFont.fontNames(forFamilyName: family) {
                print("   \(name)")
            }
        }
    }
}
