//
//  MockComicDataSource.swift
//  MarvelComicsApp
//
//  Created by Oscar R. Garrucho on 3/8/25.
//

@testable import MarvelComicsApp

// MARK: - MockRemoteDataSource
final class MockRemoteDataSource: ComicDataSource {
    var result: Result<[ComicDTO], Error>?
    
    func fetchComics(completion: @escaping (Result<[ComicDTO], Error>) -> Void) {
        if let result = result {
            completion(result)
        }
    }
}
