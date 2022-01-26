//
//  ProductRealTests.swift
//  OpenMarketTests
//
//  Created by kakao on 2022/01/26.
//
@testable import OpenMarket
import XCTest

class ProductRealTests: XCTestCase {
    func test_상품상세데이터_요청_제품아이디가_없으면_clientError메세지를_받는다() {
        timeout(3) { exp in
            ProductLoader().getProduct(number: 9999999) { result in
                exp.fulfill()
                switch result {
                case .success(_):
                    XCTFail()
                case .failure(let error):
                    XCTAssertEqual(error, .clientError)
                }
            }
        }
    }
    
    func test_상품상세데이터_요청이_성공할경우_파싱해서_id를_가져올수_있다() {
        timeout(3) { exp in
            ProductLoader().getProduct(number: 899) { result in
                exp.fulfill()
                switch result {
                case .success(let product):
                    XCTAssertNotNil(product.identifier)
                case .failure(_):
                    XCTFail()
                }
            }
        }
    }
}
