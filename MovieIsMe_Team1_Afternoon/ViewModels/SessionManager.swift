//
//  SessionManager.swift
//  MovieIsMe_Team1_Afternoon
//
//  Created by Hissah Alohali on 08/07/1447 AH.
//


import Foundation

enum SessionManager {
    static let userIDKey = "signedInUserID"

    static func saveUserID(_ id: String) {
        UserDefaults.standard.set(id, forKey: userIDKey)
    }

    static func getUserID() -> String? {
        UserDefaults.standard.string(forKey: userIDKey)
    }

    static func clear() {
        UserDefaults.standard.removeObject(forKey: userIDKey)
    }
}
