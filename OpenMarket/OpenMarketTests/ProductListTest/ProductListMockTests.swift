//
//  ProductListMockTests.swift
//  OpenMarketTests
//
//  Created by kakao on 2022/01/25.
//
@testable import OpenMarket
import XCTest

class ProductListMockTests: XCTestCase {
    
    func test_Mock_상품리스트_요청이_session에서_실패할경우_sessionError를_받는다() {
        let mockSession: MockSession = MockSession(data: nil, urlResponse: nil, error: OpenMarketError.sessionError)
        let productListLoader = ProductListLoader(session: mockSession)
        timeout(3) { exp in
            productListLoader.getProductList(pageNumber: 1, itemsPerPage: 3) { result in
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
    
    func test_Mock_상품리스트_요청이_서버실패라면_serverError를_받는다() {
        guard let mockResponse: URLResponse = createMockResponse(apiHost, statusCode: 500) else {
            XCTFail()
            return
        }
        let mockSession: MockSession = MockSession(data: nil, urlResponse: mockResponse, error: nil)
        let productListLoader = ProductListLoader(session: mockSession)
        timeout(3) { exp in
            productListLoader.getProductList(pageNumber: 1, itemsPerPage: 3) { result in
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
    
    func test_Mock_상품리스트_요청이_클라이언트실패라면_clientError를_받는다() {
        guard let mockResponse: URLResponse = createMockResponse(apiHost, statusCode: 404) else {
            XCTFail()
            return
        }
        let mockSession: MockSession = MockSession(data: nil, urlResponse: mockResponse, error: nil)
        let productListLoader = ProductListLoader(session: mockSession)
        timeout(3) { exp in
            productListLoader.getProductList(pageNumber: 1, itemsPerPage: 3) { result in
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
    
}
