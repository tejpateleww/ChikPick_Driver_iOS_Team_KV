//
//  Data.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on July 22, 2019

import Foundation
import SwiftyJSON


class WalletResponseDataModel : Codable {

    var amount : String!
    var createdAt : String!
    var descriptionField : String!
    var id : String!
    var referenceId : String!
    var status : String!
    var transactionType : String!
    var type : String!
    var userId : String!
    var userType : String!

    init() {
    }
    
	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        amount = json["amount"].stringValue
        createdAt = json["created_at"].stringValue
        descriptionField = json["description"].stringValue
        id = json["id"].stringValue
        referenceId = json["reference_id"].stringValue
        status = json["status"].stringValue
        transactionType = json["transaction_type"].stringValue
        type = json["type"].stringValue
        userId = json["user_id"].stringValue
        userType = json["user_type"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if amount != nil{
        	dictionary["amount"] = amount
        }
        if createdAt != nil{
        	dictionary["created_at"] = createdAt
        }
        if descriptionField != nil{
        	dictionary["description"] = descriptionField
        }
        if id != nil{
        	dictionary["id"] = id
        }
        if referenceId != nil{
        	dictionary["reference_id"] = referenceId
        }
        if status != nil{
        	dictionary["status"] = status
        }
        if transactionType != nil{
        	dictionary["transaction_type"] = transactionType
        }
        if type != nil{
        	dictionary["type"] = type
        }
        if userId != nil{
        	dictionary["user_id"] = userId
        }
        if userType != nil{
        	dictionary["user_type"] = userType
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		amount = aDecoder.decodeObject(forKey: "amount") as? String
		createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
		descriptionField = aDecoder.decodeObject(forKey: "description") as? String
		id = aDecoder.decodeObject(forKey: "id") as? String
		referenceId = aDecoder.decodeObject(forKey: "reference_id") as? String
		status = aDecoder.decodeObject(forKey: "status") as? String
		transactionType = aDecoder.decodeObject(forKey: "transaction_type") as? String
		type = aDecoder.decodeObject(forKey: "type") as? String
		userId = aDecoder.decodeObject(forKey: "user_id") as? String
		userType = aDecoder.decodeObject(forKey: "user_type") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if amount != nil{
			aCoder.encode(amount, forKey: "amount")
		}
		if createdAt != nil{
			aCoder.encode(createdAt, forKey: "created_at")
		}
		if descriptionField != nil{
			aCoder.encode(descriptionField, forKey: "description")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if referenceId != nil{
			aCoder.encode(referenceId, forKey: "reference_id")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}
		if transactionType != nil{
			aCoder.encode(transactionType, forKey: "transaction_type")
		}
		if type != nil{
			aCoder.encode(type, forKey: "type")
		}
		if userId != nil{
			aCoder.encode(userId, forKey: "user_id")
		}
		if userType != nil{
			aCoder.encode(userType, forKey: "user_type")
		}

	}

}
