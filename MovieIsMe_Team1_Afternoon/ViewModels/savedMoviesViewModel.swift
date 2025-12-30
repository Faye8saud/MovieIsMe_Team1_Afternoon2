//
//  savedMoviesViewModel.swift
//  MovieIsMe_Team1_Afternoon
//
//  Created by Fay  on 29/12/2025.
//
import SwiftUI
import Combine

@MainActor
class SavedMoviesViewModel: ObservableObject {
    @Published var savedMovieIDs: [String] = []
    @Published var isLoading = false

    func fetchSavedMovies() async {
        guard let userID = SessionManager.getUserID() else {
            print("❌ No userID found")
            return
        }

        isLoading = true
        defer { isLoading = false }

        let urlString =
        "https://api.airtable.com/v0/appsfcB6YESLj4NCN/saved_movies" +
        "?filterByFormula=user_id=\"\(userID)\""

        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.setValue(
            "Bearer \(APIConstants.apiKey)",
            forHTTPHeaderField: "Authorization"
        )

        do {
            let (data, _) = try await URLSession.shared.data(for: request)

            let response = try JSONDecoder().decode(
                SavedMoviesResponse.self,
                from: data
            )

            // extract movie IDs
            self.savedMovieIDs = response.records.flatMap {
                $0.fields.movie_id
            }

            print("✅ Saved movie IDs for user:", savedMovieIDs)

        } catch {
            print("❌ Saved movies fetch error:", error)
        }
    }
}
