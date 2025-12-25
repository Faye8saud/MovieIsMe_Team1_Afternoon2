//
//  UserViewModel.swift
//  MovieIsMe_Team1_Afternoon
//
//  Created by Hissah Alohali on 05/07/1447 AH.
//

import SwiftUI
import Combine

@MainActor

class UserViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var users: [User] = []
    @Published var errorMessage: String?
    
    
    init() {
           fetchUsers()
       }
    private var cancellables = Set<AnyCancellable>()
    
    func fetchUsers() {
        guard let url = URL(string: "https://api.airtable.com/v0/appsfcB6YESLj4NCN/users") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer pat7E88yW3dgzlY61.2b7d03863aca9f1262dcb772f7728bd157e695799b43c7392d5faf4f52fcb001", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: UserResponse.self, decoder: JSONDecoder())
            .map { response in
                response.records.map { $0.fields }
            }
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print("Error fetching users: \(error)")
                case .finished:
                    break
                }
           }
                receiveValue: { users in
                self.users = users
                print("✅ Users fetched successfully:")
//                for user in users {
//                    print("Name: \(user.name), Email: \(user.email), Password: \(user.password), Profile Image: \(user.profile_image)")
//                }
            }
            .store(in: &cancellables)
    }

    
    func signIn(email: String, password: String) -> Bool {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        print("email: \(email)\npassword: \(password)")
        // Try to find user with matching email
        if let user = users.first(where: { $0.email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == trimmedEmail.lowercased() }) {
            // Email exists, now check password
            if user.password.trimmingCharacters(in: .whitespacesAndNewlines) == trimmedPassword {
                currentUser = user
                print("✅ Sign in successful for user: \(user.name)")
                return true
            } else {
                print("❌ Sign in failed: Password is incorrect for email '\(trimmedEmail)'")
                errorMessage = "Password is incorrect"
                return false
            }
        } else {
            print("❌ Sign in failed: Email '\(trimmedEmail)' not found")
            errorMessage = "Email not found"
            return false
        }
    }

}
