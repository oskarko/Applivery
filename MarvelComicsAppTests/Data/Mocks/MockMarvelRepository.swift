//
//  MockMarvelRepository.swift
//  MarvelComicsApp
//
//  Created by Oscar R. Garrucho on 3/8/25.
//

@testable import MarvelComicsApp

// MARK: - MockMarvelRepository
final class MockMarvelRepository: MarvelRepositoryProtocol {
    var comicsToReturn: [Comic] = []
    var errorToReturn: Error?

    func fetchComics(completion: @escaping (Result<[Comic], Error>) -> Void) {
        if let error = errorToReturn {
            completion(.failure(error))
        } else {
            completion(.success(comicsToReturn))
        }
    }
}
