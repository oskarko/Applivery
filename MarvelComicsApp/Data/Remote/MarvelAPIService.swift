//
//  MarvelAPIService.swift
//  MarvelComicsApp
//
//  Created by Oscar R. Garrucho on 3/8/25.
//

import Foundation

// MARK: - ComicDataSource
protocol ComicDataSource {
    func fetchComics(completion: @escaping (Result<[ComicDTO], Error>) -> Void)
}

// MARK: - MarvelAPIService
final class MarvelAPIService: ComicDataSource {
    private let baseURL = "https://gateway.marvel.com/v1/public/comics"
    private let publicKey = ""
    private let privateKey = ""

    func fetchComics(completion: @escaping (Result<[ComicDTO], Error>) -> Void) {
        let timestamp = "\(Date().timeIntervalSince1970)"
        let hash = "\(timestamp)\(privateKey)\(publicKey)".md5()
        let urlString = "\(baseURL)?ts=\(timestamp)&apikey=\(publicKey)&hash=\(hash)"

        guard let url = URL(string: urlString) else {
            return completion(.failure(URLError(.badURL)))
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                return completion(.failure(URLError(.badServerResponse)))
            }

            do {
                let response = try JSONDecoder().decode(MarvelAPIResponse.self, from: data)
                completion(.success(response.data.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
