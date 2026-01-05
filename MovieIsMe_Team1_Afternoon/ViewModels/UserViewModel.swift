//
//  UserViewModel.swift
//  MovieIsMe_Team1_Afternoon
//
//  Created by Hissah Alohali on 05/07/1447 AH.
//

import SwiftUI
import Combine
import Foundation
@MainActor


enum SignInError {
    case email
    case password
}


class UserViewModel: ObservableObject {

    // MARK: - Published
    @Published var currentUser: UserRecord?
    @Published var users: [UserRecord] = []
    @Published var errorMessage: String?
    @Published var signInError: SignInError?



    // MARK: - Combine
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init
    init() {
        fetchUsers()
    }

    // MARK: - Fetch Users
    func fetchUsers() {
        guard let url = APIConstants.url(
            for: APIConstants.Tables.users
        ) else {
            print("Invalid users URL")
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
                    print("❌ FETCH USERS ERROR:", error)
                }
            } receiveValue: { records in
                self.users = records
                print("✅ USERS FETCHED:", records.count)
            }
            .store(in: &cancellables)
    }

    // MARK: - Sign In
    func signIn(email: String, password: String) -> Bool {
        let trimmedEmail = email
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        let trimmedPassword = password
            .trimmingCharacters(in: .whitespacesAndNewlines)

        signInError = nil
        errorMessage = nil

        guard let record = users.first(where: {
            $0.fields.email
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .lowercased() == trimmedEmail
        }) else {
            errorMessage = "Email not found"
            signInError = .email
            return false
        }

        if record.fields.password == trimmedPassword {
            SessionManager.saveUserID(record.id)
            currentUser = record
            print("✅ Signed in:", record.fields.name)
            return true
        } else {
            errorMessage = "Password is incorrect"
            signInError = .password
            return false
        }
    }


    func updateUser(recordID: String, user: User) async throws {

        guard let url = APIConstants.recordURL(
            table: APIConstants.Tables.users,
            recordID: recordID
        ) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue(
            "Bearer \(APIConstants.apiKey)",
            forHTTPHeaderField: "Authorization"
        )
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
