//
//  ApiPaths.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 20/04/19.
//  Copyright © 2019 baps. All rights reserved.
//

import Foundation
import UIKit


typealias NetworkRouterCompletion = ((Data?,[String:Any]?, Bool) -> ())

enum NetworkEnvironment: String {
   
    case qa = "http://18.133.15.111/api/driver_api/"
    case imageURL = "http://18.133.15.111/"
    
    static var baseURL : String{
        return NetworkEnvironment.environment.rawValue
    }
    
    static var imageBaseURL : String {
        return NetworkEnvironment.imageURL.rawValue
    }
    
    static var headers : [String:String] {
        
        if UserDefaults.standard.object(forKey: "isUserLogin") != nil {
            
            if UserDefaults.standard.object(forKey: "isUserLogin") as? Bool == true {
                
                if UserDefaults.standard.object(forKey: "userProfile") != nil {
                    var loginModelDetails: LoginModel = LoginModel()
                    do {
                        loginModelDetails = try UserDefaults.standard.get(objectType: LoginModel.self, forKey: "userProfile")!
                        return ["key":"Chickpick$951", "x-api-key": loginModelDetails.responseObject.xApiKey]
                    } catch {
                        AlertMessage.showMessageForError("error")
                        return ["key":"Chickpick$951"]
                    }
                }
            }
        }
        
        return ["key":"Chickpick$951"]
    }
   
    static var environment: NetworkEnvironment{
        //Set environment Here
        return .qa
    }
   
    static var token: String{
        return "dhuafidsuifunabneufjubefg"
    }
}

enum ApiKey: String {
        
    case Init = "init"
    case login = "login"
    case otp = "register_otp"
    case docUpload = "upload_docs"
    case vehicleTypeList = "vehicle_type_list"
    case register = "register"
    case transferMoney = "transfer_money"
    case updateAccount = "update_bank_info"
    case updateNumberOrMail = "update_email_mobile"
    case updateBasicInfo = "update_basic_info"
    case update_docs = "update_docs"
    case updateVehicleInfo = "update_vehicle_info"
    case changeDuty = "change_duty"
    case logout = "logout"
    case changePassword = "change_password"
    case forgotPassword = "forgot_password"
    case AddCard = "add_card"
    case removeCard = "remove_card"
    case cardList = "card_list"
    case walletHistory = "wallet_history"
    case transferMoneyToBank = "transfer_money_to_bank"
    case addMoney = "add_money"
    case mobileNoDetail = "mobile_no_detail"
    case QRCodeDetail = "qr_code_detail"
    case MobileNoDetail = "transfer_money_with_mobile_no" // "mobile_no_detail"
    
    case completeTrip = "complete_trip"
    case cancelTrip = "cancel_trip"
    case reviewRating = "review_rating"
    
    case pastBookingHistory = "past_booking_history"
    
    case vehicleTypeModelList = "vehicle_type_manufacturer_list"
    case companyList = "company_list"
}

enum ParameterKey{
    static let latitude = "Latitude"
    static let longitude = "Longitude"
    static let categoryId = "CategoryId"
    static let page = "Page"
    static let sortBy = "Sortby"
    static let filter = "Filter"
  
}

enum socketApiKeys: String, CaseIterable {
    
     case kSocketBaseURL = "https://www.peppea.com:8080"//"http://13.127.213.134:8080"// "https://www.shipodds.com:8080"
    //"https://www.tantaxitanzania.com:8081""http://3.120.161.225:8080""http://13.237.0.107:8080/"http://3.120.161.225:8080""https://pickngolk.info:8081" "https://pickngolk.info:8081"   // "http://54.169.67.226:8080"  //
    
    case updateDriverLocation = "update_driver_location"
    case WhenRequestArrived = "forward_booking_request"
    case RejectRequest = "forward_booking_request_to_another_driver"
    case AcceptRequest = "accept_booking_request"
    case StartTrip = "start_trip"
    case DriverCurrentLocation      = "live_tracking"//"driver_current_location"

    
    case onTheWayBookingRequest = "on_the_way_booking_request" // driver_id,booking_id
    case askForTips = "ask_for_tips"
    case receiveTips = "receive_tips"
    case cancelTrip = "cancel_trip"
   
}


enum socketParam: String {
    
    case driverId = "driver_id"
    case lat = "lat"
    case lng = "lng"
    case bookingId = "booking_id"
    
}





