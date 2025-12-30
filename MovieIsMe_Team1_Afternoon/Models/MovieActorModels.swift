//
//  MovieActorModels.swift
//  MovieIsMe_Team1_Afternoon
//
//  Created by wasan hamoud on 09/07/1447 AH.
//

import Foundation

// MARK: - Response Wrapper
struct MovieActorsResponse: Decodable {
    let records: [MovieActorRecord]
}

// MARK: - Record
struct MovieActorRecord: Decodable, Identifiable {
    let id: String
    let createdTime: String
    let fields: MovieActorFields
}

// MARK: - Fields
struct MovieActorFields: Decodable {
    let movie_id: String
    let actor_id: String
}
