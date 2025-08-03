//
//  FetchComicsUseCase.swift
//  MarvelComicsApp
//
//  Created by Oscar R. Garrucho on 3/8/25.
//

import Foundation

// MARK: - FetchComicsUseCase
protocol FetchComicsUseCase {
    func execute(completion: @escaping (Result<[Creator: [Comic]], Error>) -> Void)
}

// MARK: - FetchComicsUseCaseImpl
final class FetchComicsUseCaseImpl: FetchComicsUseCase {
    private let repository: MarvelRepositoryProtocol

    init(repository: MarvelRepositoryProtocol) {
        self.repository = repository
    }

    func execute(completion: @escaping (Result<[Creator : [Comic]], Error>) -> Void) {
        repository.fetchComics { result in
            switch result {
            case .success(let comics):
                let grouped = Dictionary(grouping: comics.flatMap { comic in
                    comic.creators.map { creator in (creator, comic) }
                }, by: { $0.0 })
                    .mapValues { $0.map { $0.1 } }
                completion(.success(grouped))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
