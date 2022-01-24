//
//  MockSession.swift
//  OpenMarketTests
//
//  Created by kakao on 2022/01/24.
//

@testable import OpenMarket
import Foundation

class MockSessionErrorSession: Session {
    func dataTask(request: URLRequest, completion: @escaping OpenMarketResult) {
        completion(.failure(.sessionError))
    }
}

class MockSession: Session {
    private var data: Data?
    
    init(data: Data? = nil ) {
        self.data = data
    }
    
    func dataTask(request: URLRequest, completion: @escaping OpenMarketResult) {
        guard let product = data else {
            completion(.failure(.noData))
            return
        }
        completion(.success(product))
    }
}
