//
//  ContentsTextField.swift
//  OpenMarket
//
//  Created by kakao on 2022/02/10.
//

import UIKit

enum ContentsTextFieldType {
    case title, price, discount, stock
    
    var placeHolder: String {
        switch self {
        case .title:
            return "상품명"
        case .price:
            return "상품가격"
        case .discount:
            return "할인금액"
        case .stock:
            return "재고수량"
        }
    }
    
    var keyboardType: UIKeyboardType {
        switch self {
        case .title:
            return .default
        case .price:
            return .numberPad
        case .discount:
            return .numberPad
        case .stock:
            return .numberPad
        }
    }
}

class ContentsTextField: UITextField {
    var contentsType: ContentsTextFieldType
    
    init(contentsType: ContentsTextFieldType) {
        self.contentsType = contentsType
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("story board didn't implemented")
    }
}
