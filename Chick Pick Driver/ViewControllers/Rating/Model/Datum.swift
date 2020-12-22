//
//  Datum.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on December 22, 2020

import Foundation
import SwiftyJSON


class Datum : NSObject, NSCoding{

    var bookingId : String!
    var comment : String!
    var createdAt : String!
    var dropoffLocation : String!
    var firstName : String!
    var id : String!
    var lastName : String!
    var pickupLocation : String!
    var profileImage : String!
    var rating : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        bookingId = json["booking_id"].stringValue
        comment = json["comment"].stringValue
        createdAt = json["created_at"].stringValue
        dropoffLocation = json["dropoff_location"].stringValue
        firstName = json["first_name"].stringValue
        id = json["id"].stringValue
        lastName = json["last_name"].stringValue
        pickupLocation = json["pickup_location"].stringValue
        profileImage = json["profile_image"].stringValue
        rating = json["rating"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if bookingId != nil{
        	dictionary["booking_id"] = bookingId
        }
        if comment != nil{
        	dictionary["comment"] = comment
        }
        if createdAt != nil{
        	dictionary["created_at"] = createdAt
        }
        if dropoffLocation != nil{
        	dictionary["dropoff_location"] = dropoffLocation
        }
        if firstName != nil{
        	dictionary["first_name"] = firstName
        }
        if id != nil{
        	dictionary["id"] = id
        }
        if lastName != nil{
        	dictionary["last_name"] = lastName
        }
        if pickupLocation != nil{
        	dictionary["pickup_location"] = pickupLocation
        }
        if profileImage != nil{
        	dictionary["profile_image"] = profileImage
        }
        if rating != nil{
        	dictionary["rating"] = rating
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		bookingId = aDecoder.decodeObject(forKey: "booking_id") as? String
		comment = aDecoder.decodeObject(forKey: "comment") as? String
		createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
		dropoffLocation = aDecoder.decodeObject(forKey: "dropoff_location") as? String
		firstName = aDecoder.decodeObject(forKey: "first_name") as? String
		id = aDecoder.decodeObject(forKey: "id") as? String
		lastName = aDecoder.decodeObject(forKey: "last_name") as? String
		pickupLocation = aDecoder.decodeObject(forKey: "pickup_location") as? String
		profileImage = aDecoder.decodeObject(forKey: "profile_image") as? String
		rating = aDecoder.decodeObject(forKey: "rating") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if bookingId != nil{
			aCoder.encode(bookingId, forKey: "booking_id")
		}
		if comment != nil{
			aCoder.encode(comment, forKey: "comment")
		}
		if createdAt != nil{
			aCoder.encode(createdAt, forKey: "created_at")
		}
		if dropoffLocation != nil{
			aCoder.encode(dropoffLocation, forKey: "dropoff_location")
		}
		if firstName != nil{
			aCoder.encode(firstName, forKey: "first_name")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if lastName != nil{
			aCoder.encode(lastName, forKey: "last_name")
		}
		if pickupLocation != nil{
			aCoder.encode(pickupLocation, forKey: "pickup_location")
		}
		if profileImage != nil{
			aCoder.encode(profileImage, forKey: "profile_image")
		}
		if rating != nil{
			aCoder.encode(rating, forKey: "rating")
		}

	}

}
