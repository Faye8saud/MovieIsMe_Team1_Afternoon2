//
//  ReviewViewModel.swift
//  MovieIsMe_Team1_Afternoon
//
//  Created by Hissah Alohali on 12/07/1447 AH.
//
//
//  ReviewViewModel.swift
//  MovieIsMe_Team1_Afternoon
//

import SwiftUI
import Foundation
import Combine


@MainActor
class ReviewViewModel: ObservableObject {

    // MARK: - API Constants
    enum APIConstants {
        static let baseURL = "https://api.airtable.com/v0"
        static let baseID = "appsfcB6YESLj4NCN"
        static let tableName = "reviews"
        static let apiKey = "pat7E88yW3dgzlY61.2b7d03863aca9f1262dcb772f7728bd157e695799b43c7392d5faf4f52fcb001"
    }

    // MARK: - Published Properties
    @Published var reviewText = ""
    @Published var selectedStars = 0
    @Published var reviews: [ReviewRecord] = []
    @Published var errorMessage: String?

    // MARK: - Fetch Reviews for a Movie
    func fetchReviews(movieID: String) {
        Task {
            do {
                reviews = try await getReviews(movieID: movieID)
                print("✅ Reviews fetched:", reviews.count)
            } catch {
                errorMessage = error.localizedDescription
                print("❌ Fetch reviews error:", error)
            }
        }
    }

    private func getReviews(movieID: String) async throws -> [ReviewRecord] {
        let urlString = "\(APIConstants.baseURL)/reviews/\(movieID)"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(APIConstants.apiKey)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let decoded = try JSONDecoder().decode(ReviewResponse.self, from: data)
        return decoded.records
    }

    // MARK: - Submit Review
    func submitReview(movieID: String, userID: String) {
        guard selectedStars > 0, !reviewText.isEmpty else { return }

        let apiRate = selectedStars * 2 // convert 1–5 stars → 1–10 API rate

        Task {
            do {
                try await createReview(reviewText: reviewText, rate: apiRate, movieID: movieID, userID: userID)
                reviewText = ""
                selectedStars = 0
                fetchReviews(movieID: movieID)
                print("✅ Review submitted")
            } catch {
                errorMessage = error.localizedDescription
                print("❌ Submit review error:", error)
            }
        }
    }

    private func createReview(reviewText: String, rate: Int, movieID: String, userID: String) async throws {
        let urlString = "\(APIConstants.baseURL)/review"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(APIConstants.apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "fields": [
                "review_text": reviewText,
                "rate": rate,
                "movie_id": movieID,
                "user_id": userID
            ]
        ]

        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (_, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }

    // MARK: - Delete Review
    func deleteReview(reviewID: String, movieID: String) {
        Task {
            do {
                try await removeReview(reviewID: reviewID)
                fetchReviews(movieID: movieID)
                print("✅ Review deleted")
            } catch {
                errorMessage = error.localizedDescription
                print("❌ Delete review error:", error)
            }
        }
    }

    private func removeReview(reviewID: String) async throws {
        let urlString = "\(APIConstants.baseURL)/review/\(reviewID)"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(APIConstants.apiKey)", forHTTPHeaderField: "Authorization")

        let (_, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }
}
