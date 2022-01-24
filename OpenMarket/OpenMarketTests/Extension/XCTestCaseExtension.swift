//
//  XCTestCaseExtension.swift
//  OpenMarketTests
//
//  Created by kakao on 2022/01/24.
//

import XCTest

extension XCTestCase {
    func timeout(_ timeout: TimeInterval, completion: (XCTestExpectation) -> Void) {
        let exp = expectation(description: "Timeout: \(timeout) seconds")
        
        completion(exp)
        
        waitForExpectations(timeout: timeout) { error in
            guard let error = error else { return }
            XCTFail("Timeout error: \(error)")
        }
    }
}
