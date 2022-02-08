//
//  PostProductLoader.swift
//  OpenMarket
//
//  Created by kakao on 2022/02/08.
//

import Foundation
import UIKit.UIImage

final class PostProductLoader {
    private let session: Session
    
    init(session: Session = URLSession.shared) {
        self.session = session
    }
    
    func post(_ product: PostProduct,
                     images: [UIImage?],
                     completion: @escaping (Result<Product, OpenMarketError>) -> Void) {
        guard let request = createRequest(by: product, images: images) else {
            return
        }
        
        session.dataTask(request: request) { data, response, error in
            let result: Result<Product, OpenMarketError> = DataTaskHandler.handle(data: data,
                                                                                  response: response,
                                                                                  error: error)
            completion(result)
        }
    }
    
    private func createRequest(by product: PostProduct,
                               images: [UIImage?]) -> URLRequest? {
        guard let url = URL(string: "https://market-training.yagom-academy.kr/api/products") else {
            assertionFailure()
            return nil
        }
        let boundaryName: String = "aaa"
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("660cc59a-7217-11ec-abfa-25c6fa6d057a",
                         forHTTPHeaderField: "identifier")
        request.setValue("multipart/form-data; boundary=\(boundaryName)",
                         forHTTPHeaderField: "Content-Type")
        request.httpBody = createMultipartData(boundaryName: boundaryName,
                                               product: product,
                                               images: images)
        return request
    }
    
    private func createMultipartData(boundaryName: String,
                                     product: PostProduct,
                                     images: [UIImage?]) -> Data? {
        guard let boundaryForm: Data = ("--\(boundaryName)" + "\r\n").data(using: .utf8),
              let closeBoundaryForm: Data = ("--\(boundaryName)--\r\n").data(using: .utf8),
              let paramsForm: Data = ("Content-Disposition: form-data; name=params\r\n").data(using: .utf8),
              let paramsTypeForm: Data = ("Content-Type: application/json" + "\r\n\r\n").data(using: .utf8),
              let imagesTypeForm: Data = ("Content-Type: image/jpeg" + "\r\n\r\n").data(using: .utf8),
              let lineBreakForm: Data = ("\r\n").data(using: .utf8),
              let productData = JSONParser.encode(product) else { return nil }
        let imagesData: [Data] = images.compactMap { $0?.jpegData(compressionQuality: 0.3) }
        let imagesForms: [Data] = images.enumerated().compactMap { ("Content-Disposition: form-data; name=images; filename=vapor\($0.offset).jpeg\r\n").data(using: .utf8)
        }
        
        var data: Data = Data()
        data.append(boundaryForm)
        data.append(paramsForm)
        data.append(paramsTypeForm)
        data.append(productData)
        data.append(lineBreakForm)
        
        zip(imagesData, imagesForms).forEach { imageData, imageForm in
            data.append(boundaryForm)
            data.append(imageForm)
            data.append(imagesTypeForm)
            data.append(imageData)
            data.append(lineBreakForm)
        }
        data.append(closeBoundaryForm)
        return data
    }
    
    func isProductAllRequired(_ product: PostProduct, images: [UIImage?]) -> Bool {
        if product.name == nil ||
            product.descriptions == nil ||
            product.price == nil ||
            product.currency == nil ||
            product.secret == nil ||
            images.filter({ $0 != nil }).isEmpty {
            return false
        }
        return true
    }
}
