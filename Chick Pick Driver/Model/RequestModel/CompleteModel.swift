//
//  CompleteModel.swift
//  Pappea Driver
//
//  Created by Apple on 02/08/19.
//  Copyright © 2019 baps. All rights reserved.
//

import Foundation


class CompleteModel : RequestModel {
    var booking_id: String = ""
    var dropoff_lat: String = ""
    var dropoff_lng: String = ""
}

class RejectModel : RequestModel {
    var booking_id: String = ""
    var driver_id: String = ""
}
