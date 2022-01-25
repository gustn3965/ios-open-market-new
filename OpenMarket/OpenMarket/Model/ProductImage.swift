//
//  ProductImage.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/24.
//

import Foundation

struct ProductImage: Codable {
    var identifier: Int
    var url: String
    var thumbnailUrl: String
    var succeed: Bool
    var issuedAt: String
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case url, succeed
        case thumbnailUrl = "thumbnail_url"
        case issuedAt = "issued_at"
    }
}
