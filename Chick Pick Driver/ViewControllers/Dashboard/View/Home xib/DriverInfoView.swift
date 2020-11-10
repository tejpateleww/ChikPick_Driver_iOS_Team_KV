//
//  DriverInfoView.swift
//  Pappea Driver
//
//  Created by EWW-iMac Old on 03/07/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import GooglePlaces

class DriverInfoView: UIView
{
    // ----------------------------------------------------
    // MARK: - Outlets
    // ----------------------------------------------------
    
    @IBOutlet weak var txtPickup: SkyFloatingLabelTextField!
    @IBOutlet weak var iconDriverProfilePic: UIImageView!
    
    @IBOutlet weak var lblDriverName: UILabel!
    @IBOutlet weak var lblkDriverRole: UILabel!
    @IBOutlet weak var iconDriverVehicle: UIImageView!
    
    @IBOutlet weak var lblTotalEarning: UILabel!
    @IBOutlet weak var lblTotleJobs: UILabel!
    @IBOutlet weak var lblDriverRatings: UILabel!
    @IBOutlet weak var lblVehicleNumber: UILabel!
    @IBOutlet weak var lblVehicleName: UILabel!
    
    
    @IBOutlet weak var viewRating: UIView!
    @IBOutlet weak var viewkJobs: UIView!
    @IBOutlet weak var viewEarnings: UIView!
    
    // ----------------------------------------------------
    // MARK: - Globle Declaration Methods
    // ----------------------------------------------------
    var placesClient = GMSPlacesClient()
    
    // ----------------------------------------------------
    // MARK: - Base Methods
    // ----------------------------------------------------
    override func draw(_ rect: CGRect) {
        setPickupField()
        self.iconDriverProfilePic.layer.cornerRadius = self.iconDriverProfilePic.frame.width / 2
        self.iconDriverProfilePic.layer.masksToBounds = true
        self.iconDriverVehicle.layer.cornerRadius = self.iconDriverVehicle.frame.width / 2
        self.iconDriverVehicle.layer.masksToBounds = true
        
        viewRating.layer.cornerRadius = 15
        viewRating.layer.borderColor = UIColor(custom: .themePink).cgColor
        viewRating.layer.borderWidth = 1
        
        viewkJobs.layer.cornerRadius = 15
        viewkJobs.layer.borderColor = UIColor(custom: .themePink).cgColor
        viewkJobs.layer.borderWidth = 1
        
        viewEarnings.layer.cornerRadius = 15
        viewEarnings.layer.borderColor = UIColor(custom: .themePink).cgColor
        viewEarnings.layer.borderWidth = 1
        
    }
    
    // ----------------------------------------------------
    // MARK: - Custom Methods
    // ----------------------------------------------------
    private func setPickupField()
    {
        let height = 16
        let padding = 6
        let view = UIView(frame: CGRect(x: 0, y: 0, width: height + padding, height: height))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: height, height: height))
        view.addSubview(imageView)
        imageView.tintColor = UIColor(custom: .themePink)
        imageView.image = UIImage(named: "Pickup Location")
        txtPickup.leftView = view
        txtPickup.leftViewMode = .always
    }
    
    func setDriverInfoAfterCompleteTrip() {
        
        self.lblTotleJobs.text = Singleton.shared.updatedDriverInfoAfterCompleteTrip["jobs"] as? String
        
        //            let totalEarning = Double(loginData?.bookingInfo?.totalDriverEarning ?? "0")?.rounded(toPlaces: 2)
        let totalEarning = Double(Singleton.shared.updatedDriverInfoAfterCompleteTrip["earning"] as! String)?.rounded(toPlaces: 2)
        
        self.lblTotalEarning.text = Currency + " " + "\(totalEarning ?? 0.0)"
        self.lblDriverRatings.text = Singleton.shared.updatedDriverInfoAfterCompleteTrip["rating"] as? String
    }
    
    func setDataofDriver()
    {
        do {
            //            let parameter = try UserDefaults.standard.get(objectType: RegistrationParameter.self, forKey: keyRegistrationParameter)
            let loginData = try UserDefaults.standard.get(objectType: LoginModel.self, forKey: "userProfile") // .set(object: loginModelDetails, forKey: "userProfile")
            let parameter = loginData?.responseObject
           
            self.lblDriverName.text = parameter!.firstName ?? "" + " " + parameter!.lastName
            self.lblkDriverRole.text = parameter!.driverRole ?? ""
            self.lblVehicleName.text = parameter!.vehicleInfo.first?.vehicleTypeName
            self.lblVehicleNumber.text = parameter!.vehicleInfo.first?.plateNumber
            
            self.lblTotleJobs.text = Singleton.shared.bookingInfoLoginModel?.totalTrips ?? "0"  // loginData?.bookingInfo?.totalTrips
            
            //            let totalEarning = Double(loginData?.bookingInfo?.totalDriverEarning ?? "0")?.rounded(toPlaces: 2)
            let totalEarning = Double(Singleton.shared.bookingInfoLoginModel?.totalDriverEarning ?? "0")?.rounded(toPlaces: 2)
            
            self.lblTotalEarning.text = Currency + " " + "\(totalEarning ?? 0.0)"
            self.lblDriverRatings.text = parameter?.rating
            
            let strImage = NetworkEnvironment.imageBaseURL + parameter!.profileImage
            
            iconDriverProfilePic.sd_setImage(with: URL(string: strImage), placeholderImage: UIImage(named: "iconPlaceHolderUser")) { (image, error, catchType, url) in
                self.iconDriverProfilePic.layer.borderWidth = image?.isEqualToImage(UIImage(named: "iconPlaceHolderUser")!) ?? true ? 0 : 2
            }
            
            //            self.iconDriverProfilePic.sd_setImage(with: URL(string: NetworkEnvironment.imageBaseURL + parameter!.profileImage), completed: nil)
            
            
            if (parameter!.vehicleInfo.first?.carFront) != nil
            {
                self.iconDriverVehicle.sd_setImage(with: URL(string: NetworkEnvironment.imageBaseURL + parameter!.vehicleInfo.first!.carFront), completed: nil)
            }
            
            self.getCurrentPlace()
        } catch{
            print(error.localizedDescription)
            return
        }
        
        //        if let image = self.imgProfile.image
        //        {
        //            if let data = image.pngData(){
        //                UserDefaults.standard.setValue(data, forKeyPath: keyProfileImage)
        //            }
        //
        //        }
    }
    
    func getCurrentPlace()
    {
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if error != nil {
                print ("Pick Place error: \(error?.localizedDescription ?? "Error")")
                return
            }
            
            //self.nameLabel = "No current place"
            self.txtPickup.text = ""
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if place != nil {
                    // self.nameLabel = place.name
                    // self.addressLabel = (place.formattedAddress?.components(separatedBy: ", ").joined(separator: "\n"))!
                }
            }
            
            if let placeLikelihoodList = placeLikelihoodList
            {
                for likelihood in placeLikelihoodList.likelihoods
                {
                    let place = likelihood.place
                    print(place.formattedAddress ?? "")
                    self.txtPickup.text = place.formattedAddress
                }
            }
        })
    }
}
