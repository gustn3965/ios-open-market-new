//
//  MockSession.swift
//  OpenMarketTests
//
//  Created by kakao on 2022/01/24.
//

@testable import OpenMarket
import Foundation

class MockSession: Session {
    private let data: Data?
    private let urlResponse: URLResponse?
    private let error: Error?
    
    init(data: Data?, urlResponse: URLResponse?, error: Error?) {
        self.data = data
        self.urlResponse = urlResponse
        self.error = error
    }
    
    func dataTask(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        completion(data, urlResponse, error)
    }
}

func createMockResponse(_ apiHost: String, statusCode: Int) -> HTTPURLResponse? {
    guard let url: URL = URL(string: apiHost) else {
        return nil
    }
    return HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)
}
