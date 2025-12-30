//
//  ActorModels.swift
//  MovieIsMe_Team1_Afternoon
//
//  Created by wasan hamoud on 09/07/1447 AH.
//

import Foundation

struct ActorsResponse: Decodable {
    let records: [ActorRecord]
}

struct ActorRecord: Decodable, Identifiable {
    let id: String
    let createdTime: String
    let fields: ActorFields
}

struct ActorFields: Decodable {
    let name: String
    let image: String
}
