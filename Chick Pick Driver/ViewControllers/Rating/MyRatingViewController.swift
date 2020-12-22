//
//  MyRatingViewController.swift
//  Chick Pick Driver
//
//  Created by Bhumi on 22/12/20.
//  Copyright © 2020 baps. All rights reserved.
//

import UIKit


class MyRatingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet var tblview: UITableView!
    var aryData = [Datum]()
    var labelNoData = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblview.dataSource = self
        self.tblview.delegate = self
        self.title = "My Ratings"
        
        self.tblview.tableFooterView = UIView()
        //        SideMenuController.preferences.SideMenuController.preferences.interaction.swipingEnabled = false
        
        
        labelNoData = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
//        self.labelNoData.text = "Loading..."
        labelNoData.textAlignment = .center
        self.view.addSubview(labelNoData)
        self.tblview.isHidden = true
        
        self.tblview.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        Loader.showHUD(with: UIApplication.shared.keyWindow)
        self.webserviceForMyFeedbackList()
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //-------------------------------------------------------------
    // MARK: - TableView Methods
    //-------------------------------------------------------------
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return aryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MyRatingViewCell.identifier, for: indexPath) as! MyRatingViewCell

        cell.lblCommentTitle.text = "Comments"
        cell.lblPickUpAddress.text = "First Description"
        cell.lblDropOffAddress.text = "Second Description"
        cell.selectionStyle = .none
        
        cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.width / 2
        cell.imgProfile.clipsToBounds = true
        cell.imgProfile.layer.borderColor = UIColor.lightGray.cgColor
        cell.imgProfile.layer.borderWidth = 1.0
        
        let data = aryData[indexPath.row]

        let strImage = NetworkEnvironment.imageBaseURL +  data.profileImage
        
        cell.imgProfile.sd_setImage(with: URL(string: strImage), placeholderImage: UIImage(named: "iconPlaceHolderUser")) { (image, error, catchType, url) in
            cell.imgProfile.layer.borderWidth = image?.isEqualToImage(UIImage(named: "iconPlaceHolderUser")!) ?? true ? 0 : 3
        }

        cell.lblName.text = data.firstName + " " + data.lastName
        cell.lblDropOffAddress.text = data.dropoffLocation
        cell.lblPickUpAddress.text = data.pickupLocation
        
        let strDate = data.createdAt
        let arrDate = strDate?.components(separatedBy: " ")
        cell.lblDateTime.text = arrDate?.first
        
        var intRating = Float()
        let str = data.rating
        if let n = NumberFormatter().number(from: str!)
        {
            intRating = Float(truncating: n)
        }
        cell.viewRating.rating = Double(intRating)
        cell.viewRating.tintColor = UIColor.init(custom: .themePink)
        
        let strComment  =  data.comment
        if strComment?.count == 0
        {
            cell.lblComments.text = "N/A"
        }
        else
        {
            cell.lblComments.text = strComment
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    func webserviceForMyFeedbackList()
    {
        let param = Singleton.shared.userProfile!.responseObject.id ?? ""
        UserWebserviceSubclass.ReviewListing(strURL: param) { (result, status) in
            Loader.hideHUD()
            if status
            {
                print(result)
                let model = ReviewListing(fromJson: result)
                self.aryData = model.data
                
                if(self.aryData.count == 0)
                {
                    self.labelNoData.text = "No data found"
                    self.tblview.isHidden = true
                }
                else
                {
                    self.labelNoData.removeFromSuperview()
                    self.tblview.isHidden = false
                }
                self.tblview.reloadData()
            }
            else {
                AlertMessage.showMessageForError(result["message"].stringValue)
            }
        }
    }
}


final class CustomView: UIView {
    private var shadowLayer: CAShapeLayer!
    @IBInspectable public var isRounded : Bool = false
    @IBInspectable public var Corner_Radius: CGFloat = 5.0
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .clear
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: isRounded ? (self.frame.size.height/2) : Corner_Radius).cgPath
            shadowLayer.fillColor = UIColor.white.cgColor
            shadowLayer.shadowColor = UIColor.black.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0, height: 0)
            shadowLayer.shadowOpacity = 0.12
            shadowLayer.shadowRadius = 3.0
            layer.insertSublayer(shadowLayer, at: 0)
            
            //layer.insertSublayer(shadowLayer, below: nil) // also works
        }
    }
}
