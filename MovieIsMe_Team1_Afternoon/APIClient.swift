//
//  APIClient.swift
//  MovieIsMe_Team1_Afternoon
//
//  Created by wasan hamoud on 09/07/1447 AH.
//

//import Foundation
//
//final class APIClient {
//
//    static let shared = APIClient()
//
//    private init() {}
//
//    private let baseURL = "https://api.airtable.com/v0"
//    private let baseId = "appsfcB6YESLj4NCN"
////    private let token = "PUT_YOUR_TOKEN_HERE" // ← توكن Airtable
//    private let token = "patHXtgI1qrXTZwz3.a455bfcc1a171662a512c7890954a8f4335f00601ea5d14d425baa3baa2d53c0"
//
//
//    func fetch<T: Decodable>(
//        _ table: String,
//        queryItems: [URLQueryItem] = []
//    ) async throws -> T {
//
//        var url = URL(string: "\(baseURL)/\(baseId)/\(table)")!
//
//        if !queryItems.isEmpty {
//            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
//            components?.queryItems = queryItems
//            if let newURL = components?.url {
//                url = newURL
//            }
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//
//        let (data, response) = try await URLSession.shared.data(for: request)
//
//        guard let httpResponse = response as? HTTPURLResponse,
//              (200...299).contains(httpResponse.statusCode) else {
//            throw URLError(.badServerResponse)
//        }
//
//        return try JSONDecoder().decode(T.self, from: data)
//    }
//}
import Foundation

final class APIClient {

    static let shared = APIClient()

    private init() {}

    private let baseURL = "https://api.airtable.com/v0"
    private let baseId = "appsfcB6YESLj4NCN"
    private let token = "patHXtgI1qrXTZwz3.a455bfcc1a171662a512c7890954a8f4335f00601ea5d14d425baa3baa2d53c0" // ← توكن Airtable

    func fetch<T: Decodable>(
        _ table: String,
        queryItems: [URLQueryItem] = []
    ) async throws -> T {

        var url = URL(string: "\(baseURL)/\(baseId)/\(table)")!

        if !queryItems.isEmpty {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.queryItems = queryItems
            if let newURL = components?.url {
                url = newURL
            }
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(T.self, from: data)
    }
}
extension APIClient {
    func fetchRecord<T: Decodable>(table: String, recordId: String) async throws -> T {
        let url = URL(string: "\(baseURL)/\(baseId)/\(table)/\(recordId)")!

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(T.self, from: data)
    }
}
