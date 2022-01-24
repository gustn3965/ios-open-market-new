//
//  Product.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/24.
//

import Foundation

struct Product: Codable {
    var identi: Int
    var vendorId: Int
    var name: String
    var thumbnail: String
    var currency: String
    var price: Double
    var bargainPrice: Double
    var discountedPrice: Double
    var stock: Int
    var createdAt: String
    var issuedAt: String
    var images: [ProductImage]?
    
    enum CodingKeys: String, CodingKey {
        case identi = "id"
        case vendorId = "vendor_id"
        case name, thumbnail, currency, price, stock, images 
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}

struct ProductImage: Codable {
    var identi: Int
    var url: String
    var thumbnailUrl: String
    var succeed: Bool
    var issuedAt: String
    
    enum CodingKeys: String, CodingKey {
        case identi = "id"
        case url, succeed
        case thumbnailUrl = "thumbnail_url"
        case issuedAt = "issued_at"
    }
}
