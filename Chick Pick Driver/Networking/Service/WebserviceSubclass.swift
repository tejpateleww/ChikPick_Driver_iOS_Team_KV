//
//  UserWebserviceSubclass.swift
//  Pappea Driver
//
//  Created by Mayur iMac on 08/07/19.
//  Copyright © 2019 baps. All rights reserved.
//

import Foundation
import UIKit

class UserWebserviceSubclass
{
    class func initApi( strURL : String  ,completion: @escaping CompletionResponse ) {
           WebService.shared.getMethod(url: URL.init(string: strURL)!, httpMethod: .get, completion: completion)
    }
    class func register( registerModel : RegistrationModel  ,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = registerModel.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .register, httpMethod: .post, parameters: params, completion: completion)
    }
    class func login( loginModel : loginModel  ,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = loginModel.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .login, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func transferMoney(transferMoneyModel : TransferMoneyModel, completion: @escaping CompletionResponse) {
        let params : [String:String] = transferMoneyModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .transferMoney, httpMethod: .post, parameters: params, completion: completion)
    }
    class func addCardInList(addCardModel : AddCard, completion: @escaping CompletionResponse) {
        let params : [String:String] = addCardModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .AddCard, httpMethod: .post, parameters: params, completion: completion)
    }
    class func updateAccount(transferMoneyModel : UpdateAccountData, completion: @escaping CompletionResponse) {
        let params : [String:String] = transferMoneyModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .updateAccount, httpMethod: .post, parameters: params, completion: completion)
    }
    class func updateEmailOrMobile(emailNumberModel : UpdateMailOrNumber, completion: @escaping CompletionResponse) {
        let params : [String:String] = emailNumberModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .updateNumberOrMail, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func updatePersonal(transferMoneyModel : UpdatePersonalInfo, image: UIImage, imageParamName: String, completion: @escaping CompletionResponse) {
        
        let params : [String: String] = transferMoneyModel.generatPostParams() as! [String:String]
        WebService.shared.postDataWithImage(api: .updateBasicInfo, parameter: params, image: image, imageParamName: imageParamName, completion: completion)
    }
    class func RemoveCardFromList(removeCardModel : RemoveCard, completion: @escaping CompletionResponse) {
        let params : [String:String] = removeCardModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .removeCard, httpMethod: .post, parameters: params, completion: completion)
    }
    class func updateDoucments(transferMoneyModel : RegistrationParameter, image: UIImage, imageParamName: String, completion: @escaping CompletionResponse) {
        
        let params : [String: String] = transferMoneyModel.generatPostParams() as! [String:String]
        WebService.shared.postDataWithImage(api: .update_docs, parameter: params, image: image, imageParamName: imageParamName, completion: completion)
    }
    
    class func updateVehicleInfo(transferMoneyModel : UpdateVehicleInfo, imageParamName: [String], completion: @escaping CompletionResponse) {
        
        let params : [String: String] = transferMoneyModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .updateVehicleInfo, httpMethod: .post, parameters: params, completion: completion)

//        WebService.shared.postDataWithArrayImages(api: .updateVehicleInfo, parameter: params, image: image, imageParamName: imageParamName, completion: completion)
        // postDataWithImage(api: .update_docs, parameter: params, image: image, imageParamName: imageParamName, completion: completion)
    }
    
    class func changeDuty(transferMoneyModel : ChangeDutyStatus, completion: @escaping CompletionResponse)
    {
        let params : [String:String] = transferMoneyModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .changeDuty, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func pastBookingHistory(strType : String  ,completion: @escaping CompletionResponse )
    {
//        WebService.shared.requestMethod(api: .pastBookingHistory, httpMethod: .get, parameters: strType, completion: completion)
        let strURLFinal = NetworkEnvironment.baseURL + ApiKey.pastBookingHistory.rawValue + strType
        WebService.shared.getMethod(url: URL.init(string: strURLFinal)!, httpMethod: .get, completion: completion)
    }
    
    class func upcomingBookingHistory(strURL : String  ,completion: @escaping CompletionResponse ) {
        let strURLFinal = NetworkEnvironment.baseURL + ApiKey.upcomingBookingHistory.rawValue + strURL
        WebService.shared.getMethod(url: URL.init(string: strURLFinal)!, httpMethod: .get, completion: completion)
    }
    
    class func pendingBookingHistory(strURL : String  ,completion: @escaping CompletionResponse ) {
        let strURLFinal = NetworkEnvironment.baseURL + ApiKey.PendingBookingHistory.rawValue + strURL
        WebService.shared.getMethod(url: URL.init(string: strURLFinal)!, httpMethod: .get, completion: completion)
    }
    
    class func paymentReceivedOrNot(strURL : String  ,completion: @escaping CompletionResponse ) {
        let strURLFinal = NetworkEnvironment.baseURL + ApiKey.PaymentReceivedOrNot.rawValue + strURL
        WebService.shared.getMethod(url: URL.init(string: strURLFinal)!, httpMethod: .get, completion: completion)
    }
    
    class func ReviewRatingToDriver( bookingRequestModel : ReviewRatingReqModel  ,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = bookingRequestModel.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .reviewRating, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func LogoutApi(strType : [String: Any]  ,completion: @escaping CompletionResponse ) {
        WebService.shared.requestMethod(api: .logout, httpMethod: .get, parameters: strType, completion: completion)
    }
    class func VehicleTypeListApi(strType : [String: Any]  ,completion: @escaping CompletionResponse ) {
        WebService.shared.requestMethod(api: .vehicleTypeList, httpMethod: .get, parameters: strType, completion: completion)
    }
    class func changePassword(transferMoneyModel: [String: Any], completion: @escaping CompletionResponse) {
        let params : [String:String] = transferMoneyModel as! [String:String]
        WebService.shared.requestMethod(api: .changePassword, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func forgotPassword(strType : [String: Any]  ,completion: @escaping CompletionResponse ) {
        WebService.shared.requestMethod(api: .forgotPassword, httpMethod: .post, parameters: strType, completion: completion)
//        WebService.shared.requestMethod(api: .forgotPassword, httpMethod: .get, parameters: strType, completion: completion)
    }
    
    
    class func vehicleTypeModelList(strType : [String: Any]  ,completion: @escaping CompletionResponse ) {
        WebService.shared.requestMethod(api: .vehicleTypeModelList, httpMethod: .get, parameters: strType, completion: completion)
    }
    
    class func companyList(strType : [String: Any]  ,completion: @escaping CompletionResponse ) {
        WebService.shared.requestMethod(api: .companyList, httpMethod: .get, parameters: strType, completion: completion)
    }
    
//    class func addCard(transferMoneyModel: AddCard, completion: @escaping CompletionResponse) {
//        let params : [String:String] = transferMoneyModel.generatPostParams() as! [String:String]
//        WebService.shared.requestMethod(api: .addCard, httpMethod: .post, parameters: params, completion: completion)
//    }
    
    class func removeCard(transferMoneyModel: RemoveCard, completion: @escaping CompletionResponse) {
        let params : [String:String] = transferMoneyModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .removeCard, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func cardList(transferMoneyModel: CardList, completion: @escaping CompletionResponse) {
        let params : [String:String] = transferMoneyModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .cardList, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func walletHistory(transferMoneyModel: WalletHistory, completion: @escaping CompletionResponse) {
        let params : [String:String] = transferMoneyModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .walletHistory, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func transferToBankService(transferMoneyModel: TransferToBank, completion: @escaping CompletionResponse) {
        let params : [String:String] = transferMoneyModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .transferMoneyToBank, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func topUpMoney(transferMoneyModel: AddMoney, completion: @escaping CompletionResponse) {
        let params : [String:String] = transferMoneyModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .addMoney, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func scanCodeDetail(QRCodeDetailsModel : QRCodeDetails, completion: @escaping CompletionResponse) {
        let params : [String:String] = QRCodeDetailsModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .QRCodeDetail, httpMethod: .post, parameters: params, completion: completion)
    }
    class func MobileNoDetailDetail(MobileNoDetailModel : MobileNoDetail, completion: @escaping CompletionResponse) {
        let params : [String:String] = MobileNoDetailModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .MobileNoDetail, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func CompleteTripService(MobileNoDetailModel : CompleteModel, completion: @escaping CompletionResponse) {
        let params : [String:String] = MobileNoDetailModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .completeTrip, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func CancelTripService(cancelTripDetailModel : CompleteModel, completion: @escaping CompletionResponse) {
        let params : [String:String] = cancelTripDetailModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .cancelTrip, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func CancellationCharges(strURL : String  ,completion: @escaping CompletionResponse ) {
        let strURLFinal = NetworkEnvironment.baseURL + ApiKey.cancellationCharges.rawValue + strURL
        WebService.shared.getMethod(url: URL.init(string: strURLFinal)!, httpMethod: .get, completion: completion)
    }
}
