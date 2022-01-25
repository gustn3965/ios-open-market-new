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
    var code: Int? // 요청 성공이지만, 상태코드 확인
    var message: String? // 요청 성공이지만, 상태 코드에 따른 메세지 내용
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case vendorId = "vendor_id"
        case name, thumbnail, currency, price, stock, images, code, message
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}
