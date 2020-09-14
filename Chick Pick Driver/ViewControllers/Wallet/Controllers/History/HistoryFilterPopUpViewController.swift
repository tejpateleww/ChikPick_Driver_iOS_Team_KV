//
//  HistoryFilterPopUpViewController.swift
//  Peppea
//
//  Created by eww090 on 12/07/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

protocol delegateFilterWalletHistory
{
//    func delegateforFilteringWalletHistory(_ filterParam : [String : AnyObject])
    func updateFilterWalletHistory(filter: FilterOptions)
}

class HistoryFilterPopUpViewController: BaseViewController,UITextFieldDelegate
{

    
    @IBOutlet weak var viewPopup: UIView!
    var delegateWalletHistory: delegateFilterWalletHistory!
    @IBOutlet weak var txtFromDate: SkyFloatingLabelTextField!
     @IBOutlet weak var txtToDate: SkyFloatingLabelTextField!
    var strSelectedFromDate = String()
    var strSelectedTODate = String()
    
    var FromDate = Date()
    var TODate = Date()
    
    var arrSelectedPaymentType = [String]()
    var arrSelectedTranscationType = [String]()
    
    
    let datePickerViewFromDate:UIDatePicker = UIDatePicker()
    let datePickerViewToDate:UIDatePicker = UIDatePicker()
    
    
    @IBOutlet weak var btnCAsh: UIButton!
    @IBOutlet weak var btnWallet: UIButton!
    @IBOutlet weak var btnCard: UIButton!
    @IBOutlet weak var btnMPesa: UIButton!
    
    @IBOutlet weak var btnMyTrips: UIButton!
    @IBOutlet weak var btnCommission: UIButton!
    
    @IBOutlet weak var iconCAsh: UIImageView!
    @IBOutlet weak var iconWallet: UIImageView!
    @IBOutlet weak var iconCard: UIImageView!
    @IBOutlet weak var iconMPesa: UIImageView!
    
    @IBOutlet weak var iconMyTrips: UIImageView!
    @IBOutlet weak var iconCommission: UIImageView!
    
    var obj: FilterOptions?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewPopup.roundCorners([.topRight , .topLeft], radius: 10)
        self.setData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
    }
    
    func setData() {
      self.txtFromDate.text =  obj?.FromDate
      self.txtToDate.text = obj?.toDate
    
        let isCashSelected = obj?.arrPaymentOption[0].isSelect
        self.iconCAsh.image = UIImage.init(named: isCashSelected! ? "iconCheckboxSelected" : "iconCheckboxUnselected")
        btnCAsh.isSelected = isCashSelected!
        
        if let isWalletSelected = obj?.arrPaymentOption[1].isSelect {
            self.iconWallet.image = UIImage.init(named: isWalletSelected ? "iconCheckboxSelected" : "iconCheckboxUnselected")
            btnWallet.isSelected = isWalletSelected
        }
       
        if let isCardSelected = obj?.arrPaymentOption[2].isSelect {
            btnCard.isSelected = isCardSelected
            self.iconCard.image = UIImage.init(named: isCardSelected ? "iconCheckboxSelected" : "iconCheckboxUnselected")
        }
        
        if let isMpesaClick = obj?.arrPaymentOption[3].isSelect {
            btnMPesa.isSelected = isMpesaClick
            self.iconMPesa.image = UIImage.init(named: isMpesaClick ? "iconCheckboxSelected" : "iconCheckboxUnselected")
        }
        
        if let isMyTrips = obj?.arrTransactionOption[0].isSelect {
            self.iconMyTrips.image = UIImage.init(named: isMyTrips ? "iconCheckboxSelected" : "iconCheckboxUnselected")
            btnMyTrips.isSelected = isMyTrips
        }
        if let isCommision = obj?.arrTransactionOption[1].isSelect {
            self.iconCommission.image = UIImage.init(named: isCommision ? "iconCheckboxSelected" : "iconCheckboxUnselected")
            btnCommission.isSelected = isCommision
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        
        let fromDate = self.txtFromDate.text
        let toDate = self.txtToDate.text
        
        
        if textField == txtToDate
        {
            //            self.lblToDateTitle.isHidden = false
            if fromDate?.count != 0 {
                self.datePickerViewToDate.minimumDate = FromDate
            }
        }
        if textField == txtFromDate
        {
            if toDate?.count != 0
            {
                self.datePickerViewFromDate.maximumDate = TODate
            }
            
        }
        
    }
    
    @IBAction func txtDateFrom(_ sender: SkyFloatingLabelTextField) {
        
        datePickerViewFromDate.datePickerMode = UIDatePicker.Mode.date
        datePickerViewFromDate.maximumDate = Date()
        sender.inputView = datePickerViewFromDate
        datePickerViewFromDate.addTarget(self, action: #selector(self.pickupdateMethodFromDate(_:)), for: UIControl.Event.valueChanged)
    }
    
    @IBAction func txtDateTO(_ sender: SkyFloatingLabelTextField) {
        
        //        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerViewToDate.datePickerMode = UIDatePicker.Mode.date
        datePickerViewToDate.maximumDate = Date()
        sender.inputView = datePickerViewToDate
        datePickerViewToDate.addTarget(self, action: #selector(self.pickupdateMethodTodate(_:)), for: UIControl.Event.valueChanged)
    }
    
    
    @objc func pickupdateMethodFromDate(_ sender: UIDatePicker)
    {
        let dateFormaterView = DateFormatter()
        dateFormaterView.dateFormat = "yyyy-MM-dd"
        txtFromDate.text = dateFormaterView.string(from: sender.date)
        strSelectedFromDate = txtFromDate.text!
        FromDate = sender.date
    }
    
    @objc func pickupdateMethodTodate(_ sender: UIDatePicker)
    {
        let dateFormaterView = DateFormatter()
        dateFormaterView.dateFormat = "yyyy-MM-dd"
        txtToDate.text = dateFormaterView.string(from: sender.date)
        strSelectedTODate = txtToDate.text!
        TODate = sender.date
    }
    
    
    @IBAction func bnOKClikced(_ sender: Any)
    {
        //
        
        var dictParam = [String : AnyObject]()
        
        
        if self.txtFromDate.text?.count != 0
        {
            dictParam["from_date"] = (self.txtFromDate.text ?? "") as AnyObject
            obj?.FromDate = self.txtFromDate.text ?? ""
        }
        if self.txtToDate.text?.count != 0
        {
            dictParam["to_date"] = (self.txtToDate.text ?? "") as AnyObject
            obj?.toDate = self.txtToDate.text ?? ""
        }
        obj?.arrPaymentOption[0].isSelect = btnCAsh.isSelected
        obj?.arrPaymentOption[1].isSelect = btnWallet.isSelected
        obj?.arrPaymentOption[2].isSelect = btnCard.isSelected
        obj?.arrPaymentOption[3].isSelect = btnMPesa.isSelected
        
        obj?.arrTransactionOption[0].isSelect = btnMyTrips.isSelected
        obj?.arrTransactionOption[1].isSelect = btnCommission.isSelected
        
//        if let isMyTrips = obj?.arrTransactionOption[0].isSelect {
//            self.iconMyTrips.image = UIImage.init(named: isMyTrips ? "iconCheckboxSelected" : "iconCheckboxUnselected")
//            btnMyTrips.isSelected = isMyTrips
//        }
//        if let isCommision = obj?.arrTransactionOption[1].isSelect {
//            self.iconCommission.image = UIImage.init(named: isCommision ? "iconCheckboxSelected" : "iconCheckboxUnselected")
//            btnCommission.isSelected = isCommision
//        }
        /*
        if self.arrSelectedPaymentType.count != 0
        {
            print(self.arrSelectedPaymentType)
            let string = self.arrSelectedPaymentType.map { String($0) }.joined(separator: ", ")
            print("Payment: \(string)")
            dictParam["payment_type"] = string as AnyObject
        }
        if self.arrSelectedTranscationType.count != 0
        {
            print(self.arrSelectedTranscationType)
            let string = self.arrSelectedTranscationType.map { String($0) }.joined(separator: ", ")
            print("Transcation: \(string)")
            dictParam["transaction_type"] = string as AnyObject
        }
        
        */
        
//        self.delegateWalletHistory.delegateforFilteringWalletHistory(dictParam)

        self.delegateWalletHistory.updateFilterWalletHistory(filter: obj!)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnCashClicked(_ sender: Any)
    {
        if !btnCAsh.isSelected
        {
            self.iconCAsh.image = UIImage.init(named: "iconCheckboxSelected")
            btnCAsh.isSelected = true
            
//            obj?.arrPaymentOption[0].isSelect = true
            self.arrSelectedPaymentType.append("cash")
        }
        else
        {
            btnCAsh.isSelected = false
            self.iconCAsh.image = UIImage.init(named: "iconCheckboxUnselected")
            let temp = self.arrSelectedPaymentType.filter({$0 != "cash"})
            self.arrSelectedPaymentType.removeAll()
            self.arrSelectedPaymentType = temp
            
//            obj?.arrPaymentOption[0].isSelect = false
        }
    }
    @IBAction func btnWalletClicked(_ sender: Any)
    {
        if !btnWallet.isSelected
        {
            self.iconWallet.image = UIImage.init(named: "iconCheckboxSelected")
            btnWallet.isSelected = true
            self.arrSelectedPaymentType.append("wallet")
//            obj?.arrPaymentOption[1].isSelect = true
        }
        else
        {
            btnWallet.isSelected = false
            self.iconWallet.image = UIImage.init(named: "iconCheckboxUnselected")
            let temp = self.arrSelectedPaymentType.filter({$0 != "wallet"})
            self.arrSelectedPaymentType.removeAll()
            self.arrSelectedPaymentType = temp
//             obj?.arrPaymentOption[1].isSelect = false
            
        }
    }
    @IBAction func btnCardClicked(_ sender: Any)
    {
        if !btnCard.isSelected
        {
            btnCard.isSelected = true
            self.iconCard.image = UIImage.init(named: "iconCheckboxSelected")
            self.arrSelectedPaymentType.append("card")
//            obj?.arrPaymentOption[2].isSelect = true
        }
        else
        {
            btnCard.isSelected = false
            self.iconCard.image = UIImage.init(named: "iconCheckboxUnselected")
            let temp = self.arrSelectedPaymentType.filter({$0 != "card"})
            
            self.arrSelectedPaymentType.removeAll()
            self.arrSelectedPaymentType = temp
            
            print(self.arrSelectedPaymentType)
//            obj?.arrPaymentOption[2].isSelect = false

        }
        
    }
    @IBAction func btnMPesaClicked(_ sender: Any)
    {
        if !btnMPesa.isSelected
        {
            btnMPesa.isSelected = true
            self.iconMPesa.image = UIImage.init(named: "iconCheckboxSelected")
            self.arrSelectedPaymentType.append("m_pesa")
//            obj?.arrPaymentOption[3].isSelect = true
            
        }
        else
        {
            btnMPesa.isSelected = false
            self.iconMPesa.image = UIImage.init(named: "iconCheckboxUnselected")
            
            let temp = self.arrSelectedPaymentType.filter({$0 != "m_pesa"})
            
            self.arrSelectedPaymentType.removeAll()
            self.arrSelectedPaymentType = temp
            
            print(self.arrSelectedPaymentType)
//            obj?.arrPaymentOption[3].isSelect = false
        }
    }
    @IBAction func btnMyTripsClicked(_ sender: Any)
    {
        if !btnMyTrips.isSelected
        {
            self.iconMyTrips.image = UIImage.init(named: "iconCheckboxSelected")
            btnMyTrips.isSelected = true
            self.arrSelectedTranscationType.append("MyTrips")
//            obj?.arrTransactionOption[0].isSelect = true
        }
        else
        {
            btnMyTrips.isSelected = false
            self.iconMyTrips.image = UIImage.init(named: "iconCheckboxUnselected")
            let temp = self.arrSelectedTranscationType.filter({$0 != "MyTrips"})
            self.arrSelectedTranscationType.removeAll()
            self.arrSelectedTranscationType = temp
//            obj?.arrTransactionOption[0].isSelect = false
        }
    }
    @IBAction func btnCommissionClicked(_ sender: Any)
    {
        if !btnCommission.isSelected {
            self.iconCommission.image = UIImage.init(named: "iconCheckboxSelected")
            btnCommission.isSelected = true
            self.arrSelectedTranscationType.append("Commission")
//            obj?.arrTransactionOption[1].isSelect = true
        }else {
            btnCommission.isSelected = false
            self.iconCommission.image = UIImage.init(named: "iconCheckboxUnselected")
            let temp = self.arrSelectedTranscationType.filter({$0 != "Commission"})
            self.arrSelectedTranscationType.removeAll()
            self.arrSelectedTranscationType = temp
//            obj?.arrTransactionOption[1].isSelect = false
        }
    }
    
    
    @IBAction func btnOuterClicked(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
}
