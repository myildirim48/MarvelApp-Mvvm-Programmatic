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

extension Array where Element:Displayable {
    func toDisplayable() -> Array<DisplayableResource>{
        self.isEmpty ? [] : self.map{ $0.convert(type: $0) }
    }
}
