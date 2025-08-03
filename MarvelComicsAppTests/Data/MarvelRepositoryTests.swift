//
//  MarvelRepositoryTests.swift
//  MarvelComicsApp
//
//  Created by Oscar R. Garrucho on 3/8/25.
//

import XCTest
@testable import MarvelComicsApp

// MARK: - MarvelRepositoryTests
final class MarvelRepositoryTests: XCTestCase {

    func test_fetchComics_success_returnsMappedComics() {
        let expectation = expectation(description: "Comics fetched")

        let mockRemote = MockRemoteDataSource()
        mockRemote.result = .success([
            ComicDTO(id: 1,
                     title: "Iron Man",
                     creators: CreatorList(items: [CreatorSummary(resourceURI: "uri/1",
                                                                  fullName: "Stan Lee")])),
            ComicDTO(id: 2,
                     title: "Thor",
                     creators: CreatorList(items: [CreatorSummary(resourceURI: "uri/2",
                                                                  fullName: "Jack Kirby")]))
        ])

        let repository = MarvelRepository(service: mockRemote)

        repository.fetchComics { result in
            switch result {
            case .success(let comics):
                XCTAssertEqual(comics.count, 2)
                XCTAssertEqual(comics.first?.title, "Iron Man")
                XCTAssertEqual(comics.first?.creators.first?.fullName, "Stan Lee")
            case .failure:
                XCTFail("Expected success")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    func test_fetchComics_failure_propagatesError() {
        let expectation = expectation(description: "Comics fetch failed")

        let mockRemote = MockRemoteDataSource()
        mockRemote.result = .failure(NSError(domain: "Test", code: 999))

        let repository = MarvelRepository(service: mockRemote)

        repository.fetchComics { result in
            switch result {
            case .success:
                XCTFail("Expected failure")
            case .failure(let error):
                XCTAssertEqual((error as NSError).domain, "Test")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }
}
