//
//  ProductListCellable.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/27.
//

import UIKit

protocol ProductListCellable: UICollectionViewCell {
    var imageView: UIImageView { get }
    var titleLabel: UILabel { get }
    var priceLabel: UILabel { get }
    var stockLabel: UILabel { get }
    var bargainLabel: UILabel { get }
    
    func updateView(by product: Product, cache: NSCache<NSString, UIImage>)
    
    func resetView()
}

extension ProductListCellable {
    func updateView(by product: Product,
                    cache: NSCache<NSString, UIImage>) {
        titleLabel.text = product.name
        if let bargainPrice: Double = product.bargainPrice {
            bargainLabel.text = bargainPrice.priceWithComma == "0" ? "" : "\(product.currency ?? "") \(bargainPrice.priceWithComma)"
            bargainLabel.isHidden = bargainPrice == 0
            bargainLabel.attributedText = (bargainLabel.text ?? "").strikeThrough()
        }
        priceLabel.text = "\(product.currency ?? "") \((product.price ?? 0).priceWithComma)"
        if let stock: Int = product.stock {
            stockLabel.textColor = stock == 0 ? .systemOrange : .systemGray
            stockLabel.text = stock == 0 ? "품절" : "잔여수량: \(product.stock ?? 0)"
        }
        updateImageView(by: product, cache: cache)
    }
    
    func resetView() {
        titleLabel.text = ""
        stockLabel.text = ""
        priceLabel.text = ""
        bargainLabel.text = ""
        imageView.image = nil
        bargainLabel.isHidden = false
        stockLabel.textColor = .systemGray
    }
    
    func updateImageView(by product: Product,
                         cache: NSCache<NSString, UIImage>) {
        guard let thumbnailStr = product.thumbnail else {
            imageView.image = nil
            return
        }
        let thumbnaiNSStr: NSString = NSString(string: thumbnailStr)
        if let cacheImage: UIImage = cache.object(forKey: thumbnaiNSStr) {
            imageView.image = cacheImage
            return
        }
        
        DispatchQueue.global().async {
            guard let url = URL(string: thumbnailStr),
                  let image = try? UIImage(data: Data(contentsOf: url, options: .alwaysMapped))
            else {
                cache.removeObject(forKey: thumbnaiNSStr)
                DispatchQueue.mainThread {
                    self.imageView.image = nil
                }
                return
            }
            cache.setObject(image, forKey: thumbnaiNSStr)
            DispatchQueue.mainThread {
                self.imageView.image = image
            }
        }
    }
}
