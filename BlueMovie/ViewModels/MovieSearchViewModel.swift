//
//  MovieSearchViewModel.swift
//  BlueMovie
//
//  Created by Wilson Leung on 7/2/2022.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class MovieSearchViewModel: ObservableObject {
    @Published var query: String = ""
    @Published private(set) var phase: DataFetchPhase<[Movie]> = .empty

    private var cancellableSet = Set<AnyCancellable>()
    private let movieService: MovieService

    var trimmedQuery: String {
        query.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var movies: [Movie] {
        phase.value ?? []
    }

    init(movieService: MovieService = MovieStore.shared) {
        self.movieService = movieService
    }

    func startObserve() {
        guard cancellableSet.isEmpty else { return }

        $query
            .filter { $0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            .sink { [weak self] _ in
                self?.phase = .empty
            }
            .store(in: &cancellableSet)

        $query
            .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            .debounce(for: 1, scheduler: DispatchQueue.main)
            .sink { query in
                Task { [weak self] in
                    guard let self = self else { return }
                    await self.search(query: query)
                }
            }
            .store(in: &cancellableSet)
    }

    func search(query: String) async {
        if Task.isCancelled { return }

        phase = .empty

        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedQuery.isEmpty else { return }

        do {
            let movies = try await movieService.searchMovie(query: trimmedQuery)
            if Task.isCancelled { return }
            guard trimmedQuery == self.trimmedQuery else { return }
            phase = .success(movies)
        } catch {
            if Task.isCancelled { return }
            guard trimmedQuery == self.trimmedQuery else { return }
            phase = .failure(error)
        }
    }
}
