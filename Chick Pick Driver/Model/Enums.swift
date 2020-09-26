//
//  Enums.swift
//  Peppea-Driver
//
//  Created by EWW-iMac Old on 25/06/19.
//  Copyright © 2019 Excellent WebWorld. All rights reserved.
//

import Foundation

enum Gender: String{
    case male = "male"
    case female = "female"
}
enum CarType: String{
    case rent = "rent"
    case own = "own"
}


enum Document: Int {
    case DriverImage = 0
    case v5Logbook
    case insuranceDocument
    case privateHireLicence
    case DVLA
    case PCO
    case PHV
    case privateHireInsurance
    case roadTax
    case MOT
    
    
    func messageString() -> String {
        switch self {
            
        case .DriverImage:
            return "Please upload a clear picture of yourself on a while background. The picture must show your full face and should not include sunglasses, headset, earphones. This picture will be visible to passengers."
            
        case .v5Logbook:
            return "Please upload all the pages of your V5C Logbook where Car Registration details and Owner Information is clear. We can also accept Confirmation of Registration or E-Logbook."
            
        case .insuranceDocument:
            return "Your insurance document must be under your name, should contain vehicle details and must include Insurance Policy Number. Please make sure your insurance is valid for a minimum of 3 months of registering with Chick Pick or your registration will not be successful."
            
        case .privateHireLicence:
            return "Please upload the photo document of your paper licence (this is not a photo of the plastic card)"
            
        case .DVLA:
            return "Please upload a colour photo of your pink licence (NOT your PCO Badge)"
            
        case .PCO:
            return "Please upload a clear image of your Blue PCO Driver badge. This should include your private hire number and picture."
            
        case .PHV:
            return "Please upload an original photo of the paper licence. Please be aware that if the upload is not clear your registration will not be successful."
            
        case .privateHireInsurance:
            return "Your Private Hire Insurance must cover; yourself, passengers, goods for hire or reward. Please upload your Insurance Certificate or Temporary Cover Note."
            
        case .roadTax:
            return "Please upload proof of your vehicles Road Tax. Road Tax must be  a valid for next 3 months."
            
        case .MOT:
            return "Your vehicle must be MOT approved. Please upload document which states the approval of your vehicles MOT."
        }
    }
}
