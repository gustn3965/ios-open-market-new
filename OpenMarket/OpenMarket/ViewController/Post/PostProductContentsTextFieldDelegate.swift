//
//  PostProductContentsTextFieldDelegate.swift
//  OpenMarket
//
//  Created by kakao on 2022/02/10.
//

import UIKit

class PostProductContentsTextFieldDelegate: NSObject, UITextFieldDelegate {
    var touchTextFieldCompletion: ((TextFieldTouchType) -> Void)?
    var postProduct: PostProduct
    
    init(postProduct: PostProduct) {
        self.postProduct = postProduct
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        touchTextFieldCompletion?(.beginTouch)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        touchTextFieldCompletion?(.endTouch)
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let textField: ContentsTextField = textField as? ContentsTextField else {
            return
        }

        switch textField.contentsType {
        case .title:
            postProduct.name = textField.text
        case .price:
            postProduct.price = textField.text == nil ? nil : Int(textField.text ?? "")
        case .stock:
            postProduct.amount = textField.text == nil ? nil : Int(textField.text ?? "")
        case .discount:
            postProduct.discountedPrice = textField.text == nil ? nil : Int(textField.text ?? "")
        }
    }
}
