//
//  MarvelDTOs.swift
//  MarvelComicsApp
//
//  Created by Oscar R. Garrucho on 3/8/25.
//

import Foundation

struct MarvelAPIResponse: Decodable {
    let data: ComicDataContainer
}

struct ComicDataContainer: Decodable {
    let results: [ComicDTO]
}

struct ComicDTO: Decodable {
    let id: Int
    let title: String
    let creators: CreatorList
}

struct CreatorList: Decodable {
    let items: [CreatorSummary]
}

struct CreatorSummary: Decodable {
    let resourceURI: String
    let fullName: String
}
