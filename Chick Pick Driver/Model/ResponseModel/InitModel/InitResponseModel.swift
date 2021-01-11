//
//  RootClass.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on October 26, 2020

import Foundation
import SwiftyJSON


class InitResponseModel : NSObject, NSCoding{

    var bookingInfo : BookingInfo!
    var cancellationCharges : [CancellationCharge]!
    var currency : String!
    var currentTime : Int!
    var docExpired : String!
    var expCompareDate : String!
    var inviteMessage : String!
    var isExpired : Int!
    var sosNumber : String!
    var status : Bool!
    var waitingTime : String!
    var update : Bool!
    var message : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        let bookingInfoJson = json["booking_info"]
        if !bookingInfoJson.isEmpty{
            bookingInfo = BookingInfo(fromJson: bookingInfoJson)
        }
        cancellationCharges = [CancellationCharge]()
        let cancellationChargesArray = json["cancellation_charges"].arrayValue
        for cancellationChargesJson in cancellationChargesArray{
            let value = CancellationCharge(fromJson: cancellationChargesJson)
            cancellationCharges.append(value)
        }
        currency = json["currency"].stringValue
        currentTime = json["current_time"].intValue
        docExpired = json["doc_expired"].stringValue
        expCompareDate = json["exp_compare_date"].stringValue
        inviteMessage = json["invite_message"].stringValue
        isExpired = json["is_expired"].intValue
        sosNumber = json["sos_number"].stringValue
        status = json["status"].boolValue
        waitingTime = json["waiting_time"].stringValue
        update = json["update"].boolValue
        message = json["message"].stringValue
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
        if cancellationCharges != nil{
        var dictionaryElements = [[String:Any]]()
        for cancellationChargesElement in cancellationCharges {
        	dictionaryElements.append(cancellationChargesElement.toDictionary())
        }
        dictionary["cancellationCharges"] = dictionaryElements
        }
        if currency != nil{
        	dictionary["currency"] = currency
        }
        if currentTime != nil{
        	dictionary["current_time"] = currentTime
        }
        if docExpired != nil{
        	dictionary["doc_expired"] = docExpired
        }
        if expCompareDate != nil{
        	dictionary["exp_compare_date"] = expCompareDate
        }
        if inviteMessage != nil{
        	dictionary["invite_message"] = inviteMessage
        }
        if isExpired != nil{
        	dictionary["is_expired"] = isExpired
        }
        if sosNumber != nil{
        	dictionary["sos_number"] = sosNumber
        }
        if status != nil{
        	dictionary["status"] = status
        }
        if waitingTime != nil{
        	dictionary["waiting_time"] = waitingTime
        }
        if update != nil{
            dictionary["update"] = update
        }
        if message != nil{
            dictionary["message"] = message
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		bookingInfo = aDecoder.decodeObject(forKey: "booking_info") as? BookingInfo
		cancellationCharges = aDecoder.decodeObject(forKey: "cancellation_charges") as? [CancellationCharge]
		currency = aDecoder.decodeObject(forKey: "currency") as? String
		currentTime = aDecoder.decodeObject(forKey: "current_time") as? Int
		docExpired = aDecoder.decodeObject(forKey: "doc_expired") as? String
		expCompareDate = aDecoder.decodeObject(forKey: "exp_compare_date") as? String
		inviteMessage = aDecoder.decodeObject(forKey: "invite_message") as? String
		isExpired = aDecoder.decodeObject(forKey: "is_expired") as? Int
		sosNumber = aDecoder.decodeObject(forKey: "sos_number") as? String
		status = aDecoder.decodeObject(forKey: "status") as? Bool
		waitingTime = aDecoder.decodeObject(forKey: "waiting_time") as? String
        update = aDecoder.decodeObject(forKey: "update") as? Bool
        message = aDecoder.decodeObject(forKey: "message") as? String
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
		if cancellationCharges != nil{
			aCoder.encode(cancellationCharges, forKey: "cancellation_charges")
		}
		if currency != nil{
			aCoder.encode(currency, forKey: "currency")
		}
		if currentTime != nil{
			aCoder.encode(currentTime, forKey: "current_time")
		}
		if docExpired != nil{
			aCoder.encode(docExpired, forKey: "doc_expired")
		}
		if expCompareDate != nil{
			aCoder.encode(expCompareDate, forKey: "exp_compare_date")
		}
		if inviteMessage != nil{
			aCoder.encode(inviteMessage, forKey: "invite_message")
		}
		if isExpired != nil{
			aCoder.encode(isExpired, forKey: "is_expired")
		}
		if sosNumber != nil{
			aCoder.encode(sosNumber, forKey: "sos_number")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}
		if waitingTime != nil{
			aCoder.encode(waitingTime, forKey: "waiting_time")
		}
        if update != nil{
            aCoder.encode(update, forKey: "update")
        }
        if message != nil{
            aCoder.encode(message, forKey: "message")
        }
	}

}
