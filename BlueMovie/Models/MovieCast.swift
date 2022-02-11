//
//  MovieCast.swift
//  BlueMovie
//
//  Created by Wilson Leung on 5/2/2022.
//

import Foundation

struct MovieCast: Codable, Identifiable {
    let id: Int
    let character: String
    let name: String
}
