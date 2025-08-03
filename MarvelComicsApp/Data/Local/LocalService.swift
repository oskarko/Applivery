//
//  LocalService.swift
//  MarvelComicsApp
//
//  Created by Oscar R. Garrucho on 3/8/25.
//

import Foundation

// MARK: - LocalService
final class LocalService: ComicDataSource {
    func fetchComics(completion: @escaping (Result<[ComicDTO], Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            guard let url = Bundle.main.url(forResource: "mockComics", withExtension: "json") else {
                return completion(.failure(MockAPIError.fileNotFound))
            }

            do {
                let data = try Data(contentsOf: url)
                let response = try JSONDecoder().decode(MarvelAPIResponse.self, from: data)
                completion(.success(response.data.results))
            } catch {
                completion(.failure(error))
            }
        }
    }

    enum MockAPIError: Error {
        case fileNotFound
    }
} 
