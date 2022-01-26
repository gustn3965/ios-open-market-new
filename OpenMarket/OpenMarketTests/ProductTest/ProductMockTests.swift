//
//  ProductMockTests.swift
//  OpenMarketTests
//
//  Created by kakao on 2022/01/26.
//
@testable import OpenMarket
import XCTest

let apiHost: String = "https://market-training.yagom-academy.kr/"

class ProductMockTests: XCTestCase {
    
    func test_Mock_상품상세데이터_요청이_session에서_실패할경우_sessionError를_받는다() {
        let mockSession: MockSession = MockSession(data: nil, urlResponse: nil, error: OpenMarketError.sessionError)
        let productLoader = ProductLoader(session: mockSession)
        timeout(3) { exp in
            productLoader.getProduct(number: 899) { result in
                exp.fulfill()
                switch result {
                case .success(_):
                    XCTFail()
                case .failure(let error):
                    XCTAssertEqual(error, .sessionError)
                }
            }
        }
    }
    
    func test_Mock_상품상세데이터_요청이_서버실패라면_serverError를_받는다() {
        guard let mockResponse: URLResponse = createMockResponse(apiHost, statusCode: 500) else {
            XCTFail()
            return
        }
        let mockSession: MockSession = MockSession(data: nil, urlResponse: mockResponse, error: nil)
        let productLoader = ProductLoader(session: mockSession)
        timeout(3) { exp in
            productLoader.getProduct(number: 9999999) { result in
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
    
    func test_Mock_상품상세데이터_요청_제품아이디가_없으면_clientError메세지를_받는다() {
        guard let mockResponse: URLResponse = createMockResponse(apiHost, statusCode: 404) else {
            XCTFail()
            return
        }
        let mockSession: MockSession = MockSession(data: nil, urlResponse: mockResponse, error: nil)
        let productLoader = ProductLoader(session: mockSession)
        timeout(3) { exp in
            productLoader.getProduct(number: 9999999) { result in
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
