//
//  WalletViewController.swift
//  Peppea
//
//  Created by EWW80 on 10/07/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit
import SideMenuSwift

class WalletViewController: BaseViewController, UIPickerViewDelegate, UIPickerViewDataSource
{
    @IBOutlet weak var iconSelectedPaymentMethod: UIImageView!
    @IBOutlet weak var lblCardNumber: UILabel!
    @IBOutlet weak var lblBankCardName: UILabel!
    var pickerView = UIPickerView()
    
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var txtSelectPaymentMethod: UITextField!
    
    var aryCards = [CardsList]()
    
    var CardID = ""
    var paymentType = String()
    var cardDetailModel : AddCardModel = AddCardModel()
    var addMoneyReqModel : AddMoney = AddMoney()
    var LoginDetail : LoginModel = LoginModel()
    
    
    @IBOutlet weak var lblTotalWalletBalance: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(UserDefaults.standard.object(forKey: "userProfile") == nil)
        {
            return
        }
        
        do {
            LoginDetail = try UserDefaults.standard.get(objectType: LoginModel.self, forKey: "userProfile")!
            self.lblTotalWalletBalance.text = Singleton.shared.walletBalance//LoginDetail.loginData.walletBalance
            cardDetailModel = try UserDefaults.standard.get(objectType: AddCardModel.self, forKey: "cards")!
            self.aryCards = cardDetailModel.cards
        }catch {
            AlertMessage.showMessageForError("error")
            return
        }
        
        pickerView.delegate = self
        
        self.setNavBarWithBack(Title: "Wallet", IsNeedRightButton: true)
        
        self.lblBankCardName.text = "Select Payment Method"
        self.lblCardNumber.isHidden = true
        iconSelectedPaymentMethod.image = UIImage.init(named: "")
//        setDummyData()
        SideMenuController.preferences.basic.enablePanGesture = false
        
        webserviceForWallet()
    }


    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.lblTotalWalletBalance.text = Singleton.shared.walletBalance//LoginDetail.loginData.walletBalance
    }


    @IBAction func btnSendMoneyTapped(_ sender: Any)
    {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SendMoneyViewController") as! SendMoneyViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    

    @IBAction func btnReceiveMoney(_ sender: Any)
    {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ReceiveMoneyViewController") as! ReceiveMoneyViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func btnTransferToBankTapped(_ sender: Any)
    {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "TransferToBankVC") as! TransferToBankVC
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    @IBAction func btnHistoryTapped(_ sender: Any)
    {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "HistoryListViewController") as! HistoryListViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    @IBAction func btnTopUpTapped(_ sender: Any)
    {
        if txtAmount.text!.isBlank {
           AlertMessage.showMessageForError("Please enter amount")
            return
        } else if CardID == "" {
            AlertMessage.showMessageForError("Please select card")
            return
        } else {
            webserviceTopUp()
        }
    }
    
    @IBAction func txtSelectPaymentMethod(_ sender: UITextField) {
        
        txtSelectPaymentMethod.inputView = pickerView
    }
    
    
    //-------------------------------------------------------------
    // MARK: - PickerView Methods
    //-------------------------------------------------------------
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return aryCards.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let data = aryCards[row]
        
        let myView = UIView(frame: CGRect(x:0, y:0, width: pickerView.bounds.width - 30, height: 60))
        
        let centerOfmyView = myView.frame.size.height / 4
        
        
        let myImageView = UIImageView(frame: CGRect(x:0, y:centerOfmyView, width:40, height:26))
        myImageView.contentMode = .scaleAspectFit
        
        var rowString = String()
        /*
         "id": "7",
         "card_no": "XoKZoqSXlWRkY21cWFyElw==",
         "formated_card_no": "xxxx xxxx xxxx 4242",
         "card_holder_name": "mayurH",
         "card_type": "visa",
         "exp_date_month": "02",
         "exp_date_year": "20"
         */
        
        switch row {
            
        case 0:
            rowString = data.formatedCardNo
            myImageView.image = UIImage(named: setCardIcon(str: data.cardType))
        case 1:
            rowString = data.formatedCardNo
            myImageView.image = UIImage(named: setCardIcon(str: data.cardType))
        case 2:
            rowString = data.formatedCardNo
            myImageView.image = UIImage(named: setCardIcon(str: data.cardType))
        case 3:
            rowString = data.formatedCardNo
            myImageView.image = UIImage(named: setCardIcon(str: data.cardType))
        case 4:
            rowString = data.formatedCardNo
            myImageView.image = UIImage(named: setCardIcon(str: data.cardType))
        case 5:
            rowString = data.formatedCardNo
            myImageView.image = UIImage(named: setCardIcon(str: data.cardType))
        case 6:
            rowString = data.formatedCardNo
            myImageView.image = UIImage(named: setCardIcon(str: data.cardType))
        case 7:
            rowString = data.formatedCardNo
            myImageView.image = UIImage(named: setCardIcon(str: data.cardType))
        case 8:
            rowString = data.formatedCardNo
            myImageView.image = UIImage(named: setCardIcon(str: data.cardType))
        case 9:
            rowString = data.formatedCardNo
            myImageView.image = UIImage(named: setCardIcon(str: data.cardType))
        case 10:
            rowString = data.formatedCardNo
            myImageView.image = UIImage(named: setCardIcon(str: data.cardType))
        default:
            rowString = "Error: too many rows"
            myImageView.image = nil
        }
        let myLabel = UILabel(frame: CGRect(x:60, y:0, width:pickerView.bounds.width - 90, height:60 ))
        //        myLabel.font = UIFont(name:some, font, size: 18)
        myLabel.text = rowString
        
        myView.addSubview(myLabel)
        myView.addSubview(myImageView)
        
        return myView
    }
    
    var isAddCardSelected = Bool()
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if aryCards.count != 0 {
            let data = aryCards[row]
            
            iconSelectedPaymentMethod.image = UIImage(named: setCardIcon(str: data.cardType)) //UIImage(named: setCardIcon(str: data["Type"] as! String))
            
            self.lblBankCardName.text = data.cardHolderName
            self.lblCardNumber.isHidden = false
            self.lblCardNumber.text = data.formatedCardNo
            self.CardID = data.id
            
            paymentType = "card"
        }
    }
    
}


extension WalletViewController {
    
    func webserviceForWallet() {
        
        let model = WalletHistory()
        model.driver_id = Singleton.shared.driverId
        
        UserWebserviceSubclass.walletHistory(transferMoneyModel: model) { (response, status) in
            
            if status {
                Singleton.shared.currentBalance = "\(response.dictionary?["wallet_balance"]?.stringValue ?? "0")"
                self.lblTotalWalletBalance.text = response.dictionary?["wallet_balance"]?.stringValue
            } else {
                
            }
        }
    }
    
    func webserviceTopUp() {
        
        addMoneyReqModel.card_id = self.CardID
        addMoneyReqModel.amount = self.txtAmount.text ?? ""
        addMoneyReqModel.driver_id = LoginDetail.responseObject.id
//        UtilityClass.showHUD(with: UIApplication.shared.keyWindow)
        
        Loader.showHUD(with: UIApplication.shared.keyWindow)
        UserWebserviceSubclass.topUpMoney(transferMoneyModel: addMoneyReqModel) { (json, status) in
            
            Loader.hideHUD()
            if status
            {
                self.lblTotalWalletBalance.text = json["wallet_balance"].stringValue
                Singleton.shared.walletBalance = json["wallet_balance"].stringValue
                AlertMessage.showMessageForSuccess(json["message"].stringValue)
                self.txtAmount.text = ""
            }
            else
            {
                AlertMessage.showMessageForError("error")
            }
        }
    }
    
}
