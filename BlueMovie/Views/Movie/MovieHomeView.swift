//
//  MovieHomeView.swift
//  BlueMovie
//
//  Created by Wilson Leung on 3/2/2022.
//

import SwiftUI

struct MovieHomeView: View {
    @StateObject private var movieHomeViewModel = MovieHomeViewModel()

    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.black]
        
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        List {
            ForEach(movieHomeViewModel.sections) {
                MovieThumbnailCarouselView(
                    title: $0.title,
                    movies: $0.movies,
                    thumbnailType: $0.thumbnailType
                )
                    .listRowInsets(.init(top: 8, leading: 0, bottom: 8, trailing: 0))
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
            }
        }
        .task { loadMovies(invalidateCache: false) }
        .refreshable { loadMovies(invalidateCache: true) }
        .overlay(DataFetchOverlayView(
            phase: movieHomeViewModel.phase
        ) {
            loadMovies(invalidateCache: true)
        })
        .listStyle(.plain)
        .navigationTitle("Blue Movie")
        .gradientBackground()
    }

    @Sendable
    private func loadMovies(invalidateCache: Bool) {
        Task {
            await movieHomeViewModel.loadMoviesFromAllEndpoints(invalidateCache: invalidateCache)
        }
    }
}

struct MovieHomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MovieHomeView()
        }
        .preferredColorScheme(.dark)
    }
}
