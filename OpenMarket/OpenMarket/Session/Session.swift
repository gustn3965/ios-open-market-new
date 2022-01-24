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
    case parsingError
}

typealias OpenMarketResult = (Result<Data, OpenMarketError>) -> Void

protocol Session {
    func dataTask(request: URLRequest, completion: @escaping OpenMarketResult)
}

extension URLSession: Session {
    func dataTask(request: URLRequest, completion: @escaping OpenMarketResult) {
        dataTask(with: request) { data, _, error in
            if error != nil {
                completion(.failure(.sessionError))
                return
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            completion(.success(data))
        }.resume()
    }
}
