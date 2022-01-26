//
//  ErrorMessage.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/26.
//

import Foundation

struct ErrorMessage: Codable {
    var code: Int?
    var message: String?
    
    enum CodingKeys: String, CodingKey {
        case code, message
    }
}
