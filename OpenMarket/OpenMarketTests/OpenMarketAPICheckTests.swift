//
//  OpenMarketAPICheckTests.swift
//  OpenMarketTests
//
//  Created by kakao on 2022/01/24.
//

import XCTest

class OpenMarketAPICheckTests: XCTestCase {
    func test_openMarket_API가_유효하다() {
        guard let _: URL = URL(string: "https://market-training.yagom-academy.kr/healthChecker") else {
            XCTFail()
            return
        }
        XCTAssertTrue(true)
    }
    
    
    func test_openMarket_API는_현재_동작가능하다() {
        timeout(3) { exp in
            guard let url = URL(string: "https://market-training.yagom-academy.kr/healthChecker") else {
                exp.fulfill()
                XCTFail()
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                exp.fulfill()
                guard let data = data,
                      let text = String(data: data, encoding: .utf8)else {
                          XCTFail()
                          return
                      }
                print(text)
                XCTAssertTrue(text == "\"OK\"")
            }.resume()
        }
    }
}
