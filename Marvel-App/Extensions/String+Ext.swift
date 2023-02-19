//
//  StringExt.swift
//  Marvel-App
//
//  Created by YILDIRIM on 8.02.2023.
//

import Foundation
import CryptoKit
extension String {
    
    func MD5() -> String {
        let digest = Insecure.MD5.hash(data: self.data(using: .utf8) ?? Data())
        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }

}
