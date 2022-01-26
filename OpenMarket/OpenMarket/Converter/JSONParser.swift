//
//  JSONParser.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/24.
//

import Foundation

enum JSONParser {
    static func decode<T: Codable>(_ modelType: T.Type, from data: Data) -> T? {
        do {
            return try JSONDecoder().decode(modelType, from: data)
        } catch {
            assertionFailure()
            print(error.localizedDescription)
            return nil
        }
    }
    
    static func encode<T: Codable>(_ model: T) -> Data? {
        do {
            return try JSONEncoder().encode(model)
        } catch {
            assertionFailure()
            return nil
        }
    }
}
