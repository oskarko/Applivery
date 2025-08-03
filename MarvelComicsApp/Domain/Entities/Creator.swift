//
//  Creator.swift
//  MarvelComicsApp
//
//  Created by Oscar R. Garrucho on 3/8/25.
//

import Foundation

struct Creator: Identifiable, Hashable {
    let _id: String
    let fullName: String

    var id: String { _id }
}
