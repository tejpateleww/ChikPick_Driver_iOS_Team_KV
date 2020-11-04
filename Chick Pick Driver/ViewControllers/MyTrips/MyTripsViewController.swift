//
//  MyTripsViewController.swift
//  Pappea Driver
//
//  Created by EWW-iMac Old on 04/07/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit
import SwiftyJSON

class MyTripsViewController: BaseViewController {
    
    @IBOutlet weak var collectionTableView: HeaderTableViewController!
    var tripType = MyTrips.past
    var data = [(String, String)]()
    
    var pageNoPastBooking: Int = 1
    var pageNoPastUpcoming: Int = 1
    private let refreshControl = UIRefreshControl()
    var isRefresh = Bool()
    
    var isDataLoading:Bool=false
    var didEndReached:Bool=false
    
    var NeedToReload:Bool = false
    var PageLimit = 10
    var PageNumber = 1
    
    var pastBookingHistoryModelDetails = [PastBookingHistoryResponse]()
    {
        didSet
        {
            self.collectionTableView.tableView.reloadData()
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setCollectionTableView()
        //        data = tripType.getDescription()
        webserviceCallForGettingPastHistory(pageNo: 1)
        self.setNavBarWithBack(Title: "My Trips", IsNeedRightButton: false)
        
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            collectionTableView.tableView.refreshControl = refreshControl
        } else {
            collectionTableView.tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(self.refreshWeatherData(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor.lightGray // UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
    }
    
    @objc private func refreshWeatherData(_ sender: Any) {
        
        // Fetch Weather Data
        isRefresh = true
        self.LoadNewData()
    }
    
    private func setCollectionTableView(){
        collectionTableView.isSizeToFitCellNeeded = true
        collectionTableView.indicatorColor = .black
        collectionTableView.titles = MyTrips.titles
        collectionTableView.parentVC = self
        collectionTableView.textFont = UIFont.regular(ofSize: 15)
        collectionTableView.indicatorColor = .black
        collectionTableView.textColor = .black
        collectionTableView.registerNibs = [MyTripTableViewCell.identifier,
                                            MyTripDescriptionTableViewCell.identifier,
                                            FooterTableViewCell.identifier, NoDataFoundTblCell.identifier]
        collectionTableView.cellInset = UIEdgeInsets.zero
        collectionTableView.spacing = 0
        
        if self.tripType == .upcoming {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.collectionTableView.loadTheSection(ofNumber: 1)
            }
        }
        
        collectionTableView.didSelectItemAt = {
            indexpaths in
            if indexpaths.indexPath != indexpaths.previousIndexPath {
                self.tripType = MyTrips.allCases[indexpaths.indexPath.item]
                //                self.data = self.tripType.getDescription()
                self.pastBookingHistoryModelDetails = []
                self.selectedCell = -1
                self.LoadNewData()
                self.collectionTableView.tableView.removeAllSubviews()
                self.collectionTableView.tableView.reloadData()
            }
        }
    }
    
    func LoadMoreData() {
        selectedCell = -1
        self.PageNumber += 1
        if self.tripType.rawValue.lowercased() == "past"
        {
            self.webserviceCallForGettingPastHistory(pageNo: self.PageNumber)
        }
        else if self.tripType.rawValue.lowercased() == "upcoming"
        {
            self.webserviceForUpcommingBooking(pageNo: self.PageNumber)
        }
        else
        {
            self.webserviceForPendingBooking(pageNo: self.PageNumber)
        }
    }
    
    func LoadNewData() {
        self.PageNumber = 1
        self.pastBookingHistoryModelDetails.removeAll()
        self.collectionTableView.tableView.reloadData()
        if self.tripType.rawValue.lowercased() == "past"
        {
            self.webserviceCallForGettingPastHistory(pageNo: self.PageNumber)
        }
        else if self.tripType.rawValue.lowercased() == "upcoming"
        {
            self.webserviceForUpcommingBooking(pageNo: self.PageNumber)
        }
        else
        {
            self.webserviceForPendingBooking(pageNo: self.PageNumber)
        }
    }
    var selectedCell : Int = -1
}

extension MyTripsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //        return 10
        return (self.pastBookingHistoryModelDetails.count > 0) ? self.pastBookingHistoryModelDetails.count : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedCell == section {
            return 1 + self.data.count
        }
        return 1
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if self.pastBookingHistoryModelDetails.count > 0 {
            return tableView.dequeueReusableCell(withIdentifier: FooterTableViewCell.identifier)
        }
        return UIView()
    }
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.pastBookingHistoryModelDetails.count > 0 {
            return UITableView.automaticDimension
        }
        return 400.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedCell == indexPath.section {
            selectedCell = -1
           
            self.data = self.tripType.getDescription(pastBookingHistory: self.pastBookingHistoryModelDetails[indexPath.section])
            tableView.removeAllSubviews()
            tableView.reloadData()
            
            if self.data.count > 0 {
                tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            }
        }
        else{
            self.data = self.tripType.getDescription(pastBookingHistory: self.pastBookingHistoryModelDetails[indexPath.section])
            selectedCell = indexPath.section
            tableView.reloadData()
            if self.data.count > 0 {
                tableView.scrollToRow(at: IndexPath(row: 0, section: indexPath.section), at: .top, animated: false)
            }
        }
        if indexPath.section == 9{
            tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.pastBookingHistoryModelDetails.count > 0 {
            switch indexPath.row{
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: MyTripTableViewCell.identifier, for: indexPath) as! MyTripTableViewCell
                cell.setup()
                
                let dataResponseHeader = self.pastBookingHistoryModelDetails[indexPath.section]
                cell.lblName.text = "\(dataResponseHeader.customerFirstName ?? "") \(dataResponseHeader.customerLastName ?? "")"
                cell.lblDate.text = UtilityClass.convertTimeStampToFormat(unixtimeInterval: dataResponseHeader.bookingTime, dateFormat: "yyyy/MM/dd HH:mm")
                cell.lblBookin.text = "Booking Id : \(dataResponseHeader.id ?? "")"
                cell.lblPickup.text = dataResponseHeader.pickupLocation
                cell.lblDropoff.text = dataResponseHeader.dropoffLocation
                
                if self.tripType.rawValue.lowercased() == "past"
                {
                    cell.btnSendReceipt.isHidden = true
                    cell.btnRequestAccept.isHidden = true
                }
                else if self.tripType.rawValue.lowercased() == "upcoming"
                {
                    cell.btnSendReceipt.isHidden = true
                    cell.btnRequestAccept.isHidden = false
                    cell.btnRequestAccept.addTarget(self, action: #selector(acceptBookLaterRequestAction(_:)), for: .touchUpInside)
                    cell.btnRequestAccept.tag = indexPath.section
                }
                else
                {
                    cell.btnSendReceipt.isHidden = Singleton.shared.bookingInfo?.id == dataResponseHeader.id ? true : false
                    cell.btnRequestAccept.isHidden = true
                    cell.btnSendReceipt.addTarget(self, action: #selector(onTheWayAction(_:)), for: .touchUpInside)
                    cell.btnSendReceipt.tag = indexPath.section
                }
                
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: MyTripDescriptionTableViewCell.identifier, for: indexPath) as! MyTripDescriptionTableViewCell
                cell.lblTitle.text = data[indexPath.row - 1].0 + ":"
                cell.lblDescription.text = data[indexPath.row - 1].1
                //            let color = indexPath.row == data.count ? UIColor.orange : UIColor.white
                cell.lblDescription.textColor = .black
                cell.lblTitle.textColor = .black
                cell.setup()
                return cell
            }
        } else {
            let NoDataCell = tableView.dequeueReusableCell(withIdentifier: NoDataFoundTblCell.identifier) as! NoDataFoundTblCell
            return NoDataCell
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
       
        isDataLoading = false
    }
    
    //Pagination
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
       
        if ((collectionTableView.tableView.contentOffset.y + collectionTableView.tableView.frame.size.height) >= collectionTableView.tableView.contentSize.height) {
            if !isDataLoading && !didEndReached {
                isDataLoading = true
                self.LoadMoreData()
            }
        }
    }
    
    @objc func acceptBookLaterRequestAction(_ sender: UIButton) {
        let model = self.pastBookingHistoryModelDetails[sender.tag]
        var param = [String: Any]()
        param["driver_id"] = Singleton.shared.userProfile!.responseObject.id
        param["booking_id"] = model.id
        param["booking_type"] = model.bookingType
        
        if let vc = self.navigationController?.children.first as? HomeViewController {
            vc.emitSocket_AcceptRequest(param: param)
        }
    }
    
    @objc func onTheWayAction(_ sender: UIButton) {
         let model = self.pastBookingHistoryModelDetails[sender.tag]
        if Singleton.shared.isDriverOnline {
            
            if Singleton.shared.bookingInfo?.id == nil || Singleton.shared.bookingInfo?.id == "" || Singleton.shared.bookingInfo?.id == model.id {
                var param = [String: Any]()
                param["driver_id"] = Singleton.shared.userProfile!.responseObject.id
                param["booking_id"] = model.id
                
                if let vc = self.navigationController?.children.first as? HomeViewController {
                    vc.emitSocket_OnTheWayBookingRequest(param: param)
                }
            } else {
                AlertMessage.showMessageForError("Your trip is already started, please complete it first")
            }
        } else {
            AlertMessage.showMessageForError("Go online to start the trip")
        }
    }
    
    // MARK:- Webservice Call
    
    func webserviceCallForGettingPastHistory(pageNo: Int)
    {
        let param = "/" + Singleton.shared.userProfile!.responseObject.id + "/" + "\(pageNo)"
        
        if(!isRefresh)
        {
            Loader.showHUD(with: UIApplication.shared.keyWindow)
        }
        
        UserWebserviceSubclass.pastBookingHistory(strType: param) { (response, status) in
            Loader.hideHUD()
            self.isRefresh = false
            if status
            {
                print(response)
                self.setDataAfterWebServiceCall(response: response)
            }
            else
            {
                Loader.hideHUD()
                AlertMessage.showMessageForError(response["message"].stringValue)
            }
        }
    }
    
    func webserviceForUpcommingBooking(pageNo: Int) {
        
        if(!isRefresh)
        {
            Loader.showHUD(with: UIApplication.shared.keyWindow)
        }
        
        let param = Singleton.shared.userProfile!.responseObject.id + "/" + "\(pageNo)"
        UserWebserviceSubclass.upcomingBookingHistory(strURL: param) { (response, status) in
            //            print(response)
            Loader.hideHUD()
            self.isRefresh = false
            if(status) {
                self.setDataAfterWebServiceCall(response: response)
            }
            else {
                //                UtilityClass.hideHUD()
                AlertMessage.showMessageForError(response["message"].stringValue)
            }
        }
    }
    
    func webserviceForPendingBooking(pageNo: Int) {
        
        if(!isRefresh)
        {
            Loader.showHUD(with: UIApplication.shared.keyWindow)
        }
        
        let param = Singleton.shared.userProfile!.responseObject.id + "/" + "\(pageNo)"
        UserWebserviceSubclass.pendingBookingHistory(strURL: param) { (response, status) in
            //            print(response)
            Loader.hideHUD()
            self.isRefresh = false
            if(status) {
                self.setDataAfterWebServiceCall(response: response)
            }
            else {
                //                UtilityClass.hideHUD()
                AlertMessage.showMessageForError(response["message"].stringValue)
            }
        }
    }
    
    func setDataAfterWebServiceCall(response:JSON)
    {
        var arrResponseData = [PastBookingHistoryResponse]()
        
        if let arrayResponse = response.dictionary?["data"]?.array {
            arrResponseData = arrayResponse.map({ (item) -> PastBookingHistoryResponse in
                return PastBookingHistoryResponse.init(fromJson: item)
            })
        }
        
        if arrResponseData.count == 0 || arrResponseData.count < 10 {
            self.didEndReached = true
        } else {
            self.didEndReached = false
        }
        
        if self.PageNumber == 1 {
            self.pastBookingHistoryModelDetails = arrResponseData
        } else {
            self.pastBookingHistoryModelDetails.append(contentsOf: arrResponseData)
        }
        self.collectionTableView.tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
}
