//
//  ProductList.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/24.
//

import Foundation

struct ProductList: Codable {
    var pageNumber: Int?
    var itemsPerPage: Int?
    var totalCount: Int?
    var offset: Int?
    var limit: Int?
    var pages: [Product]?
    var lastPage: Int?
    var hasNext: Bool?
    var hasPrev: Bool?
    
    enum CodingKeys: String, CodingKey {
        case pageNumber = "page_no"
        case itemsPerPage = "items_per_page"
        case totalCount = "total_count"
        case offset, limit, pages
        case lastPage = "last_page"
        case hasNext = "has_next"
        case hasPrev = "has_prev"
    }
}
