//
//  Movie.swift
//  BlueMovie
//
//  Created by Wilson Leung on 30/1/2022.
//

import Foundation

struct MovieResponse: Codable {
    let results: [Movie]
}

struct Movie: Codable, Identifiable {
    let id: Int
    let title: String
    let backdropPath: String?
    let posterPath: String?
    let overview: String
    let voteAverage: Double
    let voteCount: Int
    let runtime: Int?
    let releaseDate: String?

    let genres: [MovieGenre]?
    let credits: MovieCredit?
    let videos: MovieVideoResponse?

    var backdropURL: URL {
        URL(string: "https://image.tmdb.org/t/p/w500\(backdropPath ?? "")")!
    }

    var posterURL: URL {
        URL(string: "https://image.tmdb.org/t/p/w500\(posterPath ?? "")")!
    }

    var genreText: String {
        genres?.first?.name ?? "n/a"
    }

    var ratingText: String {
        let rating = Int(voteAverage)
        let ratingText = (0..<rating).reduce("") { (acc, _) -> String in
            acc + "*"
        }
        return ratingText
    }

    var scoreText: String {
        guard ratingText.count > 0 else {
            return "n/a"
        }
        return "\(ratingText.count)/10"
    }

    var yearText: String {
        guard let releaseDate = releaseDate,
              let date = Utils.dateFormatter.date(from: releaseDate) else {
            return "n/a"
        }
        return Utils.yearFormatter.string(from: date)
    }

    var durationText: String {
        guard let runtime = runtime, runtime > 0 else {
            return "n/a"
        }
        return Utils.durationFormatter.string(from: TimeInterval(runtime) * 60) ?? "n/a"
    }

    var cast: [MovieCast]? {
        credits?.cast
    }

    var crew: [MovieCrew]? {
        credits?.crew
    }
    var directors: [MovieCrew]? {
        crew?.filter { $0.job.lowercased() == "director" }
    }
    var producers: [MovieCrew]? {
        crew?.filter { $0.job.lowercased() == "producer" }
    }
    var writers: [MovieCrew]? {
        crew?.filter { $0.job.lowercased() == "story" }
    }

    var youtubeTrailers: [MovieVideo]? {
        videos?.results.filter { $0.youtubeURL != nil }
    }
}

struct MovieGenre: Codable {
    let name: String
}

// MARK: Movie Trailer
struct MovieVideoResponse: Codable {
    let results: [MovieVideo]
}
struct MovieVideo: Codable, Identifiable {
    let id: String
    let key: String
    let name: String
    let site: String

    var youtubeURL: URL? {
        guard site == "YouTube" else {
            return nil
        }
        return URL(string: "https://youtube.com/watch?v=\(key)")
    }
}
