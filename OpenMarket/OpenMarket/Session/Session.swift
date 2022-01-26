//
//  Session.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/24.
//

import Foundation

enum OpenMarketError: Error {
    case sessionError
    case noData
    case noStatusCode
    case parsingError
    case clientError // 400번대 에러
    case serverError // 500번대 에러
    case unknownError
}

typealias OpenMarketResult = (Result<Data, OpenMarketError>) -> Void

protocol Session {
    func dataTask(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void)
}

extension URLSession: Session {
    func dataTask(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        dataTask(with: request) { data, response, error in
            completion(data, response, error)
        }.resume()
    }
}
