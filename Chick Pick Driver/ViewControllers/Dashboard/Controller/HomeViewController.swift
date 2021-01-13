//
//  HomeViewController.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 29/04/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit
import SideMenuSwift
import CoreLocation
import GoogleMaps
import AVKit

class HomeViewController: UIViewController, ARCarMovementDelegate {
    
    
    
    // ----------------------------------------------------
    // MARK: - Outlets
    // ----------------------------------------------------
    
    @IBOutlet weak var containerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnTopHeader: UIButton!
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var ImgTripToDestination: UIImageView!
    
    @IBOutlet weak var offlineView: UIView!
    @IBOutlet weak var constantHeightOfOfflineView: NSLayoutConstraint! // 60
    @IBOutlet weak var progressRequest: UIProgressView!
    //    @IBOutlet weak var viewProgress: UIView!
    var mapView : GMSMapView!
    @IBOutlet weak var mapContainerView : UIView!
    
    @IBOutlet var bottomContentView: UIView!
    let progress = Progress(totalUnitCount: 10)
    let switchBtn = UISwitch(frame: CGRect(x: 0, y: 0, width: 40, height: 26))
    
    var LoginDetail : LoginModel = LoginModel()
    var addCardReqModel : AddCard = AddCard()
    var CardListReqModel : CardList = CardList()
    var driverData = DriverData.shared
//    var bookingData = BookingInfo()
    
    let carMovement = ARCarMovement()
    var driverMarker : GMSMarker!
    var destinationMarker : GMSMarker!
    var arrivedRoutePath: GMSPath?
    
    // ----------------------------------------------------
    // MARK: - Globle Declaration Methods
    // ----------------------------------------------------
    
    var audioPlayer:AVAudioPlayer!
    
    var presentType = DriverState.available
    var presentView = UIView()
    var index = Int()
    let locationManager = CLLocationManager()
    var tempView = UIView()
    var oldCoordinate : CLLocationCoordinate2D!
    var updateDriverLocationAtRegularInterval : Timer!
    
    
    enum setupGMSMarker {
        case from
        case to
    }
    
    // ----------------------------------------------------
    // MARK: - Base Methods
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGoogleMaps()
        
        isLocationEnable()
        
        progressRequest.isHidden = true
        carMovement.delegate = self
        setNavbar()
        
        tempView.frame = bottomContentView.bounds
        locationManager.delegate = self
        self.webserviceForCardList()
        self.webserviceForVehicleList()
        getFirstView(isDriverInfoUpdated: false)
        SideMenuController.preferences.basic.enableRubberEffectWhenPanning = false
        btnTopHeader.addTarget(self, action: #selector(hideBottomView(_:)), for: .touchUpInside)
        
        if Singleton.shared.isDriverOnline {
            SocketIOManager.shared.establishConnection()
        }
        
        if let BookingInfoData = Singleton.shared.bookingInfo {
            let status = BookingInfoData.status
            //            self.bookingData = BookingInfoData
            if status == "pending" {
                
            } else if status == "accepted" {
                if UserDefaults.standard.object(forKey: "isDriverArrived") as? Bool == true {
                    self.presentView = self.presentType.chooseTripMode(state: .arrived) // chooseTripMode
                    self.setDataAfterDriverArrived()
                } else {
                    self.presentView = self.presentType.chooseTripMode(state: .requestAccepted) // chooseTripMode
                    self.setDataAfterAcceptingRequest()
                }
                bottomContentView.customAddSubview(presentView)
                containerBottomConstraint.constant = 0
            } else if status == "traveling" {
                self.presentView = self.presentType.chooseTripMode(state: .inTrip) // chooseTripMode
//                self.setDataAfterAcceptingRequest()
                bottomContentView.customAddSubview(presentView)
                containerBottomConstraint.constant = 0
                self.driverData.driverState = .inTrip
                self.resetMap()
            } else if status == "completed" {
                
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerTopView.roundCorners([.topLeft, .topRight], radius: 12)
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 1
        shadowView.layer.masksToBounds = false
        mapView.frame = CGRect(x: 0, y: 0, width: self.mapContainerView.frame.width, height: self.mapContainerView.frame.height)
    }
    
    func setupGoogleMaps()
    {
        mapView = GMSMapView(frame: mapContainerView.bounds)
        mapView.settings.rotateGestures = false
        mapView.settings.tiltGestures = false
        mapView.isMyLocationEnabled = false
        mapView.settings.myLocationButton = false
        
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "styleMap", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        mapContainerView.addSubview(mapView)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        ImgTripToDestination.isHidden = Singleton.shared.tripToDestinationDataModel?.status == "1" ? false : true
        
        if presentType == .available {
            if let driverView = presentView as? DriverInfoView {
                driverView.setDataofDriver()
            }
            // TODO:- Commented by Bhumi Jani as the UI was not displaying proper after coming from another screen
//            getFirstView(isDriverInfoUpdated: false)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        SideMenuController.preferences.basic.enablePanGesture = true
    }
    
    func isLocationEnable() {
        if (CLLocationManager.authorizationStatus() == .denied) || CLLocationManager.authorizationStatus() == .restricted || CLLocationManager.authorizationStatus() == .notDetermined {
            let alert = UIAlertController(title: AppName.kAPPName, message: "Please enable location from settings", preferredStyle: .alert)
            let enable = UIAlertAction(title: "Enable", style: .default) { (temp) in
                
                if let url = URL.init(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(URL(string: "App-Prefs:root=Privacy&path=LOCATION") ?? url, options: [:], completionHandler: nil)
                }
            }
            alert.addAction(enable)
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    // ----------------------------------------------------
    // MARK: - Actions
    // ----------------------------------------------------
    
    @IBOutlet weak var viewLine: UIView!{
        didSet{
            viewLine.layer.cornerRadius = 2
            viewLine.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var containerTopView: UIView!{
        didSet {
            let directions: [UISwipeGestureRecognizer.Direction] = [.up, .down]
            for direction in directions {
                let gesture = UISwipeGestureRecognizer(target: self, action: #selector(panAction(_:)))
                gesture.direction = direction
                containerTopView.addGestureRecognizer(gesture)
            }
            containerTopView.isUserInteractionEnabled = true
            containerTopView.layoutIfNeeded()
        }
    }
    
    @IBAction func btnCurrentLocation(_ sender: UIButton)
    {
        UtilityClass.showAlert(message: "Feature is coming soon...", isCancelShow: false) {
            self.switchBtn.setOn(false, animated: true)
            return
        }
    }
    
    // ----------------------------------------------------
    // MARK: - Custom Methods
    // ----------------------------------------------------
    
    @objc func panAction(_ sender: UISwipeGestureRecognizer){
        switch sender.direction {
        case .down:
            hideBottomView(true)
        case .up:
            hideBottomView(false)
        default:
            break
        }
    }
    
    @objc func hideBottomView(_ hide: Bool){
        containerBottomConstraint.constant = hide ? -bottomContentView.bounds.height : 0
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [.curveEaseInOut, .allowUserInteraction, .beginFromCurrentState], animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func setNavbar(){
        setAttributedTitle(title: "Home")
        setMenuIcon()
        setRightSwitch()
    }
    
    // ----------------------------------------------------
    // MARK:- ARCarMovement Delegate
    // ----------------------------------------------------
    
    func arCarMovementMoved(_ marker: GMSMarker) {
        driverMarker = marker
        driverMarker.map = mapView
    }
    // ----------------------------------------------------------
    /// Switch Setup
    // ----------------------------------------------------------
    private func setRightSwitch() {
        
        self.navigationItem.rightBarButtonItems?.append(UIBarButtonItem(customView: switchBtn))
        switchBtn.tintColor = UIColor(custom: .theme)
        
        if Singleton.shared.isDriverOnline {
            SocketIOManager.shared.establishConnection()
            self.updateDriverLocation()
            //            self.driverData.driverState = .available // Added for frequent update
            self.switchBtn.setOn(true, animated: true)
            self.offlineView.isHidden = true
            if self.constantHeightOfOfflineView != nil {
                self.constantHeightOfOfflineView.constant = 0
            }
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        } else {
            SocketIOManager.shared.closeConnection()
            //            self.driverData.driverState = .tripComplete // Added for stop timer
            self.switchBtn.setOn(false, animated: true)
            if self.constantHeightOfOfflineView != nil {
                self.constantHeightOfOfflineView.constant = 60
            }
            self.offlineView.isHidden = false
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
        
        //        switchBtn.setOn(Singleton.shared.isDriverOnline, animated: false)
        switchBtn.addTarget(self, action: #selector(onlineSwitch(sender:)), for: .valueChanged)
    }
    // ----------------------------------------------------------
    
    @objc func onlineSwitch(sender: UISwitch)
    {
        if Singleton.shared.isClientBuild {
            UtilityClass.showAlert(message: "Feature is coming soon...", isCancelShow: false) {
                self.switchBtn.setOn(false, animated: true)
                return
            }
        } else {
            if Singleton.shared.bookingInfo?.status == nil || Singleton.shared.bookingInfo?.status == "" || Singleton.shared.bookingInfo?.status == "completed" {
                webserviceForChangeDuty()
            }else {
                sender.isOn = true
            }
        }
    }
    
    public func getFirstView(isDriverInfoUpdated: Bool) {
        
        //        presentView = presentType.fromNib()
        presentView = presentType.chooseTripMode(state: .available)
        changeView()
        bottomContentView.layoutIfNeeded()
        
        if isDriverInfoUpdated {
            if let driverView = presentView as? DriverInfoView {
                driverView.setDriverInfoAfterCompleteTrip()
            }
        }
    }
    
    public func getLastView() {
        //        DispatchQueue.main.async {
        self.presentView = self.presentType.chooseTripMode(state: .lastCompleteView)
        self.changeView()
        self.view.layoutIfNeeded()
        //        }
    }
    
    public func getRatingView() {
        //        DispatchQueue.main.async {
        self.presentView = self.presentType.chooseTripMode(state: .ratingView)
        self.changeView()
        self.containerTopView.layoutIfNeeded()
        self.view.layoutIfNeeded()
        //        }
    }
    
    func changeView() {
        bottomContentView.customAddSubview(presentView)
        containerBottomConstraint.constant = 0
//        bottomContentView.layoutIfNeeded()
//        self.containerTopView.layoutIfNeeded()
    }
    
    var count: Double = 0
    var timerProgressRequest: Timer?
    func setProgress() {
        //1
        progressRequest.isHidden = false
        progressRequest.progress = 0.0
        self.count = 0
        timerProgressRequest?.invalidate()
        playSound()
        
        // 2
        timerProgressRequest = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            
            // 3
            if self.count >= 1 {
                
//                self.timerProgressRequest?.invalidate()
//                self.count = 0
//                self.progressRequest.progress = 0.0
//                self.progressRequest.isHidden = true
                //                self.setConstraintOfHomeVc()
                //                self.setRequestRejectedView()
//                self.stopProgress()
                let bookingData = Singleton.shared.bookingInfo
                var param = [String: Any]()
                param["driver_id"] = Singleton.shared.driverId
                param["booking_id"] = bookingData?.id
                self.emitSocket_RejectRequest(param: param)
                
                return
            }
            // 4
            UIView.animate(withDuration: 1, delay: 0, options: .curveLinear, animations: {
                
                self.count += 0.033
                self.progressRequest.setProgress(Float(self.count), animated: true)
            }, completion: { (state) in
                
                print(state)
            })
        }
    }
    
    func stopProgress() {
        stopSound()
        self.timerProgressRequest?.invalidate()
        self.count = 0
        self.progressRequest.progress = 0.0
        self.progressRequest.isHidden = true
    }
    
    func playSound() {
          guard let url = Bundle.main.url(forResource: RingToneSound, withExtension: "mp3") else { return }
          
          do {
              try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
              try AVAudioSession.sharedInstance().setActive(true)
              
              /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
              audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
              
              /* iOS 10 and earlier require the following line:
               player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
              
              guard let player = audioPlayer else { return }
              player.numberOfLoops = -1
              player.play()
              
          } catch let error {
              print(error.localizedDescription)
          }
      }
      
      func stopSound() {
          
          guard let url = Bundle.main.url(forResource: RingToneSound, withExtension: "mp3") else { return }
          
          do {
              try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
              try AVAudioSession.sharedInstance().setActive(true)
              
              audioPlayer = try AVAudioPlayer(contentsOf: url)
              audioPlayer.stop()
          }
          catch let error {
              print(error.localizedDescription)
          }
      }
    
    func webserviceForCardList() {
        
        if(UserDefaults.standard.object(forKey: "userProfile") == nil) {
            return
        }
        do {
            LoginDetail = try UserDefaults.standard.get(objectType: LoginModel.self, forKey: "userProfile")!
        } catch {
            AlertMessage.showMessageForError("error")
            return
        }
        
        CardListReqModel.driver_id = LoginDetail.responseObject.id
        UserWebserviceSubclass.cardList(transferMoneyModel: CardListReqModel) { (json, status) in
            if status {
                let CardListDetails = AddCardModel.init(fromJson: json)
                do {
                    try UserDefaults.standard.set(object: CardListDetails, forKey: "cards")
                } catch {
                    Loader.hideHUD()
                    AlertMessage.showMessageForError("error")
                }
            }
            else {
                AlertMessage.showMessageForError("error")
            }
        }
    }
    
    func webserviceForVehicleList() {
        
        let param: [String: Any] = ["": ""]
        UserWebserviceSubclass.VehicleTypeListApi(strType: param) { (json, status) in
            if status  {
                print(json)
                let VehicleListDetails = VehicleListResultModel.init(fromJson: json)
                Singleton.shared.vehicleListData = VehicleListDetails
            }
            else {
                AlertMessage.showMessageForError(json["message"].stringValue)
            }
        }
    }
}


// ----------------------------------------------------
// MARK: - Location Methods
// ----------------------------------------------------

extension HomeViewController: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else {
            return
        }
        Singleton.shared.driverLocation = location
        
        print("DRIVER LOCATION UPDATE...")
        
        if UserDefaults.standard.object(forKey: "isUserLogin") != nil {
        
        if UserDefaults.standard.object(forKey: "isUserLogin") as? Bool == true {
            
            }
            
        }
        
        if(Singleton.shared.bookingInfo?.id == nil)
        {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: zoomLevel, bearing: 0, viewingAngle: 0)
            //  mapView
            updateDriverLocation()
        }
        else
        {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: zoomLevel, bearing: 0, viewingAngle: 0)
            var dictParam = [String:Any]()
            dictParam["driver_id"] = driverData.profile.responseObject.id ?? ""
            dictParam["customer_id"] = Singleton.shared.bookingInfo?.customerId ?? ""
            dictParam["lat"] = "\(location.coordinate.latitude)"
            dictParam["lng"] =  "\(location.coordinate.longitude)"
            dictParam["pickup_lat"] = Singleton.shared.bookingInfo?.pickupLat
            dictParam["pickup_lng"] = Singleton.shared.bookingInfo?.pickupLng
            
            if Singleton.shared.bookingInfo?.id != nil && Singleton.shared.bookingInfo?.id != "" {
                emitSocket_LiveTracking(param: dictParam)
              
                if self.arrivedRoutePath != nil {
                    if !GMSGeometryIsLocationOnPathTolerance(location.coordinate, self.arrivedRoutePath!, true, 200) {
                        resetMap()
//                        if Singleton.shared.bookingInfo?.status == "traveling" {
//                            self.routeDrawMethod(origin: "\(lat),\(lng)", destination: "\(self.booingInfo.dropoffLat ?? ""),\(self.booingInfo.dropoffLng ?? "")", isTripAccepted: true)
//                        } else {
//                            self.routeDrawMethod(origin: "\(lat),\(lng)", destination: "\(self.booingInfo.pickupLat ?? ""),\(self.booingInfo.pickupLng ?? "")", isTripAccepted: true)
//                        }
                    }
                }
            } else {
//                emitSocket_DriverLocation(param: dictParam)
                updateDriverLocation()
            }
        }
      
        if(driverMarker == nil)
        {
            self.driverMarker = GMSMarker(position: location.coordinate) // self.originCoordinate
            self.driverMarker.icon = UIImage(named:"CarOnMap")
            self.driverMarker.map = self.mapView
        }
        
        carMovement.arCarMovement(marker: driverMarker, oldCoordinate: oldCoordinate ?? location.coordinate , newCoordinate: location.coordinate, mapView: mapView)
        oldCoordinate = location.coordinate
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            break
        case .denied:
            //            mapView.isHidden = false
            break
        case .notDetermined:
            break
        case .authorizedAlways:
            manager.startUpdatingLocation()
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // print (error)
        if (error as? CLError)?.code == .denied {
            manager.stopUpdatingLocation()
            manager.stopMonitoringSignificantLocationChanges()
        }
    }
}

extension HomeViewController
{
    
    func drawRouteOnGoogleMap(origin: String!, destination: String!, waypoints: Array<String>!, travelMode: AnyObject!, fromMarker: GMSMarker?, toMarker: GMSMarker?, completionHandler: ((_ status:   String, _ success: Bool) -> Void)?)
    {
        arrivedRoutePath = nil
        
        let url = "origin=" + origin + "&destination=" + destination
        var directionsURLString = baseURLDirections + url + "&key=" + (UIApplication.shared.delegate as! AppDelegate).googlApiKey
        print ("directionsURLString: \(directionsURLString)")
        
        directionsURLString = directionsURLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let directionsURL = NSURL(string: directionsURLString)
        
        DispatchQueue.main.async( execute: { () -> Void in
            let directionsData = NSData(contentsOf: directionsURL! as URL)
            
            do{
                let dictionary: Dictionary<String, AnyObject> = try JSONSerialization.jsonObject(with: directionsData! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, AnyObject>
                
                let status = dictionary["status"] as! String
                
                if status == "OK" {
                    let selectedRoute = (dictionary["routes"] as! Array<Dictionary<String, AnyObject>>)[0]
                    let overviewPolyline = selectedRoute["overview_polyline"] as! Dictionary<String, AnyObject>
                    
                    let legs = selectedRoute["legs"] as! Array<Dictionary<String, AnyObject>>
                    
                    let startLocationDictionary = legs[0]["start_location"] as! Dictionary<String, AnyObject>
                    let originCoordinate = CLLocationCoordinate2DMake(startLocationDictionary["lat"] as! Double, startLocationDictionary["lng"] as! Double)
                    
                    let endLocationDictionary = legs[legs.count - 1]["end_location"] as! Dictionary<String, AnyObject>
                    let destinationCoordinate = CLLocationCoordinate2DMake(endLocationDictionary["lat"] as! Double, endLocationDictionary["lng"] as! Double)
                    
                    //                    let originAddress = legs[0]["start_address"] as! String
                    //                    let destinationAddress = legs[legs.count - 1]["end_address"] as! String
                    
                    //                    if fromMarker == self.driverMarker {
                    //                    }
                    // TODO:- commnented By Bhumi Jani from removing 1 extra pin for driver location
                    //                    self.setupMarkerOnGooglMap(markerType: .from, cordinate: originCoordinate)
                    self.drawPoyLineOnGoogleMap(poliLinePoints: overviewPolyline)
                    self.setupMarkerOnGooglMap(markerType: .to, cordinate: destinationCoordinate)
                }
            }
            catch {
                print(error.localizedDescription)
            }
        })
    }
    
    func drawPoyLineOnGoogleMap(poliLinePoints: [String:Any])
    {
        let route = poliLinePoints["points"] as! String
        let path: GMSPath = GMSPath(fromEncodedPath: route)!
        self.arrivedRoutePath = path
        let routePolyline = GMSPolyline(path: path)
        routePolyline.map = self.mapView
        routePolyline.strokeColor = UIColor.init(custom: .themePink) //UIColor.darkGray
        routePolyline.strokeWidth = 3.0
    }
    
    func setupMarkerOnGooglMap(markerType: setupGMSMarker, cordinate: CLLocationCoordinate2D)
    {
        let driverCordinate = Singleton.shared.driverLocation.coordinate
        
        let fromMarker = GMSMarker(position: cordinate)
        fromMarker.map = self.mapView
        //        self.mapView.camera(for: GMSCoordinateBounds(coordinate: driverCordinate.latitude, coordinate: driverCordinate.longitude), insets: .zero)
        self.mapView.animate(to: GMSCameraPosition(target: driverCordinate, zoom: zoomLevel))
        fromMarker.icon = UIImage.init(named: (markerType == setupGMSMarker.from) ? "CarOnMap" : "PinSmall")
        fromMarker.title = ""
    }
    
    func resetMap(){
        
//        mapView.animate(toLocation: Singleton.shared.driverLocation.coordinate)
        mapView.clear()
        switch driverData.driverState {
            
        case .requestAccepted:
            var originLocation = "\(Singleton.shared.driverLocation.coordinate.latitude),\(Singleton.shared.driverLocation.coordinate.longitude)"
            
            if(originLocation == "0.0,0.0")
            {
                originLocation = "\(self.locationManager.location?.coordinate.latitude ?? 0.0),\(self.locationManager.location?.coordinate.longitude ?? 0.0)"
            }
            let destinationLocation = "\(Singleton.shared.bookingInfo?.pickupLat ?? ""),\(Singleton.shared.bookingInfo?.pickupLng ?? "")"
            drawRouteOnGoogleMap(origin: originLocation, destination: destinationLocation, waypoints: nil, travelMode: nil, fromMarker: nil, toMarker: nil, completionHandler: nil)
        case .inTrip:
            var originLocation = "\(Singleton.shared.driverLocation.coordinate.latitude),\(Singleton.shared.driverLocation.coordinate.longitude)"
            if(originLocation == "0.0,0.0")
            {
                originLocation = "\(self.locationManager.location?.coordinate.latitude ?? 0.0),\(self.locationManager.location?.coordinate.longitude ?? 0.0)"
            }
            let destinationLocation = "\(Singleton.shared.bookingInfo?.dropoffLat ?? ""),\(Singleton.shared.bookingInfo?.dropoffLng ?? "")"
            drawRouteOnGoogleMap(origin: originLocation, destination: destinationLocation, waypoints: nil, travelMode: nil, fromMarker: nil, toMarker: nil, completionHandler: nil)
        default:
            break
            //                        carMovement.arCarMovement(marker: customMap.marker, oldCoordinate: customMap.previousLocation.coordinate, newCoordinate: customMap.presentLocation.coordinate, mapView: mapView, bearing: Float(2))
        }
    }
}


class NavigationController: UINavigationController, UINavigationBarDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        for viewController in viewControllers {
            // You need to do this because the push is not called if you created this controller as part of the storyboard
            addButton(viewController.navigationItem)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        addButton(viewController.navigationItem)
        super.pushViewController(viewController, animated: animated)
    }
    
    func addButton(_ item: UINavigationItem?) {
        
        //        let barButtonItem = UIBarButtonItem(image: UIImage(named: "iconEmergencyCall"), style: .plain, target: self, action: #selector(action))
        
        //        if item?.rightBarButtonItem == nil {
        //            item?.rightBarButtonItems = [barButtonItem]
        //        }
        //        else
        //        {
        //            item?.rightBarButtonItems = [self.navigationItem.rightBarButtonItem,barButtonItem] as? [UIBarButtonItem]
        //        }
        
        if item?.rightBarButtonItem == nil {
            item?.rightBarButtonItems = []
        }
        else
        {
            item?.rightBarButtonItems = [self.navigationItem.rightBarButtonItem] as? [UIBarButtonItem]
        }
    }
    
    @objc func action(_ button: UIBarButtonItem?) {
        dialNumber(number: "123456789")
    }
    
    func dialNumber(number : String) {
        
        if let url = URL(string: "tel://\(number)"),
            UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            // add error message here
        }
    }
}

