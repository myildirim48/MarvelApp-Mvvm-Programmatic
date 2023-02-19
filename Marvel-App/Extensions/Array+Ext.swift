//
//  Array+Ext.swift
//  Marvel-App
//
//  Created by YILDIRIM on 19.02.2023.
//

import Foundation

extension Array where Element == Query {
    func toItems() -> Array<URLQueryItem>? {
        self.isEmpty ? nil : self.map { $0.item() }
    }
}
