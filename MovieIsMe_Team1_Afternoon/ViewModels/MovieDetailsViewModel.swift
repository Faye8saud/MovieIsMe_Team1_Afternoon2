//
//  MovieDetailsViewModel.swift
//  MovieIsMe_Team1_Afternoon
//
//  Created by wasan hamoud on 10/07/1447 AH.
//

import Foundation
import Combine

@MainActor
final class MovieDetailsViewModel: ObservableObject {

    @Published var movie: MovieRecord?
    @Published var actors: [Actor] = []
    @Published var director: Director?
    @Published var isLoading = false
//    @Published var actors: [ActorRecord] = []



//    func load(movieId: String) async {
//        isLoading = true
//        defer { isLoading = false }
    func load(movieId: String) async {
        print("🚀 load called with movieId:", movieId)

        isLoading = true
        defer { isLoading = false }

        do {
            // 1) Movie full details by record id
            let fullMovie: MovieRecord = try await APIClient.shared.fetchRecord(
                table: "movies",
                recordId: movieId
            )
            self.movie = fullMovie

            // 2) movie_actors -> actor ids
            let movieActors: MovieActorsResponse = try await APIClient.shared.fetch(
                "movie_actors",
                queryItems: [
                    URLQueryItem(name: "filterByFormula", value: "{movie_id}=\"\(movieId)\"")
                ]
                
            )
            print("🎭 movieActors count:", movieActors.records.count)
            print("🎭 actor ids from pivot:", movieActors.records.map { $0.fields.actor_id })

            let actorIds = Set(movieActors.records.map { $0.fields.actor_id })

            // 3) actors -> filter + map to UI Actor
            let allActors: ActorsResponse = try await APIClient.shared.fetch("actors")
            self.actors = allActors.records
                .filter { actorIds.contains($0.id) }
                .map { rec in
                    Actor(
                        id: rec.id,
                        name: rec.fields.name,
                        imageURL: URL(string: rec.fields.image)
                    )
                }

            // 4) movie_directors -> director id
            let movieDirectors: MovieDirectorsResponse = try await APIClient.shared.fetch(
                "movie_directors",
                queryItems: [
                    URLQueryItem(name: "filterByFormula", value: "{movie_id}=\"\(movieId)\"")
                ]
            )
            print("🎬 movieDirectors count:", movieDirectors.records.count)
            print("🎬 movieDirectors records:", movieDirectors.records)

            guard let directorId = movieDirectors.records.first?.fields.director_id else {
                self.director = nil
                return
            }

            // 5) directors -> find + map to UI Director
//            let allDirectors: DirectorsResponse = try await APIClient.shared.fetch("directors")
//            if let match = allDirectors.records.first(where: { $0.id == directorId }) {
//                self.director = Director(
//                    id: match.id,
//                    name: match.fields.name,
//                    imageURL: URL(string: match.fields.image)
//                )
//            } else {
//                self.director = nil
//            }
            let allDirectors: DirectorsResponse = try await APIClient.shared.fetch("directors")
            if let match = allDirectors.records.first(where: { $0.id == directorId }) {
                self.director = Director(
                    id: match.id,
                    name: match.fields.name,
                    imageURL: URL(string: match.fields.image)
                )

                print("✅ Director name:", self.director?.name ?? "nil")
                print("✅ Director imageURL:", self.director?.imageURL?.absoluteString ?? "nil")

            } else {
                self.director = nil
                print("❌ Director not found")
            }


        } catch {
            print("MovieDetailsViewModel error:", error)
        }
    }
}
