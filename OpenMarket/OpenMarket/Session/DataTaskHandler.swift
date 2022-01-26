//
//  DataTaskHandler.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/26.
//

import Foundation

enum DataTaskHandler {
    static func handle<T: Codable>(data: Data?, response: URLResponse?, error: Error?) -> Result<T, OpenMarketError> {
        if error != nil {
            return .failure(.sessionError)
        }
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            return .failure(.noStatusCode)
        }
        switch statusCode {
        case (200..<300):
            guard let data = data else {
                return .failure(.noData)
            }
            guard let model: T = JSONParser.decode(T.self, from: data) else {
                return .failure(.parsingError)
            }
            return .success(model)
        case (400..<500):
            printErrorMessage(by: data)
            return .failure(.clientError)
        case (500..<600):
            printErrorMessage(by: data)
            return .failure(.serverError)
        default:
            printErrorMessage(by: data)
            return .failure(.unknownError)
        }
    }
    
    private static func printErrorMessage(by data: Data?) {
        guard let data = data,
              let model: ErrorMessage = JSONParser.decode(ErrorMessage.self, from: data) else {
            return
        }
        print(model.message ?? "")
    }
}
