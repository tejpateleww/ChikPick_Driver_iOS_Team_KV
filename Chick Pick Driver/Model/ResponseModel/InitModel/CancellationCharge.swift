//
//  CancellationCharge.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on October 26, 2020

import Foundation
import SwiftyJSON


class CancellationCharge : NSObject, NSCoding{

    var driverCancellationFee : String!
    var id : String!
    var name : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        driverCancellationFee = json["driver_cancellation_fee"].stringValue
        id = json["id"].stringValue
        name = json["name"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if driverCancellationFee != nil{
        	dictionary["driver_cancellation_fee"] = driverCancellationFee
        }
        if id != nil{
        	dictionary["id"] = id
        }
        if name != nil{
        	dictionary["name"] = name
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		driverCancellationFee = aDecoder.decodeObject(forKey: "driver_cancellation_fee") as? String
		id = aDecoder.decodeObject(forKey: "id") as? String
		name = aDecoder.decodeObject(forKey: "name") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if driverCancellationFee != nil{
			aCoder.encode(driverCancellationFee, forKey: "driver_cancellation_fee")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}

	}

}
