//
//  ComicListView.swift
//  MarvelComicsApp
//
//  Created by Oscar R. Garrucho on 3/8/25.
//

import SwiftUI

// MARK: - ComicListView
struct ComicListView: View {
    @ObservedObject var viewModel: ComicListViewModel

    var body: some View {
        NavigationView {
            content
                .navigationTitle("Marvel Comics")
                .onAppear(perform: viewModel.fetchComics)
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView("Loading comics...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .loaded(let groupedComics):
            List {
                ForEach(groupedComics.keys.sorted(by: { $0.fullName < $1.fullName }),
                        id: \.id) { creator in
                    Section(header: Text(creator.fullName)) {
                        ForEach(groupedComics[creator] ?? []) { comic in
                            NavigationLink(destination: ComicDetailView(comic: comic)) {
                                Text(comic.title)
                            }
                        }
                    }
                }
            }
        case .error(let message):
            VStack(spacing: 12) {
                Text("Failed to load comics")
                    .font(.headline)
                Text(message)
                    .foregroundColor(.secondary)
                Button("Retry") {
                    viewModel.fetchComics()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
