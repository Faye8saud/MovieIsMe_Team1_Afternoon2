//
//  MovieDirectorModels.swift
//  MovieIsMe_Team1_Afternoon
//
//  Created by wasan hamoud on 09/07/1447 AH.
//

import Foundation

// MARK: - Response Wrapper
struct MovieDirectorsResponse: Decodable {
    let records: [MovieDirectorRecord]
}

// MARK: - Record
struct MovieDirectorRecord: Decodable, Identifiable {
    let id: String
    let createdTime: String
    let fields: MovieDirectorFields
}

// MARK: - Fields
struct MovieDirectorFields: Decodable {
    let movie_id: String
    let director_id: String
}
