//
//  MovieViewModel.swift
//  MovieIsMe_Team1_Afternoon
//
//  Created by Fay  on 25/12/2025.
//
//import SwiftUI
//import Combine
//
//@MainActor
//
//class MovieViewModel: ObservableObject {
//    @Published var heroMovies: [CarouselItem] = []
//    @Published var isLoading = false
//
//    func fetchMovies() async {
//        isLoading = true
//        defer { isLoading = false }
//
//        guard let url = URL(string: "") else { return }
//
//        var request = URLRequest(url: url)
//        request.setValue("Bearer", forHTTPHeaderField: "Authorization")
//        request.httpMethod = "GET"
//
//        do {
//            let (data, _) = try await URLSession.shared.data(for: request)
//            print(String(data: data, encoding: .utf8)!)
//
//            let response = try JSONDecoder().decode(MoviesResponse.self, from: data)
//
//            heroMovies = response.records.map { record in
//                CarouselItem(
//                    imageName: record.fields.poster,
//                    title: record.fields.name,
//                    rating: record.fields.IMDb_rating / 2, // convert 10 → 5 scale
//                    genre: record.fields.genre.first ?? "Unknown",
//                    duration: record.fields.runtime
//                )
//            }
//        } catch {
//            print("API Error:", error)
//        }
//    }
//}
import SwiftUI
import Combine

@MainActor
class MovieViewModel: ObservableObject {
    @Published var heroMovies: [CarouselItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    // عدّلي التوكن هنا
    private let token = "patYOUR_TOKEN_HERE"
    private let baseId = "appsfcB6YESLj4NCN"

    func fetchMovies() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        // رابط movies في Airtable
        guard let url = URL(string: "https://api.airtable.com/v0/\(baseId)/movies") else {
            errorMessage = "Invalid URL"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
                let body = String(data: data, encoding: .utf8) ?? ""
                errorMessage = "HTTP \(http.statusCode): \(body)"
                return
            }

            let decoded = try JSONDecoder().decode(MoviesResponse.self, from: data)

            heroMovies = decoded.records.map { record in
                CarouselItem(
                    imageName: record.fields.poster,
                    title: record.fields.name,
                    rating: record.fields.imdbRating / 2, // 10 → 5
                    genre: record.fields.genre.first ?? "Unknown",
                    duration: record.fields.runtime
                )
            }

        } catch {
            errorMessage = error.localizedDescription
            print("API Error:", error)
        }
    }
}
