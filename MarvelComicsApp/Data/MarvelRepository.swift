//
//  MarvelRepository.swift
//  MarvelComicsApp
//
//  Created by Oscar R. Garrucho on 3/8/25.
//

import Foundation

// MARK: - MarvelRepositoryProtocol
protocol MarvelRepositoryProtocol {
    func fetchComics(completion: @escaping (Result<[Comic], Error>) -> Void)
}

// MARK: - MarvelRepository
final class MarvelRepository: MarvelRepositoryProtocol {
    private let service: ComicDataSource
    
    init(service: ComicDataSource) {
        self.service = service
    }
    
    func fetchComics(completion: @escaping (Result<[Comic], Error>) -> Void) {
        service.fetchComics { result in
            switch result {
            case .success(let dtos):
                let comics = dtos.map { dto -> Comic in
                    let creators = dto.creators.items.map {
                        Creator(_id: $0.resourceURI, fullName: $0.fullName)
                    }
                    return Comic(id: dto.id, title: dto.title, creators: creators)
                }
                completion(.success(comics))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
