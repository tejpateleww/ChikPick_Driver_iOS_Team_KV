//
//  DeviceSizes.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 14/05/19.
//  Copyright © 2019 baps. All rights reserved.
//

import Foundation
import UIKit

//-------------------------------------------------------------
// MARK: - Device Types
//-------------------------------------------------------------


struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6_7        = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P_7P      = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPHONE_X          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 812.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    static let IS_IPAD_PRO          = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
}

struct Version
{
    static let SYS_VERSION_FLOAT = (UIDevice.current.systemVersion as NSString).floatValue
    static let iOS7 = (Version.SYS_VERSION_FLOAT < 8.0 && Version.SYS_VERSION_FLOAT >= 7.0)
    static let iOS8 = (Version.SYS_VERSION_FLOAT >= 8.0 && Version.SYS_VERSION_FLOAT < 9.0)
    static let iOS9 = (Version.SYS_VERSION_FLOAT >= 9.0 && Version.SYS_VERSION_FLOAT < 10.0)
    static let iOS10 = (Version.SYS_VERSION_FLOAT >= 10.0 && Version.SYS_VERSION_FLOAT < 11.0)
    static let iOS11 = (Version.SYS_VERSION_FLOAT >= 11.0 && Version.SYS_VERSION_FLOAT < 12.0)
}
