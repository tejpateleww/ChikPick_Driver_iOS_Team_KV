//
//  RegistrationParameters.swift
//  Peppea-Driver
//
//  Created by EWW-iMac Old on 20/06/19.
//  Copyright © 2019 Excellent WebWorld. All rights reserved.
//

import Foundation
import UIKit
class RegistrationImageParameter{
    
    static var shared = RegistrationImageParameter()
    var profileImage = UIImage()
}


/*
 
 "driver_role:captain
 car_type:rent OR own
 owner_name:kv (optional if car_type == rent )
 owner_email:kv@gmail.com (optional if car_type == rent )
 owner_mobile_no:9865321247(optional if car_type == rent )
 first_name:mayur
 last_name:patel
 email:developer.eww@gmail.com
 password:123456
 mobile_no:321654971
 dob:1992-07-07
 gender:male OR female
 payment_method:card OR wallet OR cash
 account_holder_name:mayur shiroya
 bank_name:SBI
 bank_branch:nikol
 account_number:9876543210
 lat:23.75821
 lng:72.6523252
 device_type:android OR ios OR web
 device_token:64546546464646465465464
 address:nikol
 plate_number:GJ 301258
 year_of_manufacture:2019
 
 no_of_passenger:4
 vehicle_type:1,2,3
 invite_code : 154516156
 work_with_other_company : 1 OR 0
 other_company_name : mayur LTD(Optional if work_with_other_company  == 0 )
 profile_image (optional)
 company_id : 1 (if 'work_with_other_company' = 1 )
 -----------------------------------------------------------------
 For car image
 ----------------------------------------------------------------
 car_left
 car_right
 car_front
 car_back
 -------------------------------------------------------------------
 for documents and expiry
 -----------------------------------------------------
 ntsa_inspection_image
 ntsa_exp_date
 vehicle_insurance_certi
 vehicle_insurance_exp_date
 vehicle_log_book_image
 driver_licence_image
 driver_licence_exp_date
 national_id_image
 police_clearance_certi
 police_clearance_exp_date
 psv_badge_image
 psv_badge_exp_date
 national_id_number : 123564654"
 
 */


class RegistrationParameter: RequestModel, Codable {
    
    static var shared = RegistrationParameter()
    
    private override init(){}
    
    var driver_id = ""
    
    //Email
    var mobile_no = ""
    var email = ""
    var password = ""
    var referral_code = ""

    //UserInfo
    var driver_role = ""
    var dob = ""
    var car_type = ""
    var owner_name = ""
    var owner_email = ""
    var owner_mobile_no = ""
    var first_name = ""
    var last_name = ""
    var gender = ""
    var address = ""
    var payment_method = ""
    var invite_code = ""
    
    //Account Info
    var account_holder_name = ""
    var bank_name = ""
    var bank_branch = ""
    var account_number = ""
    
    //Vehicle Info
    var plate_number = ""
    var year_of_manufacture = ""
    var vehicle_model = ""
    var vehicle_type = ""
    var no_of_passenger = ""
    var work_with_other_company = ""
    var other_company_name = ""
    var company_id = ""
    
    var vehicle_type_model_name = ""
    var vehicle_type_model_id = ""
    var vehicle_type_manufacturer_name = ""
    var vehicle_type_manufacturer_id = ""
    
//    ---------------------------------------------------------------
//    For car image
//    ---------------------------------------------------------------
    var car_left = ""
    var car_right = ""
    var car_front = ""
    var car_back = ""
    
//    -----------------------------------------------------
//    for documents and expiry
//    -----------------------------------------------------
    
    /*
     
     "driver_id
     v5_exp_date
     vehicle_insurance_exp_date
     driver_licence_exp_date
     dlva_exp_date
     pco_badge_exp_date
     phv_exp_date
     private_exp_date
     road_exp_date
     mot_exp_date"
     
     "v5_log_book
     vehicle_insurance_certi
     driver_licence_image
     dlva_licence_image
     pco_badge_image
     phv_licence_image
     private_insurance_certi
     road_tax_certi
     mot_certi"
     
     */
    var driver_image = ""
    var v5_log_book = ""
    var v5_exp_date = ""
    var vehicle_insurance_certi = ""
    var vehicle_insurance_exp_date = ""
    var driver_licence_image = ""
    var driver_licence_exp_date = ""
    var dlva_licence_image = ""
    var dlva_exp_date = ""
    var pco_badge_image = ""
    var pco_badge_exp_date = ""
    var phv_licence_image = ""
    var phv_exp_date = ""
    var private_insurance_certi = ""
    var private_exp_date = ""
    var road_tax_certi = ""
    var road_exp_date = ""
    var mot_certi = ""
    var mot_exp_date = ""
    
    //Extra
    
    var lat = "23.75821"
    var lng = "72.6523252"
    var device_type = "ios"
    var device_token = "64546546464646465465464"
    
    
    // Storing Registration Current Page (Not a Parameter Key)
    var presentIndex = 0
    var otp = ""
    var vehicleTypeString = ""
}
