//
//  ProductListViewModel.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/24.
//

import Foundation

final class ProductListViewModel {
    private let session: Session
    
    init(session: Session = URLSession.shared) {
        self.session = session
    }
    
    func getProductList(pageNumber: Int,
                        itemsPerPage: Int,
                        completion: @escaping (Result<ProductList, OpenMarketError>) -> Void) {
        guard let request = createRequest(pageNumber: pageNumber,
                                          itemsPerPage: itemsPerPage) else {
            return
        }
        session.dataTask(request: request) { result in
            switch result {
            case .success(let data):
                guard let model: ProductList = JSONParser.decode(ProductList.self, from: data) else {
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
    
    private func createRequest(pageNumber: Int,
                               itemsPerPage: Int) -> URLRequest? {
        guard let url = URL(string: "https://market-training.yagom-academy.kr/api/products?page_no=\(pageNumber)&items_per_page=\(itemsPerPage)") else {
            assertionFailure()
            return nil
        }
        return URLRequest(url: url)
    }
}
