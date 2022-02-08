//
//  PostProduct.swift
//  OpenMarket
//
//  Created by kakao on 2022/02/08.
//

import Foundation

class PostProduct: Codable {
    var name: String?
    var amount: Int?
    var currency: String?
    var secret: String?
    var descriptions: String?
    var price: Int?
    var discountedPrice: Int?
    
    init(name: String? = nil, amount: Int? = nil, currency: String? = nil, secret: String? = nil, descriptions: String? = nil, price: Int? = nil, discountedPrice: Int? = nil) {
        self.name = name
        self.amount = amount
        self.currency = currency
        self.secret = secret
        self.descriptions = descriptions
        self.price = price
        self.discountedPrice = discountedPrice
    }
    
    enum CodingKeys: String, CodingKey {
        case name, amount, currency, secret, descriptions, price
        case discountedPrice = "discounted_price"
    }
}
