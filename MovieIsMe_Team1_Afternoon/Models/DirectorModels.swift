//
//  DirectorModels.swift
//  MovieIsMe_Team1_Afternoon
//
//  Created by wasan hamoud on 09/07/1447 AH.
//

import Foundation

// MARK: - Directors Response Wrapper
struct DirectorsResponse: Decodable {
    let records: [DirectorRecord]
}

// MARK: - Director Record
struct DirectorRecord: Decodable, Identifiable {
    let id: String
    let createdTime: String
    let fields: DirectorFields
}

// MARK: - Director Fields
struct DirectorFields: Decodable {
    let name: String
    let image: String
}
