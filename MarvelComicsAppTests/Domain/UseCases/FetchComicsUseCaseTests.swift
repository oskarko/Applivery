//
//  FetchComicsUseCaseTests.swift
//  MarvelComicsApp
//
//  Created by Oscar R. Garrucho on 3/8/25.
//

@testable import MarvelComicsApp
import XCTest

// MARK: - FetchComicsUseCaseTests
final class FetchComicsUseCaseTests: XCTestCase {
    
    func test_fetchComics_successfullyGroupsByCreator() {
        // Given
        let creator1 = Creator(_id: "1", fullName: "Stan Lee")
        let creator2 = Creator(_id: "2", fullName: "Jack Kirby")
        let comic1 = Comic(id: 1, title: "Spider-Man", creators: [creator1])
        let comic2 = Comic(id: 2, title: "Hulk", creators: [creator2])
        let comic3 = Comic(id: 3, title: "X-Men", creators: [creator1])

        let mockRepo = MockMarvelRepository()
        mockRepo.comicsToReturn = [comic1, comic2, comic3]

        let useCase = FetchComicsUseCaseImpl(repository: mockRepo)

        // When
        let expectation = self.expectation(description: "Fetch Comics")

        useCase.execute { result in
            switch result {
            case .success(let grouped):
                // Then
                XCTAssertEqual(grouped[creator1]?.count, 2)
                XCTAssertEqual(grouped[creator2]?.count, 1)
            case .failure:
                XCTFail("Should not fail")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    func test_fetchComics_failsWithError() {
        // Given
        let mockRepo = MockMarvelRepository()
        mockRepo.errorToReturn = NSError(domain: "Test", code: 1)

        let useCase = FetchComicsUseCaseImpl(repository: mockRepo)

        // When
        let expectation = self.expectation(description: "Fetch Comics Error")

        useCase.execute { result in
            switch result {
            case .success:
                // Then
                XCTFail("Should have failed")
            case .failure(let error):
                XCTAssertEqual((error as NSError).domain, "Test")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }
}
