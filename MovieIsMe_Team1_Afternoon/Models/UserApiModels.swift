//
//  UserApiModels.swift
//  MovieIsMe_Team1_Afternoon
//
//  Created by Hissah Alohali on 05/07/1447 AH.
//

import Foundation

struct UserResponse: Codable {
    let records: [UserRecord]
}

struct UserRecord: Codable, Identifiable {
    let id: String
    let createdTime: String
    let fields: User
}

struct User: Codable {
    let name: String
    let password: String
    let email: String
    let profile_image: String
}


