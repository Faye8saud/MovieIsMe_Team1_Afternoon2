//
//  ReviewApiModels.swift
//  MovieIsMe_Team1_Afternoon
//
//  Created by Hissah Alohali on 12/07/1447 AH.
//

import Foundation

struct ReviewRecord: Identifiable, Decodable {
    let id: String
    let createdTime: String
    let fields: ReviewFields
}

struct ReviewFields: Decodable {
    let rate: Int
    let review_text: String
    let movie_id: String?
    let user_id: String?
    
    var user_name: String?
    var user_profile_image: String?
    
    init(rate: Int, review_text: String, movie_id: String?, user_id: String?, user_name: String? = nil, user_profile_image: String? = nil) {
        self.rate = rate
        self.review_text = review_text
        self.movie_id = movie_id
        self.user_id = user_id
        self.user_name = user_name
        self.user_profile_image = user_profile_image
    }
}

struct ReviewResponse: Decodable {
    let records: [ReviewRecord]
}

struct ReviewUser: Decodable {
    let fields: UserFields
}

struct UserFields: Decodable {
    let name: String?
    let profile_image: String?
}

struct UserData {
    let name: String?
    let profile_image: String?
}
