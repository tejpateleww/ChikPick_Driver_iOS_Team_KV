//
//  LoginModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on July 23, 2019

import Foundation
import SwiftyJSON


class LoginModel : Codable {

    var bookingInfo : BookingInfoLoginModel!
    var currentBooking : CurrentBooking!
    var responseObject : ResponseObject!
    var message : String!
    var status : Bool!

    init() {
    }
    
	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        let currentBookingJson = json["current_booking"]
        if !currentBookingJson.isEmpty{
            currentBooking = CurrentBooking(fromJson: currentBookingJson)
        }
        let dataJson = json["data"]
        if !dataJson.isEmpty{
            responseObject = ResponseObject(fromJson: dataJson)
        }
        let bookingInfoJson = json["booking_info"]
        if !bookingInfoJson.isEmpty{
            bookingInfo = BookingInfoLoginModel(fromJson: bookingInfoJson)
        }
        message = json["message"].stringValue
        status = json["status"].boolValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        
        if bookingInfo != nil{
            dictionary["bookingInfo"] = bookingInfo.toDictionary()
        }
        if currentBooking != nil{
        	dictionary["currentBooking"] = currentBooking.toDictionary()
        }
        if responseObject != nil{
        	dictionary["data"] = responseObject.toDictionary()
        }
        if message != nil{
        	dictionary["message"] = message
        }
        if status != nil{
        	dictionary["status"] = status
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
        bookingInfo = aDecoder.decodeObject(forKey: "booking_info") as? BookingInfoLoginModel
		currentBooking = aDecoder.decodeObject(forKey: "current_booking") as? CurrentBooking
		responseObject = aDecoder.decodeObject(forKey: "data") as? ResponseObject
		message = aDecoder.decodeObject(forKey: "message") as? String
		status = aDecoder.decodeObject(forKey: "status") as? Bool
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
        if bookingInfo != nil{
            aCoder.encode(bookingInfo, forKey: "booking_info")
        }
		if currentBooking != nil{
			aCoder.encode(currentBooking, forKey: "current_booking")
		}
		if responseObject != nil{
			aCoder.encode(responseObject, forKey: "data")
		}
		if message != nil{
			aCoder.encode(message, forKey: "message")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}

	}

}
