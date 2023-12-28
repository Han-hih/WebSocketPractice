//
//  Model.swift
//  UpbitSocketAPI
//
//  Created by 황인호 on 12/28/23.
//

import Foundation

struct TickerModel: Decodable {
    let type, code, streamType: String
    let tradePrice: Double
    
    enum CodingKeys: String, CodingKey {
        case type, code
        case streamType = "stream_type"
        case tradePrice = "trade_price"
    }
    
}
