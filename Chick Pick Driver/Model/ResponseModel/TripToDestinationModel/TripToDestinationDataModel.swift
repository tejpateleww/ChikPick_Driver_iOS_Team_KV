//
//  Datum.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on December 8, 2020

import Foundation
import SwiftyJSON


class TripToDestinationDataModel : Codable {

    var counter : String!
    var driverId : String!
    var id : String!
    var lat : String!
    var lng : String!
    var location : String!
    var mdate : String!
    var status : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        counter = json["counter"].stringValue
        driverId = json["driver_id"].stringValue
        id = json["id"].stringValue
        lat = json["lat"].stringValue
        lng = json["lng"].stringValue
        location = json["location"].stringValue
        mdate = json["mdate"].stringValue
        status = json["status"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if counter != nil{
        	dictionary["counter"] = counter
        }
        if driverId != nil{
        	dictionary["driver_id"] = driverId
        }
        if id != nil{
        	dictionary["id"] = id
        }
        if lat != nil{
        	dictionary["lat"] = lat
        }
        if lng != nil{
        	dictionary["lng"] = lng
        }
        if location != nil{
        	dictionary["location"] = location
        }
        if mdate != nil{
        	dictionary["mdate"] = mdate
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
		counter = aDecoder.decodeObject(forKey: "counter") as? String
		driverId = aDecoder.decodeObject(forKey: "driver_id") as? String
		id = aDecoder.decodeObject(forKey: "id") as? String
		lat = aDecoder.decodeObject(forKey: "lat") as? String
		lng = aDecoder.decodeObject(forKey: "lng") as? String
		location = aDecoder.decodeObject(forKey: "location") as? String
		mdate = aDecoder.decodeObject(forKey: "mdate") as? String
		status = aDecoder.decodeObject(forKey: "status") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if counter != nil{
			aCoder.encode(counter, forKey: "counter")
		}
		if driverId != nil{
			aCoder.encode(driverId, forKey: "driver_id")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if lat != nil{
			aCoder.encode(lat, forKey: "lat")
		}
		if lng != nil{
			aCoder.encode(lng, forKey: "lng")
		}
		if location != nil{
			aCoder.encode(location, forKey: "location")
		}
		if mdate != nil{
			aCoder.encode(mdate, forKey: "mdate")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}

	}

}
