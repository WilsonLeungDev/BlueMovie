//
//  MovieDetailViewModel.swift
//  BlueMovie
//
//  Created by Wilson Leung on 4/2/2022.
//

import SwiftUI

@MainActor
class MovieDetailViewModel: ObservableObject {
    private let movieService: MovieService
    @Published private(set) var phase: DataFetchPhase<Movie?> = .empty
    var movie: Movie? {
        phase.value ?? nil
    }

    init(movieService: MovieService = MovieStore.shared) {
        self.movieService = movieService
    }

    func loadMovie(id: Int) async {
        if Task.isCancelled { return }

        phase = .empty

        do {
            let movie = try await movieService.fetchMovie(id: id)
            phase = .success(movie)
        } catch {
            phase = .failure(error)
        }
    }
}
