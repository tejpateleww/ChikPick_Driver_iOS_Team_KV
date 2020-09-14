//
//  UpdateDocumentViewController.swift
//  Pappea Driver
//
//  Created by Apple on 11/07/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit

class UpdateDocumentViewController: UIViewController {

    // ----------------------------------------------------
    // MARK: - Outlets
    // ----------------------------------------------------
    @IBOutlet weak var viewDocuments: UIView!
    @IBOutlet weak var btnSave: UIButton!
    
    // ----------------------------------------------------
    // MARK: - Globle Declaration Methods
    // ----------------------------------------------------
    let myCustomView: LicenseInfoView = .fromNib()
    
    // ----------------------------------------------------
    // MARK: - Base Methods
    // ----------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Document"

//        view.isUserInteractionEnabled = false
//        btnSave.isHidden = true
        
        myCustomView.frame = viewDocuments.bounds
        btnSave.submitButtonLayout(isDark : true)
        viewDocuments.addSubview(myCustomView)
        myCustomView.setupTextField()
        
        myCustomView.fillAllFields()
        
//        self.view.bringSubviewToFront(viewDocuments)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        setupNavigationBarColor(navigationController)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (navigationController?.viewControllers.last is ProfileOptionsViewController) {
            let clubVC = navigationController?.viewControllers.last as? ProfileOptionsViewController
            clubVC?.isFromCheckinScreen = true
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if isMovingFromParent {
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.isTranslucent = true
        }
    }
    
    // ----------------------------------------------------
    // MARK: - Actions
    // ----------------------------------------------------
    @IBAction func btnSaveAction(_ sender: UIButton) {
        
        myCustomView.validationWithCompletion { (success) in
            if success {
                self.webserviceForUpdateProfile()
            }
        }
    }
    
    // ----------------------------------------------------
    // MARK: - Webservice
    // ----------------------------------------------------

    func webserviceForUpdateProfile() {
        do{
            guard let parameterArray = try UserDefaults.standard.get(objectType: RegistrationParameter.self, forKey: keyRegistrationParameter) else { return }
            
            let image = RegistrationImageParameter.shared.profileImage
            
            UserWebserviceSubclass.updateDoucments(transferMoneyModel: parameterArray, image: image, imageParamName: "image") { (response, status) in
                
                if status {
                    
                    let loginModelDetails = LoginModel.init(fromJson: response)
                    do {
                        try UserDefaults.standard.set(object: loginModelDetails, forKey: "userProfile")
                        UserDefaults.standard.synchronize()
                    }
                    catch {
                        print("error")
                    }
                    AlertMessage.showMessageForSuccess(response["message"].stringValue)
                    self.navigationController?.popViewController(animated: true)
                } else {
                    AlertMessage.showMessageForError(response["message"].arrayValue.first?.stringValue ?? response["message"].stringValue)
                }
            }
        }
        catch{
            print(error.localizedDescription)
            return
        }
    }
}
