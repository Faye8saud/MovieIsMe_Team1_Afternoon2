//
//  APIConstants.swift
//  MovieIsMe_Team1_Afternoon
//
//  Created by Fay  on 05/01/2026.
//

import Foundation

enum APIConstants {
    static let baseURL = "https://api.airtable.com/v0"
    static let baseID = "appsfcB6YESLj4NCN"
    static let apiKey = "patHXtgI1qrXTZwz3.a455bfcc1a171662a512c7890954a8f4335f00601ea5d14d425baa3baa2d53c0"

    enum Tables {
        static let users = "users"
        static let movies = "movies"
        static let savedMovies = "saved_movies"
    }

    static func url(for table: String) -> URL? {
        URL(string: "\(baseURL)/\(baseID)/\(table)")
    }

    static func recordURL(table: String, recordID: String) -> URL? {
        URL(string: "\(baseURL)/\(baseID)/\(table)/\(recordID)")
    }
}
