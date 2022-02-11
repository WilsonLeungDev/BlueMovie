//
//  MovieSearchView.swift
//  BlueMovie
//
//  Created by Wilson Leung on 5/2/2022.
//

import SwiftUI

struct MovieSearchView: View {
    @StateObject var movieSearchViewModel = MovieSearchViewModel()

    var body: some View {
        List {
            ForEach(movieSearchViewModel.movies) { movie in
                NavigationLink(destination: MovieDetailView(movieID: movie.id, movieTitle: movie.title)) {
                    MovieRowView(movie: movie)
                        .padding(.vertical)
                }
            }
        }
        .searchable(text: $movieSearchViewModel.query, prompt: "Search Movies")
        .overlay(overlayView)
        .onAppear { movieSearchViewModel.startObserve() }
        .listStyle(.plain)
        .navigationTitle("Search")
//        .gradientBackground()
    }

    @ViewBuilder
    private var overlayView: some View {
        switch movieSearchViewModel.phase {
        case .empty:
            if movieSearchViewModel.trimmedQuery.isEmpty {
                EmptyPlaceholderView(text: "Search Movie", image: Image(systemName: "magnifyingglass"))
            } else {
                ProgressView()
            }
        case .success(let values) where values.isEmpty:
            EmptyPlaceholderView(text: "No Results", image: Image(systemName: "film"))
        case .failure(let error):
            RetryView(text: error.localizedDescription) {
                Task {
                    await movieSearchViewModel.search(query: movieSearchViewModel.query)
                }
            }
        default:
            EmptyView()
        }
    }
}

struct MovieRowView: View {
    let movie: Movie

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            MovieThumbnailView(movie: movie, thumbnailType: .poster(showTitle: false))
                .frame(width: 61, height: 92)

            VStack(alignment: .leading) {
                Text(movie.title)
                    .font(.headline)

                Text(movie.yearText)
                    .font(.subheadline)

                Spacer()

                Text(movie.ratingText)
                    .foregroundColor(.yellow)
                    .font(.subheadline)
            }
        }
    }

}

struct MovieSearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MovieSearchView()
        }
    }
}
