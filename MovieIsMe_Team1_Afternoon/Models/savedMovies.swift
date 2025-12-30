//
//  savedMovies.swift
//  MovieIsMe_Team1_Afternoon
//
//  Created by Fay  on 29/12/2025.
//

struct SavedMoviesResponse: Decodable {
    let records: [SavedMovieRecord]
}

struct SavedMovieRecord: Decodable {
    let id: String
    let fields: SavedMovieFields
}

struct SavedMovieFields: Decodable {
    let user_id: String
    let movie_id: [String]
}
