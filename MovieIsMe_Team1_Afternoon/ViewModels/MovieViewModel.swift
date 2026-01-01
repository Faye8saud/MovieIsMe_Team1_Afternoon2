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
        
        guard let url = URL(string: "https://api.airtable.com/v0/appsfcB6YESLj4NCN/movies") else { return }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer patHXtgI1qrXTZwz3.a455bfcc1a171662a512c7890954a8f4335f00601ea5d14d425baa3baa2d53c0", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            print(String(data: data, encoding: .utf8)!)
            
            let response = try JSONDecoder().decode(MoviesResponse.self, from: data)
            
          
            heroMovies = response.records.map { record in
                CarouselItem(
                    id: record.id,              // ✅ ADD THIS
                    imageName: record.fields.poster,
                    title: record.fields.name,
//                    rating: record.fields.IMDb_rating / 2,
                    rating: record.fields.imdbRating / 2,
                    genre: record.fields.genre.first ?? "Unknown",
                    duration: record.fields.runtime
                )
            }
        } catch {
            print("API Error:", error)
        }
    }
    
}
    // MARK: - Genre-based computed properties
    extension MovieViewModel {
        var dramaMovies: [Movie] {
            heroMovies
                .filter { $0.genre.lowercased() == "drama" }
                .map { CarouselItemToMovie($0) }
        }

        var comedyMovies: [Movie] {
            heroMovies
                .filter { $0.genre.lowercased() == "comedy" }
                .map { CarouselItemToMovie($0) }
        }

        private func CarouselItemToMovie(_ item: CarouselItem) -> Movie {
            Movie(title: item.title, posterName: item.imageName)
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


