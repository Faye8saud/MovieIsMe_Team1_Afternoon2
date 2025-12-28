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
    var fields: User
}

struct User: Codable {
    var name: String
    var password: String
    var email: String
    var profile_image: String
}

extension User {

    var firstName: String {
        name.components(separatedBy: " ").first ?? ""
    }

    var lastName: String {
        name.components(separatedBy: " ").dropFirst().joined(separator: " ")
    }

    mutating func updateName(firstName: String, lastName: String) {
        self.name = "\(firstName) \(lastName)"
    }
}


