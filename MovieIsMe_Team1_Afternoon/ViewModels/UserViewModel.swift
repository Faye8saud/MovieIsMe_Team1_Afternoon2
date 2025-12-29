//
//  UserViewModel.swift
//  MovieIsMe_Team1_Afternoon
//
//  Created by Hissah Alohali on 05/07/1447 AH.
//

import SwiftUI
import Combine

@MainActor

enum APIConstants {
    static let baseURL = "https://api.airtable.com/v0"
    static let baseID = "appsfcB6YESLj4NCN"
    static let tableName = "users"
    static let apiKey = "pat7E88yW3dgzlY61.2b7d03863aca9f1262dcb772f7728bd157e695799b43c7392d5faf4f52fcb001"
}

import Foundation
import Combine

@MainActor
class UserViewModel: ObservableObject {

    // MARK: - Published
    @Published var currentUser: UserRecord?
    @Published var users: [UserRecord] = []
    @Published var errorMessage: String?

    // MARK: - Combine
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init
    init() {
        fetchUsers()
    }

    // MARK: - Fetch Users
    func fetchUsers() {
        guard let url = URL(string:
            "\(APIConstants.baseURL)/\(APIConstants.baseID)/\(APIConstants.tableName)"
        ) else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.setValue(
            "Bearer \(APIConstants.apiKey)",
            forHTTPHeaderField: "Authorization"
        )

        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: UserResponse.self, decoder: JSONDecoder())
            .map { $0.records }
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    self.errorMessage = error.localizedDescription
                    print("FETCH ERROR:", error)
                }
            } receiveValue: { records in
                self.users = records
                print("USERS FETCHED:", records.count)
            }
            .store(in: &cancellables)
    }

    // MARK: - Sign In
    func signIn(email: String, password: String) -> Bool {

        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)

        guard let record = users.first(where: {$0.fields.email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == trimmedEmail
        }) else {
            errorMessage = "Email not found"
            return false
        }

        if record.fields.password == trimmedPassword {
            SessionManager.saveUserID(record.id) //saves userID
            currentUser = record
            print("✅ Signed in:", record.fields.name)
           
            return true
        } else {
            errorMessage = "Password is incorrect"
            return false
        }
    }

    func updateUser(recordID: String,user: User) async throws {

        let urlString =
            "\(APIConstants.baseURL)/\(APIConstants.baseID)/\(APIConstants.tableName)/\(recordID)"

        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("Bearer \(APIConstants.apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "fields": [
                "name": user.name,
                "email": user.email,
                "password": user.password,
                "profile_image": user.profile_image
            ]
        ]

        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }


    // MARK: - Update Profile
    func updateProfile( firstName: String, lastName: String, profileImageURL: String? = nil) {
        guard var record = currentUser else { return }

        // Update local model
        record.fields.name = "\(firstName) \(lastName)"

        if let imageURL = profileImageURL {
            record.fields.profile_image = imageURL
        }

        currentUser = record   // ✅ UI updates immediately

        Task {
            do {
                try await updateUser(
                    recordID: record.id,
                    user: record.fields
                )
                print("✅ User updated with PUT")
            } catch {
                print("❌ Failed to update user:", error)
            }
        }
    }
    
    func signOut() {
        currentUser = nil
        SessionManager.clear()
    }

}
