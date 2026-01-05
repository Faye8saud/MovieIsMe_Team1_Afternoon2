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

        guard let url = APIConstants.url(for: APIConstants.Tables.movies) else {
            print("Invalid movies URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(
            "Bearer \(APIConstants.apiKey)",
            forHTTPHeaderField: "Authorization"
        )

        do {
            let (data, _) = try await URLSession.shared.data(for: request)

            let response = try JSONDecoder().decode(MoviesResponse.self, from: data)

            heroMovies = response.records.map { record in
                CarouselItem(
                    id: record.id,
                    imageName: record.fields.poster,
                    title: record.fields.name,
                    rating: record.fields.imdbRating / 2,
                    genre: record.fields.genre.first ?? "Unknown",
                    duration: record.fields.runtime
                )
            }

        } catch {
            print("❌ Movie fetch error:", error)
        }
    }
}

    // genre filtering 
extension MovieViewModel {

    var dramaCarouselItems: [CarouselItem] {
        heroMovies.filter {
            $0.genre.lowercased() == "drama"
        }
    }

    var comedyCarouselItems: [CarouselItem] {
        heroMovies.filter {
            $0.genre.lowercased() == "comedy"
        }
    }
}


//search extension
extension MovieViewModel {

    func searchResults(for query: String) -> [CarouselItem] {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return []
        }

        let lowercasedQuery = query.lowercased()

        return heroMovies.filter {
            $0.title.lowercased().contains(lowercasedQuery)
        }
    }
}
extension CarouselItem {
    func toRecord() -> MovieRecord {
        MovieRecord(
            id: self.id,
            createdTime: "",
            fields: MovieFields(
                name: self.title,
                poster: self.imageName,
                story: "",
                runtime: self.duration,
                genre: [self.genre],
                rating: "",
                imdbRating: self.rating * 2,
                language: []
            )
        )
    }
}


