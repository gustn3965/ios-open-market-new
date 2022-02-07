//
//  DoubleExtension.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/27.
//

import Foundation

extension Double {
    var priceWithComma: String {
        let numberFormatter: NumberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return (numberFormatter.string(from: NSNumber(value: self)) ?? "0")
    }
}
