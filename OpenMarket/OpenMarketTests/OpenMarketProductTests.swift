//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by kakao on 2022/01/24.
//

@testable import OpenMarket
import XCTest

class OpenMarketProductTests: XCTestCase {    
    func test_상품상세데이터_요청이_session에서_실패할경우_sessionError를_받는다() {
        timeout(3) { exp in
            ProductViewModel(session: MockSessionErrorSession()).getProduct(number: 899) { result in
                exp.fulfill()
                switch result {
                case .success(_):
                    XCTFail()
                case .failure(let error):
                    XCTAssertTrue(error == .sessionError)
                }
            }
        }
    }
    
    func test_상품상세데이터_요청이_서버실패라면_메세지를_받는다() {
        let serverErrorProduct: Product = Product(code: 500, message: "server error")
        guard let data = JSONParser.encode(serverErrorProduct) else {
            XCTFail()
            return
        }
        
        let productViewModel = ProductViewModel(session: MockSession(data: data))
        timeout(3) { exp in
            productViewModel.getProduct(number: 9999999) { result in
                exp.fulfill()
                switch result {
                case .success(let product):
                    print(product.message ?? "nil")
                    XCTAssertNotNil(product.message)
                case .failure(_):
                    XCTFail()
                }
            }
        }
    }
    
    func test_상품상세데이터_요청이_200번대로_성공하면서_제품아이디가_없으면_doesNotContainProduct메세지를_받는다() {
        timeout(3) { exp in
            ProductViewModel().getProduct(number: 9999999) { result in
                exp.fulfill()
                switch result {
                case .success(let product):
                    print(product.message ?? "nil")
                    XCTAssertNotNil(product.message)
                case .failure(_):
                    XCTFail()
                }
            }
        }
    }
    
    func test_상품상세데이터_요청이_성공할경우_파싱해서_id를_가져올수_있다() {
        timeout(3) { exp in
            ProductViewModel().getProduct(number: 899) { result in
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
