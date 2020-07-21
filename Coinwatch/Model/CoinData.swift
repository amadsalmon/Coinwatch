//
//  CoinModel.swift
//  Coinwatch
//
//  Created by Amad Salmon on 21/07/2020.
//  Copyright © 2020 Amad Salmon. All rights reserved.
//

import Foundation

struct CoinData: Codable{
    let time: String
    let asset_id_base: String
    let asset_id_quote: String
    let rate: Double
}
