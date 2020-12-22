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
   
    static var token: String {
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
    case logout = "logout/"
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
    
    case rejectBooking = "reject_booking"
    case completeTrip = "complete_trip"
    case cancelTrip = "cancel_trip"
    case reviewRating = "review_rating"
    case cancellationCharges = "cancellation_charges/"
    
    case pastBookingHistory = "past_booking_history"
    case upcomingBookingHistory = "future_booking_history/"
    case PendingBookingHistory = "pending_booking_history/"
    
    case PaymentReceivedOrNot = "payment_received_or_not/"
    case ReviewListing = "review_listing/"
    
    case vehicleTypeModelList = "vehicle_type_manufacturer_list"
    case companyList = "company_list"
    
    case tripToDestination = "ManageTripToDestination"
    
    case FAQList = "help_categories"
    case FAQSubCategories = "help_subcategories/"
    case FAQ = "helps_faq/"
    
    case generateTicket = "generate_ticket"
    case ticketList = "ticket_list/"
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
    
    case kSocketBaseURL =  "http://18.133.15.111:8080/"  // "https://www.peppea.com:8080"
    
    case updateDriverLocation = "update_driver_location"
    case WhenRequestArrived = "forward_booking_request"
    case RejectRequest = "forward_booking_request_to_another_driver"
    case AcceptRequest = "accept_booking_request"
    case StartTrip = "start_trip"
    case LiveTracking = "live_tracking" //"driver_current_location"
    case DriverLocation = "driver_location"
    
    case onTheWayBookingRequest = "on_the_way_booking_request" // driver_id,booking_id
    case askForTips = "ask_for_tips"
    case receiveTips = "receive_tips"
    case cancelTrip = "cancel_trip"
    case CancelBookingBeforeAccept  = "cancel_booking_before_accept"
    
    case requestCodeForCompleteTrip = "request_code_for_complete_trip" // booking_id
    case arrivedAtPickupLocation = "arrived_at_pickup_location" // booking_id
    case driverArrived = "driver_arrived" // booking_id
    case verifyCustomer = "verify_customer" // customer_id, driver_id, booking_id
}


enum socketParam: String {
    
    case driverId = "driver_id"
    case lat = "lat"
    case lng = "lng"
    case bookingId = "booking_id"
    
}





