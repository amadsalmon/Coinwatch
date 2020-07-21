//
//  CoinModel.swift
//  Coinwatch
//
//  Created by Amad Salmon on 21/07/2020.
//  Copyright © 2020 Amad Salmon. All rights reserved.
//

import Foundation

struct CoinModel {
    let fullDateAndTime: String
    let asset_id_base: String
    let asset_id_quote: String
    let rate: Double
    
    var rateString: String{
        return String(format: "%.5f", rate)
    }
    
    /* time is given in the following format : 2020-07-21T12:30:17.7995170Z.
     We have to split it into two more readable strings.
     */
    var date: String{
        return fullDateAndTime.components(separatedBy: "T")[0]
    }
    var time: String{
        let full = fullDateAndTime.components(separatedBy: "T")[1]
        return full.components(separatedBy: ".")[0]
    }
}
