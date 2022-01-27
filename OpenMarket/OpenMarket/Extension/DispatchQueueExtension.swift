//
//  DispatchQueueExtension.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/27.
//

import Foundation

extension DispatchQueue {
    static func mainThread(_ completion: @escaping () -> Void ) {
        if Thread.isMainThread {
            completion()
        } else {
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}
