//
//  ComicListViewModelTests.swift
//  MarvelComicsApp
//
//  Created by Oscar R. Garrucho on 3/8/25.
//

import XCTest
@testable import MarvelComicsApp

// MARK: - ComicListViewModelTests
final class ComicListViewModelTests: XCTestCase {

    func test_initialState_isIdle() {
        let mockUseCase = MockFetchComicsUseCase()
        let viewModel = ComicListViewModel(fetchComicsUseCase: mockUseCase)

        XCTAssertEqual(viewModel.state, .idle)
    }

    func test_fetchComics_success_setsLoadedState() {
        let expectation = self.expectation(description: "Comics fetched")

        let creator = Creator(_id: "1", fullName: "Stan Lee")
        let comic = Comic(id: 1, title: "Spider-Man", creators: [creator])

        let mockUseCase = MockFetchComicsUseCase()
        mockUseCase.result = .success([creator: [comic]])

        let viewModel = ComicListViewModel(fetchComicsUseCase: mockUseCase)

        viewModel.fetchComics()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if case .loaded(let grouped) = viewModel.state {
                XCTAssertEqual(grouped[creator]?.count, 1)
            } else {
                XCTFail("Expected loaded state")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    func test_fetchComics_failure_setsErrorState() {
        let expectation = self.expectation(description: "Comics fetch failed")

        let mockUseCase = MockFetchComicsUseCase()
        let errorMessage = "Network error"
        mockUseCase.result = .failure(NSError(domain: errorMessage, code: -1))

        let viewModel = ComicListViewModel(fetchComicsUseCase: mockUseCase)

        viewModel.fetchComics()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if case let .error(message) = viewModel.state {
                XCTAssertTrue(message.contains("Network error"))
            } else {
                XCTFail("Expected error state")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }
}

// MARK: - Equatable extension to test enum state
extension ComicListViewModel.State: Equatable {
    public static func == (lhs: ComicListViewModel.State, rhs: ComicListViewModel.State) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle): return true
        case (.loading, .loading): return true
        case let (.loaded(a), .loaded(b)): return a == b
        case let (.error(a), .error(b)): return a == b
        default: return false
        }
    }
}
