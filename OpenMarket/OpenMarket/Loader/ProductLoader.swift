//
//  ProductViewModel.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/24.
//

import Foundation

final class ProductLoader {
    private let session: Session
    
    init(session: Session = URLSession.shared) {
        self.session = session
    }
    
    func getProduct(number: Int, completion: @escaping (Result<Product, OpenMarketError>) -> Void) {
        guard let request = createRequest(by: number) else {
            return
        }
        
        session.dataTask(request: request) { data, response, error in
            let result: Result<Product, OpenMarketError> = DataTaskHandler.handle(data: data,
                                                                                  response: response,
                                                                                  error: error)
            completion(result)
        }
    }
    
    private func createRequest(by productNumber: Int) -> URLRequest? {
        guard let url = URL(string: "https://market-training.yagom-academy.kr/api/products/\(productNumber)") else {
            assertionFailure()
            return nil
        }
        return URLRequest(url: url)
    }
}
