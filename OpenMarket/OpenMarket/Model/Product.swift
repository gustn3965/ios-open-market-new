//
//  Product.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/24.
//

import Foundation

struct Product: Codable {
    var identifier: Int?
    var vendorId: Int?
    var name: String?
    var thumbnail: String?
    var currency: String?
    var price: Double?
    var bargainPrice: Double?
    var discountedPrice: Double?
    var stock: Int?
    var createdAt: String?
    var issuedAt: String?
    var images: [ProductImage]?
    var description: String?
    var secret: String?
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case vendorId = "vendor_id"
        case name, thumbnail, currency, price, stock, images, description, secret
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}
