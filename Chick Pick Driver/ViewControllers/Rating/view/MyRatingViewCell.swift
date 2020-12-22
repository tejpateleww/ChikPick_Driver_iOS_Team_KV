//
//  MyRatingViewCell.swift
//  Chick Pick Driver
//
//  Created by Bhumi on 22/12/20.
//  Copyright © 2020 baps. All rights reserved.
//

import UIKit
import Cosmos

class MyRatingViewCell: UITableViewCell {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var viewRating: CosmosView!
    @IBOutlet weak var lblCommentTitle: UILabel!
    @IBOutlet weak var lblComments: UILabel!
    @IBOutlet weak var lblPickUpAddress: UILabel!
    @IBOutlet weak var lblDropOffAddress: UILabel!
    @IBOutlet weak var viewCell: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
