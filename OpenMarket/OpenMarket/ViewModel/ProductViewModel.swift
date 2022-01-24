//
//  ProductViewModel.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/24.
//

import Foundation

final class ProductViewModel {
    private let session: Session
    
    init(session: Session = URLSession.shared) {
        self.session = session
    }
    
    func getProduct(number: Int, completion: @escaping (Result<Product, OpenMarketError>) -> Void) {
        guard let request = createRequest(by: number) else {
            return
        }
        session.dataTask(request: request) { result in
            switch result {
            case .success(let data):
                guard let model: Product = JSONParser.decode(Product.self, from: data) else {
                    completion(.failure(.parsingError))
                    return
                }
                completion(.success(model))
                return
            case .failure(let error):
                completion(.failure(error))
            }
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
