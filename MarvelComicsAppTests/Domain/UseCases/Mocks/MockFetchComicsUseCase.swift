//
//  MockFetchComicsUseCase.swift
//  MarvelComicsApp
//
//  Created by Oscar R. Garrucho on 3/8/25.
//

import XCTest
@testable import MarvelComicsApp

// MARK: - MockFetchComicsUseCase
final class MockFetchComicsUseCase: FetchComicsUseCase {
    var result: Result<[Creator: [Comic]], Error>?
    
    func execute(completion: @escaping (Result<[Creator : [Comic]], Error>) -> Void) {
        if let result = result {
            completion(result)
        }
    }
}
