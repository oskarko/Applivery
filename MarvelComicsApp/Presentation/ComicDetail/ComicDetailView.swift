//
//  ComicDetailView.swift
//  MarvelComicsApp
//
//  Created by Oscar R. Garrucho on 3/8/25.
//

import SwiftUI

// MARK: - ComicDetailView
struct ComicDetailView: View {
    let comic: Comic

    var body: some View {
        VStack(spacing: 20) {
            Text(comic.title)
                .font(.title)

            if comic.creators.isEmpty {
                Text("No creators listed")
                    .foregroundColor(.secondary)
            } else {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Created by:")
                        .font(.headline)
                    ForEach(comic.creators, id: \._id) { creator in
                        Text(creator.fullName)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding()
    }
}

