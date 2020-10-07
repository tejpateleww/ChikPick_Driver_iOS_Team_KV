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

class HomeViewController: UIViewController,ARCarMovementDelegate {



    // ----------------------------------------------------
    // MARK: - Outlets
    // ----------------------------------------------------

    @IBOutlet weak var containerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnTopHeader: UIButton!
    
    @IBOutlet weak var shadowView: UIView!

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
    var bookingData = BookingInfo()
    let carMovement = ARCarMovement()
    var driverMarker : GMSMarker!
    var destinationMarker : GMSMarker!
    // ----------------------------------------------------
    // MARK: - Globle Declaration Methods
    // ----------------------------------------------------
    
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
        SocketIOManager.shared.establishConnection()

        progressRequest.isHidden = true
        carMovement.delegate = self
        setNavbar()

        tempView.frame = bottomContentView.bounds
        locationManager.delegate = self
        self.webserviceForCardList()
        self.webserviceForVehicleList()
        getFirstView()
        SideMenuController.preferences.basic.enableRubberEffectWhenPanning = false
        btnTopHeader.addTarget(self, action: #selector(hideBottomView(_:)), for: .touchUpInside)

        
        if let BookingInfoData = Singleton.shared.bookingInfo {
            let status = BookingInfoData.status
            
            if status == "pending" {
                
            } else if status == "accepted" {                
                self.presentView = self.presentType.chooseTripMode(state: .requestAccepted) // chooseTripMode
                bottomContentView.customAddSubview(presentView)
                containerBottomConstraint.constant = 0
            } else if status == "traveling" {
                self.presentView = self.presentType.chooseTripMode(state: .inTrip) // chooseTripMode
                bottomContentView.customAddSubview(presentView)
                containerBottomConstraint.constant = 0
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
//        mapView.frame = CGRect(x: 0, y: 0, width: self.mapContainerView.frame.width, height: self.mapContainerView.frame.height)

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
        if presentType == .available {
            getFirstView()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        SideMenuController.preferences.basic.enablePanGesture = true
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
            
            webserviceForChangeDuty()
        }

    }
    
    public func getFirstView() {
//        presentView = presentType.fromNib()
        presentView = presentType.chooseTripMode(state: .available)
        changeView()
    }
    
    public func getLastView() {
        //        presentView = presentType.fromNib()
        presentView = presentType.chooseTripMode(state: .lastCompleteView)
        changeView()
    }
    
    func changeView() {
        bottomContentView.customAddSubview(presentView)
        containerBottomConstraint.constant = 0
    }
    
    var count: Double = 0
    var timerProgressRequest: Timer?
    func setProgress() {
        //1
        progressRequest.isHidden = false
        progressRequest.progress = 0.0
        self.count = 0
        timerProgressRequest?.invalidate()

        // 2
        timerProgressRequest = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            
            // 3
            if self.count >= 1 {
                self.timerProgressRequest?.invalidate()
                self.count = 0
                self.progressRequest.progress = 0.0
                self.progressRequest.isHidden = true
//                self.setConstraintOfHomeVc()
//                self.setRequestRejectedView()
                
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
            })
        }
    }
    
    func stopProgress() {
        
        self.timerProgressRequest?.invalidate()
        self.count = 0
        self.progressRequest.progress = 0.0
        self.progressRequest.isHidden = true
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

        if(bookingData.id == nil)
        {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: zoomLevel, bearing: 0, viewingAngle: 0)
          //  mapView
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



        var directionsURLString = baseURLDirections + "origin=" + origin + "&destination=" + destination + "&key=" + (UIApplication.shared.delegate as! AppDelegate).googlApiKey
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

                    self.setupMarkerOnGooglMap(markerType: .from, cordinate: originCoordinate)
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
        let routePolyline = GMSPolyline(path: path)
        routePolyline.map = self.mapView
        routePolyline.strokeColor = UIColor.darkGray // UIColor.init(red: 44, green: 134, blue: 200, alpha: 1.0)
        routePolyline.strokeWidth = 3.0
    }

    func setupMarkerOnGooglMap(markerType: setupGMSMarker, cordinate: CLLocationCoordinate2D)
    {

        let driverCordinate = Singleton.shared.driverLocation.coordinate

        let fromMarker = GMSMarker(position: cordinate)
        fromMarker.map = self.mapView
        //        self.mapView.camera(for: GMSCoordinateBounds(coordinate: driverCordinate.latitude, coordinate: driverCordinate.longitude), insets: .zero)
        self.mapView.animate(to: GMSCameraPosition(target: driverCordinate, zoom: 12))
        fromMarker.icon = UIImage.init(named: (markerType == setupGMSMarker.from) ? "CarOnMap" : "PinSmall")
        fromMarker.title = ""
    }

    func resetMap(){

        mapView.animate(toLocation: Singleton.shared.driverLocation.coordinate)
        mapView.clear()
        switch driverData.driverState {

        case .requestAccepted:
            let originLocation = "\(Singleton.shared.driverLocation.coordinate.latitude),\(Singleton.shared.driverLocation.coordinate.longitude)"
            let destinationLocation = "\(bookingData.pickupLat ?? ""),\(bookingData.pickupLng ?? "")"
            drawRouteOnGoogleMap(origin: originLocation, destination: destinationLocation, waypoints: nil, travelMode: nil, fromMarker: nil, toMarker: nil, completionHandler: nil)
        case .inTrip:
            let originLocation = "\(Singleton.shared.driverLocation.coordinate.latitude),\(Singleton.shared.driverLocation.coordinate.longitude)"
            let destinationLocation = "\(bookingData.dropoffLat ?? ""),\(bookingData.dropoffLng ?? "")"
            drawRouteOnGoogleMap(origin: originLocation, destination: destinationLocation, waypoints: nil, travelMode: nil, fromMarker: nil, toMarker: nil, completionHandler: nil)
        default:
            break
            //            carMovement.arCarMovement(marker: customMap.marker, oldCoordinate: customMap.previousLocation.coordinate, newCoordinate: customMap.presentLocation.coordinate, mapView: mapView, bearing: Float(2))
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

