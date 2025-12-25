//
//  MovieViewModel.swift
//  MovieIsMe_Team1_Afternoon
//
//  Created by Fay  on 25/12/2025.
//
import SwiftUI
import Combine

@MainActor

class MovieViewModel: ObservableObject {
    @Published var heroMovies: [CarouselItem] = []
    @Published var isLoading = false

    func fetchMovies() async {
        isLoading = true
        defer { isLoading = false }

        guard let url = URL(string: "") else { return }

        var request = URLRequest(url: url)
        request.setValue("Bearer", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            print(String(data: data, encoding: .utf8)!)

            let response = try JSONDecoder().decode(MoviesResponse.self, from: data)

            heroMovies = response.records.map { record in
                CarouselItem(
                    imageName: record.fields.poster,
                    title: record.fields.name,
                    rating: record.fields.IMDb_rating / 2, // convert 10 → 5 scale
                    genre: record.fields.genre.first ?? "Unknown",
                    duration: record.fields.runtime
                )
            }
        } catch {
            print("API Error:", error)
        }
    }
}
