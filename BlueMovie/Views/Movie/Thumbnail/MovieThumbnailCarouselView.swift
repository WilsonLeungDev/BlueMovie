//
//  MovieThumbnailCarouselView.swift
//  BlueMovie
//
//  Created by Wilson Leung on 3/2/2022.
//

import SwiftUI

struct MovieThumbnailCarouselView: View {
    let title: String
    let movies: [Movie]
    var thumbnailType: MovieThumbnailType = .poster()

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .top, spacing: 16) {
                    ForEach(movies) { movie in
                        NavigationLink(destination: MovieDetailView(movieID: movie.id, movieTitle: movie.title)) {
                            MovieThumbnailView(movie: movie, thumbnailType: thumbnailType)
                                .movieThumbnailViewFrame(thumbnailType: thumbnailType)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
        }
    }
}

fileprivate extension View {
    @ViewBuilder
    func movieThumbnailViewFrame(thumbnailType: MovieThumbnailType) -> some View {
        switch thumbnailType {
        case .poster:
            self.frame(width: 204, height: 306)
        case .backdrop:
            self
                .aspectRatio(16/9, contentMode: .fit)
                .frame(height: 160)
        }
    }
}

struct MovieThumbnailCarouselView_Previews: PreviewProvider {
    static let stubbedMovies = Movie.stubbedMovies
    static var previews: some View {
        Group {
            MovieThumbnailCarouselView(title: "Now Playing", movies: Movie.stubbedMovies, thumbnailType: .poster(showTitle: true))
            
            MovieThumbnailCarouselView(title: "Upcoming", movies: Movie.stubbedMovies, thumbnailType: .backdrop)
        }
        
    }
}
