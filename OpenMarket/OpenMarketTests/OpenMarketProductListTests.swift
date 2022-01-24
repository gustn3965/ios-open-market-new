//
//  OpenMarketProductListTests.swift
//  OpenMarketTests
//
//  Created by kakao on 2022/01/24.
//
@testable import OpenMarket
import XCTest

class OpenMarketProductListTests: XCTestCase {
    func test_상품리스트_요청이_session에서_실패할경우_sessionError를_받는다() {
        timeout(3) { exp in
            ProductListViewModel(session: MockSessionErrorSession())
                .getProductList(pageNumber: 1, itemsPerPage: 3) { result in
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
    
    func test_상품리스트_요청이_서버실패라면_메세지를_받는다() {
        let serverErrorProduct: ProductList = ProductList(code: 500, message: "server error")
        guard let data = JSONParser.encode(serverErrorProduct) else {
            XCTFail()
            return
        }
        
        let productListViewModel = ProductListViewModel(session: MockSession(data: data))
        
        timeout(3) { exp in
            productListViewModel.getProductList(pageNumber: 1, itemsPerPage: 3) { result in
                exp.fulfill()
                switch result {
                case .success(let productList):
                    print(productList.message ?? "nil")
                    XCTAssertNotNil(productList.message)
                case .failure(_):
                    XCTFail()
                }
            }
        }
    }
    
    func test_상품리스트_요청이_200번대로_성공하면서_pageNumber가_잘못되면_PageIndexMustNotBe_메세지를_받는다() {
        timeout(3) { exp in
            ProductListViewModel().getProductList(pageNumber: -1, itemsPerPage: 3) { result in
                exp.fulfill()
                switch result {
                case .success(let productList):
                    print(productList.message ?? "nil")
                    XCTAssertNotNil(productList.message)
                case .failure(_):
                    XCTFail()
                }
            }
        }
    }
    
    func test_상품리스트_요청이_성공할경우_파싱해서_pages를_가져올수_있다() {
        timeout(3) { exp in
            ProductListViewModel().getProductList(pageNumber: 1, itemsPerPage: 3) { result in
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
