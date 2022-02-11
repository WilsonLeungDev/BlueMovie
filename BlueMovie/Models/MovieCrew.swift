//
//  MovieCrew.swift
//  BlueMovie
//
//  Created by Wilson Leung on 5/2/2022.
//

import Foundation

struct MovieCrew: Codable, Identifiable {
    let id: Int
    let job: String
    let name: String
}
