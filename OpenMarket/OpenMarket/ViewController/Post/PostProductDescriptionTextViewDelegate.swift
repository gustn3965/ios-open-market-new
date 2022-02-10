//
//  PostProductDescriptionTextViewDelegate.swift
//  OpenMarket
//
//  Created by kakao on 2022/02/10.
//

import UIKit

class PostProductDescriptionTextViewDelegate: NSObject, UITextViewDelegate {
    var touchTextFieldCompletion: ((TextFieldTouchType) -> Void)?
    var postProduct: PostProduct
    
    init(postProduct: PostProduct) {
        self.postProduct = postProduct
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        touchTextFieldCompletion?(.beginTouch)
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        postProduct.descriptions = textView.text?.isEmpty == true ? nil : textView.text
    }
}

