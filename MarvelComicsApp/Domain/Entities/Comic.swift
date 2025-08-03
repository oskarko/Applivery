//
//  Comic.swift
//  MarvelComicsApp
//
//  Created by Oscar R. Garrucho on 3/8/25.
//

import Foundation

struct Comic: Identifiable, Hashable {
    let id: Int
    let title: String
    let creators: [Creator]
}
