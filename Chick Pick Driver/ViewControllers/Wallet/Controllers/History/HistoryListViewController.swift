//
//  HistoryListViewController.swift
//  Peppea
//
//  Created by eww090 on 10/07/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit

class HistoryListViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate,delegateFilterWalletHistory
{
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var loginModelDetails : LoginModel = LoginModel()
    var walletHistoryRequest : WalletHistory = WalletHistory()
    var pageNo: Int = 0
    private let refreshControl = UIRefreshControl()
    var isRefresh = Bool()
    var objFilterOption: FilterOptions?
    var arrHistoryData = [walletHistoryListData]()
    {
        didSet
        {
            self.tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        webserviceForHistory()
        do{
            loginModelDetails = try UserDefaults.standard.get(objectType: LoginModel.self, forKey: "userProfile")!
        }
        catch
        {
            AlertMessage.showMessageForError("error")
            return
        }
        let profile = loginModelDetails.responseObject
        
        walletHistoryRequest.driver_id = profile!.id
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(self.refreshWeatherData(_:)), for: .valueChanged)
        refreshControl.tintColor =  UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        webserviceCallForHistoryList(index: 1)
        objFilterOption = FilterOptions()
        //        payment_type : cash,card,wallet,m_pesa
        
        objFilterOption?.arrPaymentOption.append(TypeOption(title: "cash", isSelect: false))
        objFilterOption?.arrPaymentOption.append(TypeOption(title: "card", isSelect: false))
        objFilterOption?.arrPaymentOption.append(TypeOption(title: "wallet", isSelect: false))
        objFilterOption?.arrPaymentOption.append(TypeOption(title: "m_pesa", isSelect: false))
        
        objFilterOption?.arrTransactionOption.append(TypeOption(title: "booking", isSelect: false))
        objFilterOption?.arrTransactionOption.append(TypeOption(title: "booking_commission", isSelect: false))
//        var obj = objFilterOption!.arrPaymentOption
//            .filter({$0.isSelect == true})
//            .compactMap({$0.title})
//            .joined(separator: ",")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let rightNavBarButton = UIBarButtonItem(image: UIImage(named: "iconFilter"), style: .plain, target: self, action: #selector(self.btnFilterClicked(_:)))
        
        self.navigationItem.rightBarButtonItem = rightNavBarButton
        self.setNavBarWithBack(Title: "History", IsNeedRightButton: false)
        self.navigationItem.rightBarButtonItem?.tintColor = .black
    }
    @objc private func refreshWeatherData(_ sender: Any) {
        // Fetch Weather Data
        isRefresh = true
        webserviceCallForHistoryList(index: 1)
    }
    
    
    @IBAction func btnFilterClicked(_ sender: Any)
    {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "HistoryFilterPopUpViewController") as! HistoryFilterPopUpViewController
        viewController.delegateWalletHistory = self
        viewController.obj = objFilterOption
        self.navigationController?.present(viewController, animated: true, completion: nil)
    }
    func delegateforFilteringWalletHistory(_ filterParam : [String : AnyObject])
    {
        if (filterParam["from_date"] as? String) != nil
        {
            walletHistoryRequest.from_date = filterParam["from_date"] as! String
        }
        if (filterParam["to_date"] as? String) != nil
        {
            walletHistoryRequest.to_date = filterParam["to_date"] as! String
        }
        if (filterParam["payment_type"] as? String) != nil
        {
            walletHistoryRequest.payment_type = filterParam["payment_type"] as! String
        }
        
        if (filterParam["transaction_type"] as? String) != nil
        {
            walletHistoryRequest.transaction_type = filterParam["transaction_type"] as! String
        }
        
        
        self.webserviceCallForHistoryList(index: 1)
        
    }
    func updateFilterWalletHistory(filter: FilterOptions) {
        if !filter.FromDate.isBlank {
            walletHistoryRequest.from_date = filter.FromDate
        }
        if !filter.toDate.isBlank {
            walletHistoryRequest.to_date = filter.toDate
        }
        if filter.arrPaymentOption.count != 0 {
            walletHistoryRequest.payment_type = filter.arrPaymentOption
                .filter({$0.isSelect == true})
                .compactMap({$0.title})
                .joined(separator: ",")
        }
        if filter.arrTransactionOption.count != 0 {
            walletHistoryRequest.transaction_type = filter.arrTransactionOption
                .filter({$0.isSelect == true})
                .compactMap({$0.title})
                .joined(separator: ",")
        }
//        if (filterParam["from_date"] as? String) != nil
//        {
//            walletHistoryRequest.from_date = filterParam["from_date"] as! String
//        }
//        if (filterParam["to_date"] as? String) != nil
//        {
//            walletHistoryRequest.to_date = filterParam["to_date"] as! String
//        }
//        if (filterParam["payment_type"] as? String) != nil
//        {
//            walletHistoryRequest.payment_type = filterParam["payment_type"] as! String
//        }
//        
//        if (filterParam["transaction_type"] as? String) != nil
//        {
//            walletHistoryRequest.transaction_type = filterParam["transaction_type"] as! String
//        }
        
        
        self.webserviceCallForHistoryList(index: 1)
    }
    // ----------------------------------------------------
    // MARK: - Webservice Methods
    // ----------------------------------------------------
    
    func webserviceCallForHistoryList(index: Int)
    {
        if(UserDefaults.standard.object(forKey: "userProfile") == nil)
        {
            return
        }
        
        
        walletHistoryRequest.page = "\(pageNo)"
        if(!isRefresh)
        {
            //            UtilityClass.showHUD(with: UIApplication.shared.keyWindow)
            Loader.showHUD(with: UIApplication.shared.keyWindow)
        }
        
        
        UserWebserviceSubclass.walletHistory(transferMoneyModel: walletHistoryRequest) { (json, status) in
            Loader.hideHUD()
            self.isRefresh = false
            if status
            {
                
                UserDefaults.standard.set(true, forKey: "isUserLogin")
                
                let WalletHistoryListDetails = WalletHistoryListModel.init(fromJson: json)
                //                do
                //                {
                self.arrHistoryData = WalletHistoryListDetails.walletHistorydata
                //                }
                //                catch
                //                {
                Loader.hideHUD()
                //                }
                self.tableView.reloadData()
                
                self.refreshControl.endRefreshing()
            }
            else{
                Loader.hideHUD()
                AlertMessage.showMessageForError(json["message"].stringValue)
            }
            
        }
    }
    
    var isDataLoading:Bool=false
    var didEndReached:Bool=false
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        print("scrollViewWillBeginDragging")
        isDataLoading = false
    }
    
    //Pagination
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        print("scrollViewDidEndDragging")
        if ((tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height) {
            //            if !isDataLoading{
            //                isDataLoading = true
            //                self.pageNo = self.pageNo + 1
            //                webserviceOfPastbookingpagination(index: self.pageNo)
            //            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == (self.arrHistoryData.count - 5) {
            if !isDataLoading{
                isDataLoading = true
                self.pageNo = self.pageNo + 1
                webserviceCallForHistoryList(index: self.pageNo)
            }
        }
    }
    
    // ----------------------------------------------------
    // MARK: - TableView Methods
    // ----------------------------------------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrHistoryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellMenu = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell") as! HistoryTableViewCell
        cellMenu.selectionStyle = .none
        let obj = arrHistoryData[indexPath.row]
        cellMenu.lblBookingID.text = obj.descriptionField
        cellMenu.lblAmount.text = obj.type + "Ksh" + obj.amount
        cellMenu.lblDateTime.text = obj.createdAt
        
        return cellMenu
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    
}

class FilterOptions {
    var FromDate = ""
    var toDate = ""
    var arrPaymentOption = [TypeOption]()
    var arrTransactionOption = [TypeOption]()
}
class TypeOption {
    var title: String?
    var isSelect: Bool?
    
    init(title: String, isSelect: Bool) {
        self.title = title
        self.isSelect = isSelect
    }
}
