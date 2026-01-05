//
//  ReviewViewModel.swift
//  MovieIsMe_Team1_Afternoon
//
//  Created by Hissah Alohali on 12/07/1447 AH.
//

import SwiftUI
import Foundation
import Combine

@MainActor
class ReviewViewModel: ObservableObject {
    
    
    //error handeling
    enum ReviewError: LocalizedError {
        case invalidURL
        case networkError
        case serverError(Int)
        case decodingError
        case missingData
        case emptyReview
        case noRating
        
        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "Invalid request. Please try again."
            case .networkError:
                return "Network connection failed. Check your internet and try again."
            case .serverError(let code):
                return "Server error (\(code)). Please try again later."
            case .decodingError:
                return "Failed to load reviews. Please try again."
            case .missingData:
                return "Required information is missing."
            case .emptyReview:
                return "Please write a review before submitting."
            case .noRating:
                return "Please select a rating."
            }
        }
    }
    
    @Published var reviewText = ""
    @Published var selectedStars = 0
    @Published var reviews: [ReviewRecord] = []
    @Published var errorMessage: String?
    @Published var isLoading = false
    @Published var isSubmitting = false
    
    //GET reviews for a moview
    func fetchReviews(movieID: String) async {
        isLoading = true
        errorMessage = nil
        self.reviews = []
        
        do {
            print("Fetching reviews for movieID:", movieID)
            let fetchedReviews = try await getReviews(movieID: movieID)
            
            var updatedReviews: [ReviewRecord] = []
            for review in fetchedReviews {
                if let userID = review.fields.user_id {
                    do {
                        let userData = try await fetchUser(userID: userID)
                        
                        let updatedFields = ReviewFields(
                            rate: review.fields.rate,
                            review_text: review.fields.review_text,
                            movie_id: review.fields.movie_id,
                            user_id: review.fields.user_id,
                            user_name: userData?.name,
                            user_profile_image: userData?.profile_image
                        )
                        
                        let updatedReview = ReviewRecord(
                            id: review.id,
                            createdTime: review.createdTime,
                            fields: updatedFields
                        )
                        
                        updatedReviews.append(updatedReview)
                    } catch {
                        print("⚠️ Failed to fetch user data for \(userID): \(error.localizedDescription)")
                        // Add review without user data instead of failing completely
                        updatedReviews.append(review)
                    }
                } else {
                    updatedReviews.append(review)
                }
            }
            
            self.reviews = updatedReviews
            print("✅ Reviews fetched: \(reviews.count)")
        } catch let error as ReviewError {
            errorMessage = error.errorDescription
            print("❌ Fetch reviews error:", error.localizedDescription)
        } catch {
            errorMessage = "Failed to load reviews. Please try again."
            print("❌ Unexpected error:", error)
        }
        
        isLoading = false
    }
    //private helper function: Get reviews from API
    private func getReviews(movieID: String) async throws -> [ReviewRecord] {
        // Get the base table URL
        guard var urlComponents = URLComponents(url: APIConstants.url(for: APIConstants.Tables.reviews) ?? URL(string: "")!, resolvingAgainstBaseURL: false) else {
            throw ReviewError.invalidURL
        }

        // filter query
        urlComponents.queryItems = [
            URLQueryItem(name: "filterByFormula", value: "{movie_id}=\"\(movieID)\"")
        ]

        // Get the final URL
        guard let url = urlComponents.url else {
            throw ReviewError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(APIConstants.apiKey)", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 30
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ReviewError.networkError
        }
        
        guard httpResponse.statusCode == 200 else {
            throw ReviewError.serverError(httpResponse.statusCode)
        }
        
        do {
            let decoded = try JSONDecoder().decode(ReviewResponse.self, from: data)
            return decoded.records
        } catch {
            print("❌ Decoding error:", error)
            throw ReviewError.decodingError
        }
    }
    //private helper function to fetch user of a review
    private func fetchUser(userID: String) async throws -> UserData? {
        let urlString = "\(APIConstants.baseURL)/\(APIConstants.baseID)/Users/\(userID)"
        
        guard let url = URL(string: urlString) else {
            throw ReviewError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(APIConstants.apiKey)", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 30
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return nil
            }
            
            guard httpResponse.statusCode == 200 else {
                print("⚠️ User fetch failed with status: \(httpResponse.statusCode)")
                return nil
            }
            
            let decoded = try JSONDecoder().decode(ReviewUser.self, from: data)
            return UserData(name: decoded.fields.name, profile_image: decoded.fields.profile_image)
        } catch {
            print("⚠️ Failed to fetch user: \(error.localizedDescription)")
            return nil
        }
    }
    //POST review
    func submitReview(movieID: String, userID: String) async {
           guard selectedStars > 0, !reviewText.isEmpty else { return }
           let apiRate = selectedStars * 2
           do {
               try await createReview(reviewText: reviewText, rate: apiRate, movieID: movieID, userID: userID)
               reviewText = ""
               selectedStars = 0
               await fetchReviews(movieID: movieID)
               print("✅ Review submitted")
           } catch {
               errorMessage = error.localizedDescription
               print("❌ Submit review error:", error)
           }
       }
    //private helper fucntion: handles POST request logic
       private func createReview(reviewText: String, rate: Int, movieID: String, userID: String) async throws {
           guard let url = APIConstants.url(for: APIConstants.Tables.reviews) else {
               throw URLError(.badURL)
           }

           var request = URLRequest(url: url)
           request.httpMethod = "POST"
           request.setValue("Bearer \(APIConstants.apiKey)", forHTTPHeaderField: "Authorization")
           request.setValue("application/json", forHTTPHeaderField: "Content-Type")
           let body: [String: Any] = [
               "fields": [
                   "review_text": reviewText,
                   "rate": rate,
                   "movie_id": movieID,    // Changed from [movieID] to movieID
                   "user_id": userID       // Changed from [userID] to userID
               ]
           ]
           request.httpBody = try JSONSerialization.data(withJSONObject: body)
           let (_, response) = try await URLSession.shared.data(for: request)
           guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
               throw URLError(.badServerResponse)
           }
       }
    
    //DEL review
    func deleteReview(reviewID: String, movieID: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await removeReview(reviewID: reviewID)
            await fetchReviews(movieID: movieID)
            print("✅ Review deleted successfully")
        } catch let error as ReviewError {
            errorMessage = error.errorDescription
            print("❌ Delete review error:", error)
        } catch {
            errorMessage = "Failed to delete review. Please try again."
            print("❌ Unexpected error:", error)
        }
        
        isLoading = false
    }
    //private helper fucntion
    private func removeReview(reviewID: String) async throws {
        guard let url = APIConstants.recordURL(table: APIConstants.Tables.reviews, recordID: reviewID) else {
            throw ReviewError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(APIConstants.apiKey)", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 30
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ReviewError.networkError
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw ReviewError.serverError(httpResponse.statusCode)
        }
    }
}
