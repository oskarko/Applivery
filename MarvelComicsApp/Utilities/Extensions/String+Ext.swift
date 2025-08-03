//
//  String+Ext.swift
//  MarvelComicsApp
//
//  Created by Oscar R. Garrucho on 3/8/25.
//

import CryptoKit
import Foundation

extension String {
    
    func md5() -> String {
        let digest = Insecure.MD5.hash(data: self.data(using: .utf8) ?? Data())
        
        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
}
