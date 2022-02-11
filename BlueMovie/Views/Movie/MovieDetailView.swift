//
//  MovieDetailView.swift
//  BlueMovie
//
//  Created by Wilson Leung on 4/2/2022.
//

import SwiftUI

struct MovieDetailView: View {
    let movieID: Int
    let movieTitle: String
    @StateObject var movieDetailViewModel = MovieDetailViewModel()
    @State private var selectedTrailerURL: URL?

    var body: some View {
        List {
            if let movie = movieDetailViewModel.movie {
                MovieDetailImageView(imageURL: movie.backdropURL)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .listRowSeparator(.hidden)

                MovieDetailListView(movie: movie, selectedTrailerURL: $selectedTrailerURL)
            }
        }
        .task { loadMovie() }
        .overlay(DataFetchOverlayView(
            phase: movieDetailViewModel.phase
        ) {
            loadMovie()
        })
        .sheet(item: $selectedTrailerURL) {
            SafariView(url: $0)
                .edgesIgnoringSafeArea(.bottom)
        }
        .listStyle(.plain)
        .navigationTitle(movieTitle)
    }

    @Sendable
    private func loadMovie() {
        Task {
            await movieDetailViewModel.loadMovie(id: movieID)
        }
    }
}

struct MovieDetailListView: View {
    let movie: Movie
    @Binding var selectedTrailerURL: URL?

    var body: some View {
        movieDescriptionSection
            .listRowSeparator(.visible)

        movieCastSection
            .listRowSeparator(.hidden)

        movieTrailerSection
    }

    private var movieDescriptionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Capsule()
                    .fill(Color.gray)
                    .frame(width: 100, height: 30)
                    .overlay(
                        Text(movie.genreText)
                            .foregroundColor(.white)
                    )
                Text(movieGenreYearDurationText)
                    .font(.headline)
            }

            
            Text("Overview:")
                .font(.title2)
                .fontWeight(.bold)
            Text(movie.overview)

            HStack {
                if !movie.ratingText.isEmpty {
                    Text(movie.ratingText)
                        .font(.largeTitle)
                        .foregroundColor(.yellow)
                }
                Text(movie.scoreText)
            }
        }
        .padding(.top)
    }
    private var movieGenreYearDurationText: String {
        " | \(movie.yearText) | \(movie.durationText)"
    }

    private var movieCastSection: some View {
        HStack(alignment: .top, spacing: 4) {
            if let cast = movie.cast, !cast.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Starring")
                        .font(.headline)
                    ForEach(cast.prefix(9)) { cast in
                        Text(cast.name)
                    }
                }
                Spacer()
            }

            if let crew = movie.crew, !crew.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    if let directors = movie.directors, !directors.isEmpty {
                        Text("Director(s)")
                            .font(.headline)
                        ForEach(directors.prefix(2)) { crew in
                            Text(crew.name)
                        }
                    }

                    if let producers = movie.producers, !producers.isEmpty {
                        Text("Producer(s)")
                            .font(.headline)
                            .padding(.top)
                        ForEach(producers.prefix(2)) { crew in
                            Text(crew.name)
                        }
                    }

                    if let writers = movie.writers, !writers.isEmpty {
                        Text("Writer(s)")
                            .font(.headline)
                            .padding(.top)
                        ForEach(writers.prefix(2)) { crew in
                            Text(crew.name)
                        }
                    }
                }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.vertical)
    }

    @ViewBuilder
    private var movieTrailerSection: some View {
        if let trailers = movie.youtubeTrailers, !trailers.isEmpty {
            Text("Trailers")
                .font(.title2)
                .fontWeight(.bold)
            ForEach(trailers) { trailer in
                Button(action: {
                    guard let url = trailer.youtubeURL else { return }
                    self.selectedTrailerURL = url
                }) {
                    HStack {
                        Text(trailer.name)
                        Spacer()
                        Image(systemName: "play.circle.fill")
                            .foregroundColor(.red)
                    }
                }
            }
        }
    }
}

struct MovieDetailImageView: View {
    @StateObject private var imageLoader = ImageLoader()
    let imageURL: URL

    var body: some View {
        ZStack {
            Color.gray.opacity(0.3)
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
            }
        }
        .aspectRatio(16/9, contentMode: .fit)
        .onAppear { imageLoader.loadImage(with: imageURL) }
    }
}

extension URL: Identifiable {
    public var id: Self { self }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MovieDetailView(movieID: Movie.stubbedMovie.id, movieTitle: Movie.stubbedMovie.title)
        }
        .preferredColorScheme(.dark)
    }
}
