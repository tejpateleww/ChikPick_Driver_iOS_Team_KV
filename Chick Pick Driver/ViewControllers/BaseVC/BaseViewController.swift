//
//  BaseViewController.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 14/05/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit

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

    
    
}
