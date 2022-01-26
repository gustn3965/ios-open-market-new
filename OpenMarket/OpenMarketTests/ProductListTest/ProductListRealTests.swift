//
//  ProductListRealTests.swift
//  OpenMarketTests
//
//  Created by kakao on 2022/01/25.
//
@testable import OpenMarket
import XCTest

class ProductListRealTests: XCTestCase {
    func test_상품리스트_요청에서_pageNumber가_음수1이면_serverError를_받는다() {
        timeout(3) { exp in
            ProductListLoader().getProductList(pageNumber: -1, itemsPerPage: 3) { result in
                exp.fulfill()
                switch result {
                case .success(_):
                    XCTFail()
                case .failure(let error):
                    XCTAssertEqual(error, .serverError)
                }
            }
        }
    }
    
    // 실제 요청
    func test_상품리스트_요청이_성공할경우_파싱해서_pages를_가져올수_있다() {
        timeout(3) { exp in
            ProductListLoader().getProductList(pageNumber: 1, itemsPerPage: 3) { result in
                exp.fulfill()
                switch result {
                case .success(let productList):
                    XCTAssertNotNil(productList.pages)
                case .failure(_):
                    XCTFail()
                }
            }
        }
    }
}
