//
//  PostProductTests.swift
//  OpenMarketTests
//
//  Created by kakao on 2022/02/08.
//

import Foundation
@testable import OpenMarket
import XCTest

class PostProductRealTests: XCTestCase {
    func test_상품등록이_성공한다() {
        let product: PostProduct = PostProduct(name: "vapor",
                                               amount: 500,
                                               currency: "KRW",
                                               secret: secret,
                                               descriptions: "안녕하세요 테스트에요",
                                               price: 123456)
        let image: [UIImage?] = [UIImage(systemName: "plus"),
                                 UIImage(systemName: "plus")]
        timeout(30) { exp in
            PostProductLoader().post(product, images: image) { result in
                exp.fulfill()
                switch result {
                case .success(let product):
                    XCTAssertNotNil(product.identifier)
                case .failure(let error):
                    print(error)
                    XCTFail()
                }
            }
        }
    }
}
