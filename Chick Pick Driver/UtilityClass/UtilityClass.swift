//
//  UtilityClass.swift
//  Pappea Driver
//
//  Created by Apple on 19/07/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit

class UtilityClass: NSObject {

    typealias alertCompletion = (() -> Void)?
    
    class func showAlert(title: String? = AppName.kAPPName, message: String, isCancelShow: Bool = false, completion: alertCompletion = nil) {
       
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            if completion != nil {
                completion!()
            }
        }
//        ok.setValue(UIColor.blue, forKey: "titleTextColor")
        alert.addAction(ok)
        if isCancelShow {
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alert.addAction(cancel)
        }
        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
    }

    class func image(_ originalImage: UIImage?, scaledTo size: CGSize) -> UIImage? {

        
        //avoid redundant drawing
        if originalImage?.size.equalTo(size) ?? false {
            return originalImage
        }

        //create drawing context
        UIGraphicsBeginImageContextWithOptions(size, _ : false, _ : 0.0)

        //draw
        originalImage?.draw(in: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))

        //capture resultant image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        //return image
        return image
    }

    typealias CompletionHandler = (_ success:Bool) -> Void
    
    
    class func convertTimeStampToFormat(unixtimeInterval : String, dateFormat : String) -> String
    {

        if(unixtimeInterval.count != 0)
        {
            let date = Date(timeIntervalSince1970: Double(unixtimeInterval) as! TimeInterval)
            let dateFormatter = DateFormatter()
            //        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = dateFormat //Specify your format that you want
            let strDate = dateFormatter.string(from: date)
            return strDate
        }
        return ""
    }

   
}
