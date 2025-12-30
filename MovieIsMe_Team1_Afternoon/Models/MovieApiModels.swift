//
//  MovieApiModels.swift
//  MovieIsMe_Team1_Afternoon
//
//  Created by Fay  on 25/12/2025.
//

import Foundation

struct MoviesResponse: Codable {
    let records: [MovieRecord]
}

struct MovieRecord: Codable, Identifiable {
    let id: String
    let createdTime: String
    let fields: MovieFields
}

struct MovieFields: Codable {
    let name: String
    let poster: String
    let story: String
    let runtime: String
    let genre: [String]
    let rating: String
    let imdbRating: Double
    let language: [String]

    enum CodingKeys: String, CodingKey {
        case name, poster, story, runtime, genre, rating, language
        case imdbRating = "IMDb_rating"
    }
}
struct Actor: Identifiable {
    let id: String
    let name: String
    let imageURL: URL?
}

struct Director: Identifiable {
    let id: String
    let name: String
    let imageURL: URL?
}


//struct MovieFields: Codable {
//    let name: String
//    let poster: String
//    let story: String
//    let runtime: String
//    let genre: [String]
//    let rating: String
//    let IMDb_rating: Double
//    let language: [String]
//}
