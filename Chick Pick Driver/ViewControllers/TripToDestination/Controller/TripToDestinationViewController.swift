//
//  TripToDestinationViewController.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 11/05/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import GooglePlaces

class TripToDestinationViewController: BaseViewController {
    
    @IBOutlet var btnSelectDestination: UISwitch!
    @IBOutlet var txtDestination: UITextField!
    @IBOutlet weak var lblDestinationTrip: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!
    
    var locationCoordinate = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSubmit.setTitle("Submit", for: .normal)
        
        btnSelectDestination.isOn = Singleton.shared.tripToDestinationDataModel?.status == "1" ? true : false
        txtDestination.text = Singleton.shared.tripToDestinationDataModel?.location
        let latitude = ((Singleton.shared.tripToDestinationDataModel?.lat ?? "0") as NSString).doubleValue
        let longitude = ((Singleton.shared.tripToDestinationDataModel?.lng ?? "0") as NSString).doubleValue
        locationCoordinate = CLLocationCoordinate2D(latitude: latitude , longitude: longitude)
        
        txtDestination.isHidden = btnSelectDestination.isOn ? false : true
    }
    
    @IBAction func valueChangedOfTripToDestination(_ sender: UISwitch) {
        
        txtDestination.isHidden = !sender.isOn
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        navType = .opaque
        title = "Trip To Destination"
    }
    
    @IBAction func txtLocation(_ sender: SkyFloatingLabelTextField)
    {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        //        acController.autocompleteBounds = bounds
        present(acController, animated: true, completion: nil)
    }
    
    
    @IBAction func SwitchAction(_ sender: UISwitch) {
        btnSelectDestination.isOn = sender.isOn
        
        if !btnSelectDestination.isOn {
            txtDestination.text = ""
            locationCoordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        }
    }
    
    
    @IBAction func btnSubmit(_ sender: Any) {
        if btnSelectDestination.isOn && txtDestination.text?.isBlank ?? false{
            AlertMessage.showMessageForError("Please enter destination location")
        } else {
            Loader.showHUD(with: UIApplication.shared.keyWindow)
            webserviceForTripToDestination(switchStatus: btnSelectDestination.isOn ? "1" : "0")
        }
    }
    
    // ----------------------------------------------------
    // MARK: - WEbservice Methods
    // ----------------------------------------------------
    func webserviceForTripToDestination(switchStatus: String) {
        
        let param: [String: Any] = ["driver_id": Singleton.shared.driverId, "Status": switchStatus, "Location": txtDestination.text ?? "", "lat": "\(locationCoordinate.latitude)", "lng": "\(locationCoordinate.longitude)"]
        
        UserWebserviceSubclass.tripToDestination(model: param) { (response, status) in
            Loader.hideHUD()
            if status {
                do
                {
                    let model = TripToDestinationResponseModel(fromJson: response)
                    Singleton.shared.tripToDestinationDataModel = model.data
                    try UserDefaults.standard.set(object: model.data, forKey: "TripToDestinationDataModel")
                }
                catch
                {
                    AlertMessage.showMessageForError("error")
                }
                
                AlertMessage.showMessageForSuccess(response["message"].stringValue)
                //                self.dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
            } else {
                self.btnSelectDestination.isOn = !self.btnSelectDestination.isOn
                AlertMessage.showMessageForError(response["message"].stringValue)
            }
        }
    }
}

extension TripToDestinationViewController : GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        txtDestination.text = "\(place.name ?? "") \(place.formattedAddress ?? "")"
        locationCoordinate = place.coordinate
        print("locationCoordinate : \(locationCoordinate)")
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        dismiss(animated: true, completion: nil)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}
