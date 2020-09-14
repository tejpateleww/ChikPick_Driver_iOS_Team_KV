//
//  DriverDoc.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on September 11, 2020

import Foundation
import SwiftyJSON


class DriverDoc : Codable {

    var dlvaExpDate : String!
    var dlvaLicenceImage : String!
    var driverId : String!
    var driverLicenceExpDate : String!
    var driverLicenceImage : String!
    var id : String!
    var isVerifyDlva : String!
    var isVerifyDriverLicence : String!
    var isVerifyMot : String!
    var isVerifyPcoBadge : String!
    var isVerifyPhv : String!
    var isVerifyPrivate : String!
    var isVerifyRoad : String!
    var isVerifyV5 : String!
    var isVerifyVehicleInsurance : String!
    var motCerti : String!
    var motExpDate : String!
    var pcoBadgeExpDate : String!
    var pcoBadgeImage : String!
    var phvExpDate : String!
    var phvLicenceImage : String!
    var privateExpDate : String!
    var privateInsuranceCerti : String!
    var roadExpDate : String!
    var roadTaxCerti : String!
    var v5ExpDate : String!
    var v5LogBook : String!
    var vehicleInsuranceCerti : String!
    var vehicleInsuranceExpDate : String!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        dlvaExpDate = json["dlva_exp_date"].stringValue
        dlvaLicenceImage = json["dlva_licence_image"].stringValue
        driverId = json["driver_id"].stringValue
        driverLicenceExpDate = json["driver_licence_exp_date"].stringValue
        driverLicenceImage = json["driver_licence_image"].stringValue
        id = json["id"].stringValue
        isVerifyDlva = json["is_verify_dlva"].stringValue
        isVerifyDriverLicence = json["is_verify_driver_licence"].stringValue
        isVerifyMot = json["is_verify_mot"].stringValue
        isVerifyPcoBadge = json["is_verify_pco_badge"].stringValue
        isVerifyPhv = json["is_verify_phv"].stringValue
        isVerifyPrivate = json["is_verify_private"].stringValue
        isVerifyRoad = json["is_verify_road"].stringValue
        isVerifyV5 = json["is_verify_v5"].stringValue
        isVerifyVehicleInsurance = json["is_verify_vehicle_insurance"].stringValue
        motCerti = json["mot_certi"].stringValue
        motExpDate = json["mot_exp_date"].stringValue
        pcoBadgeExpDate = json["pco_badge_exp_date"].stringValue
        pcoBadgeImage = json["pco_badge_image"].stringValue
        phvExpDate = json["phv_exp_date"].stringValue
        phvLicenceImage = json["phv_licence_image"].stringValue
        privateExpDate = json["private_exp_date"].stringValue
        privateInsuranceCerti = json["private_insurance_certi"].stringValue
        roadExpDate = json["road_exp_date"].stringValue
        roadTaxCerti = json["road_tax_certi"].stringValue
        v5ExpDate = json["v5_exp_date"].stringValue
        v5LogBook = json["v5_log_book"].stringValue
        vehicleInsuranceCerti = json["vehicle_insurance_certi"].stringValue
        vehicleInsuranceExpDate = json["vehicle_insurance_exp_date"].stringValue
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if dlvaExpDate != nil{
            dictionary["dlva_exp_date"] = dlvaExpDate
        }
        if dlvaLicenceImage != nil{
            dictionary["dlva_licence_image"] = dlvaLicenceImage
        }
        if driverId != nil{
            dictionary["driver_id"] = driverId
        }
        if driverLicenceExpDate != nil{
            dictionary["driver_licence_exp_date"] = driverLicenceExpDate
        }
        if driverLicenceImage != nil{
            dictionary["driver_licence_image"] = driverLicenceImage
        }
        if id != nil{
            dictionary["id"] = id
        }
        if isVerifyDlva != nil{
            dictionary["is_verify_dlva"] = isVerifyDlva
        }
        if isVerifyDriverLicence != nil{
            dictionary["is_verify_driver_licence"] = isVerifyDriverLicence
        }
        if isVerifyMot != nil{
            dictionary["is_verify_mot"] = isVerifyMot
        }
        if isVerifyPcoBadge != nil{
            dictionary["is_verify_pco_badge"] = isVerifyPcoBadge
        }
        if isVerifyPhv != nil{
            dictionary["is_verify_phv"] = isVerifyPhv
        }
        if isVerifyPrivate != nil{
            dictionary["is_verify_private"] = isVerifyPrivate
        }
        if isVerifyRoad != nil{
            dictionary["is_verify_road"] = isVerifyRoad
        }
        if isVerifyV5 != nil{
            dictionary["is_verify_v5"] = isVerifyV5
        }
        if isVerifyVehicleInsurance != nil{
            dictionary["is_verify_vehicle_insurance"] = isVerifyVehicleInsurance
        }
        if motCerti != nil{
            dictionary["mot_certi"] = motCerti
        }
        if motExpDate != nil{
            dictionary["mot_exp_date"] = motExpDate
        }
        if pcoBadgeExpDate != nil{
            dictionary["pco_badge_exp_date"] = pcoBadgeExpDate
        }
        if pcoBadgeImage != nil{
            dictionary["pco_badge_image"] = pcoBadgeImage
        }
        if phvExpDate != nil{
            dictionary["phv_exp_date"] = phvExpDate
        }
        if phvLicenceImage != nil{
            dictionary["phv_licence_image"] = phvLicenceImage
        }
        if privateExpDate != nil{
            dictionary["private_exp_date"] = privateExpDate
        }
        if privateInsuranceCerti != nil{
            dictionary["private_insurance_certi"] = privateInsuranceCerti
        }
        if roadExpDate != nil{
            dictionary["road_exp_date"] = roadExpDate
        }
        if roadTaxCerti != nil{
            dictionary["road_tax_certi"] = roadTaxCerti
        }
        if v5ExpDate != nil{
            dictionary["v5_exp_date"] = v5ExpDate
        }
        if v5LogBook != nil{
            dictionary["v5_log_book"] = v5LogBook
        }
        if vehicleInsuranceCerti != nil{
            dictionary["vehicle_insurance_certi"] = vehicleInsuranceCerti
        }
        if vehicleInsuranceExpDate != nil{
            dictionary["vehicle_insurance_exp_date"] = vehicleInsuranceExpDate
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
        dlvaExpDate = aDecoder.decodeObject(forKey: "dlva_exp_date") as? String
        dlvaLicenceImage = aDecoder.decodeObject(forKey: "dlva_licence_image") as? String
        driverId = aDecoder.decodeObject(forKey: "driver_id") as? String
        driverLicenceExpDate = aDecoder.decodeObject(forKey: "driver_licence_exp_date") as? String
        driverLicenceImage = aDecoder.decodeObject(forKey: "driver_licence_image") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        isVerifyDlva = aDecoder.decodeObject(forKey: "is_verify_dlva") as? String
        isVerifyDriverLicence = aDecoder.decodeObject(forKey: "is_verify_driver_licence") as? String
        isVerifyMot = aDecoder.decodeObject(forKey: "is_verify_mot") as? String
        isVerifyPcoBadge = aDecoder.decodeObject(forKey: "is_verify_pco_badge") as? String
        isVerifyPhv = aDecoder.decodeObject(forKey: "is_verify_phv") as? String
        isVerifyPrivate = aDecoder.decodeObject(forKey: "is_verify_private") as? String
        isVerifyRoad = aDecoder.decodeObject(forKey: "is_verify_road") as? String
        isVerifyV5 = aDecoder.decodeObject(forKey: "is_verify_v5") as? String
        isVerifyVehicleInsurance = aDecoder.decodeObject(forKey: "is_verify_vehicle_insurance") as? String
        motCerti = aDecoder.decodeObject(forKey: "mot_certi") as? String
        motExpDate = aDecoder.decodeObject(forKey: "mot_exp_date") as? String
        pcoBadgeExpDate = aDecoder.decodeObject(forKey: "pco_badge_exp_date") as? String
        pcoBadgeImage = aDecoder.decodeObject(forKey: "pco_badge_image") as? String
        phvExpDate = aDecoder.decodeObject(forKey: "phv_exp_date") as? String
        phvLicenceImage = aDecoder.decodeObject(forKey: "phv_licence_image") as? String
        privateExpDate = aDecoder.decodeObject(forKey: "private_exp_date") as? String
        privateInsuranceCerti = aDecoder.decodeObject(forKey: "private_insurance_certi") as? String
        roadExpDate = aDecoder.decodeObject(forKey: "road_exp_date") as? String
        roadTaxCerti = aDecoder.decodeObject(forKey: "road_tax_certi") as? String
        v5ExpDate = aDecoder.decodeObject(forKey: "v5_exp_date") as? String
        v5LogBook = aDecoder.decodeObject(forKey: "v5_log_book") as? String
        vehicleInsuranceCerti = aDecoder.decodeObject(forKey: "vehicle_insurance_certi") as? String
        vehicleInsuranceExpDate = aDecoder.decodeObject(forKey: "vehicle_insurance_exp_date") as? String
    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
    {
        if dlvaExpDate != nil{
            aCoder.encode(dlvaExpDate, forKey: "dlva_exp_date")
        }
        if dlvaLicenceImage != nil{
            aCoder.encode(dlvaLicenceImage, forKey: "dlva_licence_image")
        }
        if driverId != nil{
            aCoder.encode(driverId, forKey: "driver_id")
        }
        if driverLicenceExpDate != nil{
            aCoder.encode(driverLicenceExpDate, forKey: "driver_licence_exp_date")
        }
        if driverLicenceImage != nil{
            aCoder.encode(driverLicenceImage, forKey: "driver_licence_image")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if isVerifyDlva != nil{
            aCoder.encode(isVerifyDlva, forKey: "is_verify_dlva")
        }
        if isVerifyDriverLicence != nil{
            aCoder.encode(isVerifyDriverLicence, forKey: "is_verify_driver_licence")
        }
        if isVerifyMot != nil{
            aCoder.encode(isVerifyMot, forKey: "is_verify_mot")
        }
        if isVerifyPcoBadge != nil{
            aCoder.encode(isVerifyPcoBadge, forKey: "is_verify_pco_badge")
        }
        if isVerifyPhv != nil{
            aCoder.encode(isVerifyPhv, forKey: "is_verify_phv")
        }
        if isVerifyPrivate != nil{
            aCoder.encode(isVerifyPrivate, forKey: "is_verify_private")
        }
        if isVerifyRoad != nil{
            aCoder.encode(isVerifyRoad, forKey: "is_verify_road")
        }
        if isVerifyV5 != nil{
            aCoder.encode(isVerifyV5, forKey: "is_verify_v5")
        }
        if isVerifyVehicleInsurance != nil{
            aCoder.encode(isVerifyVehicleInsurance, forKey: "is_verify_vehicle_insurance")
        }
        if motCerti != nil{
            aCoder.encode(motCerti, forKey: "mot_certi")
        }
        if motExpDate != nil{
            aCoder.encode(motExpDate, forKey: "mot_exp_date")
        }
        if pcoBadgeExpDate != nil{
            aCoder.encode(pcoBadgeExpDate, forKey: "pco_badge_exp_date")
        }
        if pcoBadgeImage != nil{
            aCoder.encode(pcoBadgeImage, forKey: "pco_badge_image")
        }
        if phvExpDate != nil{
            aCoder.encode(phvExpDate, forKey: "phv_exp_date")
        }
        if phvLicenceImage != nil{
            aCoder.encode(phvLicenceImage, forKey: "phv_licence_image")
        }
        if privateExpDate != nil{
            aCoder.encode(privateExpDate, forKey: "private_exp_date")
        }
        if privateInsuranceCerti != nil{
            aCoder.encode(privateInsuranceCerti, forKey: "private_insurance_certi")
        }
        if roadExpDate != nil{
            aCoder.encode(roadExpDate, forKey: "road_exp_date")
        }
        if roadTaxCerti != nil{
            aCoder.encode(roadTaxCerti, forKey: "road_tax_certi")
        }
        if v5ExpDate != nil{
            aCoder.encode(v5ExpDate, forKey: "v5_exp_date")
        }
        if v5LogBook != nil{
            aCoder.encode(v5LogBook, forKey: "v5_log_book")
        }
        if vehicleInsuranceCerti != nil{
            aCoder.encode(vehicleInsuranceCerti, forKey: "vehicle_insurance_certi")
        }
        if vehicleInsuranceExpDate != nil{
            aCoder.encode(vehicleInsuranceExpDate, forKey: "vehicle_insurance_exp_date")
        }

    }

}
