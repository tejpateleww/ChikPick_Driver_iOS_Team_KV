//
//  RegistrationEnum.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 19/04/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit

enum RegistrationView: CaseIterable{
    case emailInfo
    case otp
//    case userInfo
//    case bankInfo
//    case vehicleInfo
//    case licenseInfo
    
    func fromNib<T: UIView>() -> T {
        switch self {
            case .emailInfo:
                let myCustomView: EmailDetailsView = .fromNib()
                return myCustomView as! T
            case .otp:
                let myCustomView: OtpView = .fromNib()
                return myCustomView as! T
//            case .userInfo:
//                let myCustomView: UserInfoView = .fromNib()
//                return myCustomView as! T
//            case .bankInfo:
//                let myCustomView: BankInfoView = .fromNib()
//                return myCustomView as! T
//            case .vehicleInfo:
//                let myCustomView: VehicleInfoView = .fromNib()
//                return myCustomView as! T
//            case .licenseInfo:
//                let myCustomView: LicenseInfoView = .fromNib()
//                return myCustomView as! T
            }
    }
    var presentIndex: Int {
        let allCases = type(of: self).allCases
        return allCases.index(of: self)!
    }
    var previousIndex: Int {
        let allCases = type(of: self).allCases
        guard allCases.index(of: self)! > 0 else{
            return 0
        }
        return allCases.index(of: self)! - 1
    }
    var presentType: RegistrationView{
        return type(of: self).allCases[presentIndex]
    }
    var previousType: RegistrationView{
        return type(of: self).allCases[previousIndex]
    }
    mutating func nextView<T: UIView>() -> T{
        let allCases = type(of: self).allCases
        self = allCases[(allCases.index(of: self)! + 1) % allCases.count]
        return fromNib()
    }
    mutating func previousView<T: UIView>() -> T{
        let allCases = type(of: self).allCases
        self = allCases[(allCases.index(of: self)! - 1 + allCases.count) % allCases.count]
        return fromNib()
    }
}


