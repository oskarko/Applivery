//
//  ComicListViewModel.swift
//  MarvelComicsApp
//
//  Created by Oscar R. Garrucho on 3/8/25.
//

import Foundation

// MARK: - ComicListViewModel
final class ComicListViewModel: ObservableObject {
    enum State {
        case idle
        case loading
        case loaded([Creator: [Comic]])
        case error(String)
    }

    @Published private(set) var state: State = .idle

    private let fetchComicsUseCase: FetchComicsUseCase

    init(fetchComicsUseCase: FetchComicsUseCase) {
        self.fetchComicsUseCase = fetchComicsUseCase
    }

    func fetchComics() {
        state = .loading
        fetchComicsUseCase.execute { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let grouped):
                    self?.state = .loaded(grouped)
                case .failure(let error):
                    self?.state = .error(error.localizedDescription)
                }
            }
        }
    }
}
