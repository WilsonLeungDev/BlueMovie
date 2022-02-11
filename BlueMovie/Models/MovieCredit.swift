//
//  MovieCredit.swift
//  BlueMovie
//
//  Created by Wilson Leung on 5/2/2022.
//

import Foundation

struct MovieCredit: Codable {
    let cast: [MovieCast]
    let crew: [MovieCrew]
}
