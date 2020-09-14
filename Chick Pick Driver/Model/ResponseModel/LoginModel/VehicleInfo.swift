//
//  VehicleInfo.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on July 23, 2019

import Foundation
import SwiftyJSON


class VehicleInfo : Codable {

    
    /*
     "car_back" : "assets\/images\/driver\/91\/193d361019a9ee4ddede7b9a18bb5dc0.jpeg",
     "id" : "251",
     "driver_id" : "91",
     "vehicle_type_manufacturer_name" : "Honda",
     "car_front" : "assets\/images\/driver\/91\/1bac0ba464e3431afa018f206cc1a2be.jpeg",
     "car_left" : "assets\/images\/driver\/91\/5f97c861e12faea112469b132a35b5ff.jpeg",
     "no_of_passenger" : "3",
     "year_of_manufacture" : "2016",
     "vehicle_type_model_id" : "10",
     "vehicle_type_name" : "Gold",
     "vehicle_type" : "2",
     "company_id" : "1",
     "plate_number" : "jgh79789jhj",
     "vehicle_type_model_name" : "Insight",
     "car_right" : "assets\/images\/driver\/91\/757ee6cb140df598c380ddc6991e820d.jpeg",
     "vehicle_type_manufacturer_id" : "1"
 
 */
    var carBack : String!
    var carFront : String!
    var carLeft : String!
    var carRight : String!
    var companyId : String!
    var driverId : String!
    var id : String!
    var noOfPassenger : String!
    var plateNumber : String!
//    var vehicleModel : String!
    var vehicleType : String!
    var vehicleTypeName : String!
    var yearOfManufacture : String!
    var vehicleTypeManufacturerName : String!
    var vehicleTypeManufacturerId : String!
    var vehicleTypeModelId : String!
    var vehicleTypeModelName : String!
    
    
    init() {
    }
    
	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        carBack = json["car_back"].stringValue
        carFront = json["car_front"].stringValue
        carLeft = json["car_left"].stringValue
        carRight = json["car_right"].stringValue
        companyId = json["company_id"].stringValue
        driverId = json["driver_id"].stringValue
        id = json["id"].stringValue
        noOfPassenger = json["no_of_passenger"].stringValue
        plateNumber = json["plate_number"].stringValue
//        vehicleModel = json["vehicle_model"].stringValue
        vehicleType = json["vehicle_type"].stringValue
        vehicleTypeName = json["vehicle_type_name"].stringValue
        yearOfManufacture = json["year_of_manufacture"].stringValue
        
        vehicleTypeManufacturerName = json["vehicle_type_manufacturer_name"].stringValue
        vehicleTypeManufacturerId = json["vehicle_type_model_id"].stringValue
        vehicleTypeModelId = json["vehicle_type_manufacturer_id"].stringValue
        vehicleTypeModelName = json["vehicle_type_model_name"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if carBack != nil{
        	dictionary["car_back"] = carBack
        }
        if carFront != nil{
        	dictionary["car_front"] = carFront
        }
        if carLeft != nil{
        	dictionary["car_left"] = carLeft
        }
        if carRight != nil{
        	dictionary["car_right"] = carRight
        }
        if companyId != nil{
        	dictionary["company_id"] = companyId
        }
        if driverId != nil{
        	dictionary["driver_id"] = driverId
        }
        if id != nil{
        	dictionary["id"] = id
        }
        if noOfPassenger != nil{
        	dictionary["no_of_passenger"] = noOfPassenger
        }
        if plateNumber != nil{
        	dictionary["plate_number"] = plateNumber
        }
        
//        if vehicleModel != nil{
//            dictionary["vehicle_model"] = vehicleModel
//        }
        if vehicleType != nil{
        	dictionary["vehicle_type"] = vehicleType
        }
        if vehicleTypeName != nil{
        	dictionary["vehicle_type_name"] = vehicleTypeName
        }
        if yearOfManufacture != nil{
        	dictionary["year_of_manufacture"] = yearOfManufacture
        }
        
        if vehicleTypeManufacturerName != nil{
            dictionary["vehicle_type_manufacturer_name"] = vehicleTypeManufacturerName
        }
        if vehicleTypeManufacturerId != nil{
            dictionary["vehicle_type_model_id"] = vehicleTypeManufacturerId
        }
        if vehicleTypeModelId != nil{
            dictionary["vehicle_type_manufacturer_id"] = vehicleTypeModelId
        }
        if vehicleTypeModelName != nil{
            dictionary["vehicle_type_model_name"] = vehicleTypeModelName
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		carBack = aDecoder.decodeObject(forKey: "car_back") as? String
		carFront = aDecoder.decodeObject(forKey: "car_front") as? String
		carLeft = aDecoder.decodeObject(forKey: "car_left") as? String
		carRight = aDecoder.decodeObject(forKey: "car_right") as? String
		companyId = aDecoder.decodeObject(forKey: "company_id") as? String
		driverId = aDecoder.decodeObject(forKey: "driver_id") as? String
		id = aDecoder.decodeObject(forKey: "id") as? String
		noOfPassenger = aDecoder.decodeObject(forKey: "no_of_passenger") as? String
		plateNumber = aDecoder.decodeObject(forKey: "plate_number") as? String
//        vehicleModel = aDecoder.decodeObject(forKey: "vehicle_model") as? String
		vehicleType = aDecoder.decodeObject(forKey: "vehicle_type") as? String
		vehicleTypeName = aDecoder.decodeObject(forKey: "vehicle_type_name") as? String
		yearOfManufacture = aDecoder.decodeObject(forKey: "year_of_manufacture") as? String
        
        vehicleTypeManufacturerName = aDecoder.decodeObject(forKey: "vehicle_type_manufacturer_name") as? String
        vehicleTypeManufacturerId = aDecoder.decodeObject(forKey: "vehicle_type_model_id") as? String
        vehicleTypeModelId = aDecoder.decodeObject(forKey: "vehicle_type_manufacturer_id") as? String
        vehicleTypeModelName = aDecoder.decodeObject(forKey: "vehicle_type_model_name") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if carBack != nil{
			aCoder.encode(carBack, forKey: "car_back")
		}
		if carFront != nil{
			aCoder.encode(carFront, forKey: "car_front")
		}
		if carLeft != nil{
			aCoder.encode(carLeft, forKey: "car_left")
		}
		if carRight != nil{
			aCoder.encode(carRight, forKey: "car_right")
		}
		if companyId != nil{
			aCoder.encode(companyId, forKey: "company_id")
		}
		if driverId != nil{
			aCoder.encode(driverId, forKey: "driver_id")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if noOfPassenger != nil{
			aCoder.encode(noOfPassenger, forKey: "no_of_passenger")
		}
		if plateNumber != nil{
			aCoder.encode(plateNumber, forKey: "plate_number")
		}
//        if vehicleModel != nil{
//            aCoder.encode(vehicleModel, forKey: "vehicle_model")
//        }
		if vehicleType != nil{
			aCoder.encode(vehicleType, forKey: "vehicle_type")
		}
		if vehicleTypeName != nil{
			aCoder.encode(vehicleTypeName, forKey: "vehicle_type_name")
		}
		if yearOfManufacture != nil{
			aCoder.encode(yearOfManufacture, forKey: "year_of_manufacture")
		}
        if vehicleTypeManufacturerName != nil{
            aCoder.encode(yearOfManufacture, forKey: "vehicle_type_manufacturer_name")
        }
        if vehicleTypeManufacturerId != nil{
            aCoder.encode(yearOfManufacture, forKey: "vehicle_type_model_id")
        }
        if vehicleTypeModelId != nil{
            aCoder.encode(yearOfManufacture, forKey: "vehicle_type_manufacturer_id")
        }
        if vehicleTypeModelName != nil{
            aCoder.encode(yearOfManufacture, forKey: "vehicle_type_model_name")
        }
	}

}
