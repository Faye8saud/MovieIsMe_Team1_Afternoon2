//
//  ReviewApiModels.swift
//  MovieIsMe_Team1_Afternoon
//
//  Created by Hissah Alohali on 12/07/1447 AH.
//

import Foundation

struct ReviewRecord: Identifiable, Decodable {
    let id: String
    let fields: ReviewFields
    let createdTime: String
}

struct ReviewFields: Decodable {
    let review_text: String
    let rate: Int
    let movie_id: String
    let user_id: String
    
    // joined user fields (if expanded)
    let user_name: String?
    let user_profile_image: String?
}

struct ReviewResponse: Decodable {
    let records: [ReviewRecord]
}
